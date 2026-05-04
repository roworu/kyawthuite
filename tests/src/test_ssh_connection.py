def test_ssh_login(ssh_command):
    result = ssh_command("true")
    assert result.returncode == 0


def test_logged_in_user(ssh_command):
    result = ssh_command("id -un")
    assert result.stdout.strip() == "test_user"

