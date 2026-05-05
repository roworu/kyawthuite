import os
import subprocess
from pathlib import Path

import pytest


@pytest.fixture(scope="session")
def ssh_command():
    
    # 1) read config from env
    host = os.getenv("TEST_SSH_HOST", "127.0.0.1")
    port = os.getenv("TEST_SSH_PORT", "2222")
    user = os.getenv("TEST_SSH_USER", "test_user")
    key = Path(os.getenv("TEST_SSH_KEY", "/ssh/test_user"))
    timeout = int(os.getenv("TEST_SSH_COMMAND_TIMEOUT", "180"))

    # 2) fail early if key is missing
    assert key.is_file(), f"SSH key not found: {key}"

    # 3) return callable used in tests
    def run(command: str, check: bool = True):

        # run sent command
        result = subprocess.run(
            [
                "ssh",
                "-i", str(key),
                "-o", "BatchMode=yes",
                "-o", "StrictHostKeyChecking=no",
                "-p", port,
                f"{user}@{host}",
                command,
            ],
            capture_output=True,
            text=True,
            timeout=timeout,
            check=check,
        )
        
        # error handling
        if check and result.returncode != 0:
            raise AssertionError(
                f"Command failed: {command}\n"
                f"Return code: {result.returncode}\n"
                f"STDOUT:\n{result.stdout}\n"
                f"STDERR:\n{result.stderr}"
            )
    
        return result

    return run