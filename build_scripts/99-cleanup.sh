#!/usr/bin/env bash

set -ouex pipefail

find /etc/yum.repos.d/ -maxdepth 1 -type f -name '*.repo' ! -name 'fedora.repo' ! -name 'fedora-updates.repo' ! -name 'fedora-updates-testing.repo' -exec rm -f {} +
rm -rf /tmp/* || true

# Remove desktop files
rm -vf /usr/share/applications/htop.desktop
rm -vf /usr/share/applications/nvtop.desktop