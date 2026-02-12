#!/usr/bin/env bash
set -euxo pipefail

# 1) Enable Cachy COPR
dnf -y copr enable bieszczaders/kernel-cachyos-lto

# 2) Install Cachy kernel alongside existing one
dnf -y install --setopt=install_weak_deps=False kernel-cachyos-lto

# 3) Disable COPR
dnf -y copr disable bieszczaders/kernel-cachyos-lto

# 4) Clean caches to keep image small
dnf clean all
rm -rf /var/cache/dnf

