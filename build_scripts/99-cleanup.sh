#!/usr/bin/env bash

set -ouex pipefail


cleanup() {

    dnf5 -y clean all

    rm -rfv /etc/yum.repos.d/*cachyos*
    rm -rfv /tmp/*
    rm -rfv /var/log/dnf5.log

    # from 00-base.sh kernel installation
    rm -fv /usr/lib/kernel/install.d/05-rpmostree.install
    rm -fv /usr/lib/kernel/install.d/50-dracut.install

}


cleanup