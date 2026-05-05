import pytest

@pytest.mark.parametrize("service", [
    "cups",
    "dbus",
    "systemd-journald",
    ""
])
def test_systemd_service_toggle(ssh_command, service):

    # 1) stop service
    ssh_command(f"systemctl stop {service}")

    # 2) verify it stopped
    state = ssh_command(f"systemctl is-active {service}").stdout.strip()
    assert state in ("inactive", "failed"), f"Service did not stop: {state}"

    # 3) start service again
    ssh_command(f"systemctl start {service}")

    # 4) verify it active again
    state = ssh_command(f"systemctl is-active {service}").stdout.strip()
    assert state == "active", f"Service did not start: {state}"


def test_ipv4_connectivity(ssh_command):
    ssh_command("ping google.com -c 3 -4")
