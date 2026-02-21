#!/usr/bin/env bash

set -ouex pipefail

find /etc/yum.repos.d/ -maxdepth 1 -type f -name '*.repo' ! -name 'fedora.repo' ! -name 'fedora-updates.repo' ! -name 'fedora-updates-testing.repo' -exec rm -f {} +

dnf5 clean all
rm -rf /tmp/* || true
rm -rf /var/log/dnf5.log || true

# Remove desktop files
rm -vf /usr/share/applications/htop.desktop
rm -vf /usr/share/applications/nvtop.desktop