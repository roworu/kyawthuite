#!/usr/bin/bash

set -ouex pipefail

# https://github.com/CachyOS/copr-linux-cachyos

# 1) install cachy kernel
dnf5 -y copr enable bieszczaders/kernel-cachyos
dnf5 -y --setopt=tsflags=noscripts install kernel-cachyos kernel-cachyos-devel-matched
dnf5 -y copr disable bieszczaders/kernel-cachyos

# 2) setup selinux
setsebool -P domain_kernel_load_modules on
