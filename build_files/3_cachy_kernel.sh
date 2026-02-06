#!/usr/bin/bash

set -ouex pipefail

# sources:
# 1) installation method:
# https://github.com/ublue-os/bazzite/blob/main/build_files/install-kernel
# 2) kernel itself:
# https://github.com/CachyOS/copr-linux-cachyos

dnf5 -y copr enable bieszczaders/kernel-cachyos

echo "::group::Executing install-kernel"
trap 'echo "::endgroup::"' EXIT

# create a shims to bypass kernel install triggering dracut/rpm-ostree
# seems to be minimal impact, but allows progress on build
pushd /usr/lib/kernel/install.d
mv 05-rpmostree.install 05-rpmostree.install.bak
mv 50-dracut.install 50-dracut.install.bak
printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install
chmod +x  05-rpmostree.install 50-dracut.install
popd

dnf5 -y remove --no-autoremove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

pkgs=(
    kernel-cachyos
    kernel-cachyos-devel-matched
)

dnf5 -y install $pkgs

dnf5 versionlock add $pkgs

pushd /usr/lib/kernel/install.d
mv -f 05-rpmostree.install.bak 05-rpmostree.install
mv -f 50-dracut.install.bak 50-dracut.install
popd

dnf5 -y copr disable bieszczaders/kernel-cachyos
