#!/usr/bin/bash

set -ouex pipefail

# https://github.com/CachyOS/copr-linux-cachyos

# 1) install cachy kernel
dnf5 -y copr enable bieszczaders/kernel-cachyos
dnf5 -y install kmod
dnf5 -y install \
  kernel-cachyos \
  kernel-cachyos-core \
  kernel-cachyos-modules \
  kernel-cachyos-modules-extra \
  kernel-cachyos-devel-matched
dnf5 -y remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra
dnf5 -y copr disable bieszczaders/kernel-cachyos

# 2) setup selinux
if command -v setsebool >/dev/null 2>&1 && command -v selinuxenabled >/dev/null 2>&1 && selinuxenabled; then
  setsebool -P domain_kernel_load_modules on
fi
