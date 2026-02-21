#!/usr/bin/env bash

set -ouex pipefail

dnf5 repolist --enabled

# copr
dnf5 -y config-manager setopt "*fedora*".exclude="kernel-core-* kernel-modules-* kernel-uki-virt-*"
dnf5 -y config-manager setopt "*updates*".exclude="kernel-core-* kernel-modules-* kernel-uki-virt-*"
dnf5 -y config-manager setopt "*fedora-multimedia*".exclude="akmod-nvidia kmod-nvidia"

# packages install
dnf5 -y swap ffmpeg-free ffmpeg --allowerasing -y

# cli tools
dnf5 -y install zsh fastfetch zram-generator

# virtualization tools (virt manager, etc.)
dnf5 -y install @virtualization

# flatpak setup
flatpak remote-add --if-not-exists --system flathub /etc/flatpak/remotes.d/flathub.flatpakrepo
flatpak remote-modify --system --enable flathub
