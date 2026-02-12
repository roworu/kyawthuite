#!/usr/bin/env bash
set -euxo pipefail

dnf -y remove \
    kernel \
    kernel-* &&
    rm -r -f /usr/lib/modules/*

dnf -y copr enable bieszczaders/kernel-cachyos-lto

dnf -y install --setopt=install_weak_deps=False kernel-cachyos-lto

dnf -y copr disable bieszczaders/kernel-cachyos-lto

dnf clean all
rm -rf /var/cache/dnf