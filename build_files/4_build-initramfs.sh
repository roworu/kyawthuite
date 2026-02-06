#!/usr/bin/bash

set -eoux pipefail

echo "::group::Executing build-initramfs"
trap 'echo "::endgroup::"' EXIT

KERNEL_PKG="${KERNEL_PKG:-kernel-cachyos}"
QUALIFIED_KERNEL="$(rpm -q --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' "${KERNEL_PKG}" | tail -n1)"

/usr/bin/dracut --no-hostonly \
    --kver "$QUALIFIED_KERNEL" \
    --reproducible \
    --zstd \
    -v \
    --add ostree \
    --add fido2 \
    --add btrfs \
    -f "/usr/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

chmod 0600 "/usr/lib/modules/$QUALIFIED_KERNEL/initramfs.img"
