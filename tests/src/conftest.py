from __future__ import annotations

import os
import stat
import subprocess
import time
from dataclasses import dataclass
from pathlib import Path

import pytest


@dataclass(frozen=True)
class SSHConfig:
    host: str
    port: str
    user: str
    key_path: Path
    connect_timeout: str
    command_timeout: int


@dataclass(frozen=True)
class SSHClient:
    config: SSHConfig

    def run(self, command: str, *, check: bool = True) -> subprocess.CompletedProcess[str]:
        args = [
            "ssh",
            "-i",
            str(self.config.key_path),
            "-o",
            "BatchMode=yes",
            "-o",
            f"ConnectTimeout={self.config.connect_timeout}",
            "-o",
            "StrictHostKeyChecking=no",
            "-o",
            "UserKnownHostsFile=/dev/null",
            "-o",
            "LogLevel=ERROR",
            "-p",
            self.config.port,
            f"{self.config.user}@{self.config.host}",
            command,
        ]
        return subprocess.run(
            args,
            check=check,
            capture_output=True,
            text=True,
            timeout=self.config.command_timeout,
        )


@pytest.fixture(scope="session")
def ssh_key_path() -> Path:
    key_path = Path(os.environ.get("TEST_SSH_KEY", "/ssh/test_user"))
    assert key_path.exists(), f"SSH private key does not exist: {key_path}"
    assert key_path.is_file(), f"SSH private key is not a file: {key_path}"
    return key_path


@pytest.fixture(scope="session")
def ssh_config(ssh_key_path: Path) -> SSHConfig:
    return SSHConfig(
        host=os.environ.get("TEST_SSH_HOST", "127.0.0.1"),
        port=os.environ.get("TEST_SSH_PORT", "2222"),
        user=os.environ.get("TEST_SSH_USER", "test_user"),
        key_path=ssh_key_path,
        connect_timeout=os.environ.get("TEST_SSH_CONNECT_TIMEOUT", "10"),
        command_timeout=int(os.environ.get("TEST_SSH_COMMAND_TIMEOUT", "30")),
    )


@pytest.fixture(scope="session")
def ssh_client(ssh_config: SSHConfig) -> SSHClient:
    return SSHClient(ssh_config)


@pytest.fixture(scope="session")
def ssh_login(ssh_client: SSHClient) -> SSHClient:
    wait_seconds = int(os.environ.get("TEST_SSH_WAIT_SECONDS", "300"))
    deadline = time.monotonic() + wait_seconds
    last_error = ""

    while time.monotonic() < deadline:
        result = ssh_client.run("true", check=False)
        if result.returncode == 0:
            return ssh_client
        last_error = result.stderr.strip() or result.stdout.strip()
        time.sleep(5)

    pytest.fail(f"SSH login did not become ready within {wait_seconds}s: {last_error}")


@pytest.fixture
def ssh_command(ssh_login: SSHClient):
    return ssh_login.run


@pytest.fixture
def private_key_mode(ssh_key_path: Path) -> int:
    return stat.S_IMODE(ssh_key_path.stat().st_mode)
