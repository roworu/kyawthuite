#!/usr/bin/env bash

set -ouex pipefail

# disable rpm/dracut kernel hooks
pushd /usr/lib/kernel/install.d
printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install
chmod +x  05-rpmostree.install 50-dracut.install
popd

# remove stock kernels and modules
for pkg in kernel kernel-core kernel-modules kernel-modules-core; do
  rpm --erase $pkg --nodeps
done
rm -rf "/usr/lib/modules/$(ls /usr/lib/modules | head -n1)"
rm -rf /boot/*

# install and lock cachy kernel
dnf5 -y install kernel-cachyos-lto kernel-cachyos-lto-devel-matched
dnf5 versionlock add kernel-cachyos-lto kernel-cachyos-lto-devel-matched
dnf5 -y distro-sync
