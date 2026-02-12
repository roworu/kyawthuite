#!/usr/bin/env bash
set -euxo pipefail

restore_kernel_install_hooks() {
    local RPMOSTREE=/usr/lib/kernel/install.d/05-rpmostree.install
    local DRACUT=/usr/lib/kernel/install.d/50-dracut.install

    if [[ -f "${RPMOSTREE}.bak" ]]; then
        mv -f "${RPMOSTREE}.bak" "${RPMOSTREE}"
    fi

    if [[ -f "${DRACUT}.bak" ]]; then
        mv -f "${DRACUT}.bak" "${DRACUT}"
    fi
}

disable_kernel_install_hooks() {
    local RPMOSTREE=/usr/lib/kernel/install.d/05-rpmostree.install
    local DRACUT=/usr/lib/kernel/install.d/50-dracut.install

    if [[ -f "${RPMOSTREE}" ]]; then
        mv "${RPMOSTREE}" "${RPMOSTREE}.bak"
        printf '%s\n' '#!/bin/sh' 'exit 0' >"${RPMOSTREE}"
        chmod +x "${RPMOSTREE}"
    fi

    if [[ -f "${DRACUT}" ]]; then
        mv "${DRACUT}" "${DRACUT}.bak"
        printf '%s\n' '#!/bin/sh' 'exit 0' >"${DRACUT}"
        chmod +x "${DRACUT}"
    fi
}

disable_kernel_install_hooks

dnf5 -y remove \
    kernel \
    kernel-core \
    kernel-modules \
    kernel-modules-core \
    kernel-modules-extra &&
    rm -r -f /usr/lib/modules/*

dnf5 -y copr enable bieszczaders/kernel-cachyos-lto

dnf5 -y install --setopt=install_weak_deps=False kernel-cachyos-lto

dnf5 -y copr disable bieszczaders/kernel-cachyos-lto

setsebool -P domain_kernel_load_modules on

restore_kernel_install_hooks


KERNEL_VERSION="$(rpm -q kernel-cachyos-lto --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" || exit 1

TMP_INITRAMFS="$(mktemp)"
DRACUT_NO_XATTR=1 /usr/bin/dracut \
    --no-hostonly \
    --kver "${KERNEL_VERSION}" \
    --reproducible \
    --add ostree \
    --add-drivers "virtio_blk virtio_pci virtio_scsi sd_mod scsi_mod btrfs" \
    -f "${TMP_INITRAMFS}" \
    -v || return 1

install -D -m 0600 "${TMP_INITRAMFS}" "/lib/modules/${KERNEL_VERSION}/initramfs.img"
rm -f "${TMP_INITRAMFS}"