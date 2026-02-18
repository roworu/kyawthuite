#!/usr/bin/env bash

set -ouex pipefail

dnf5 -v repolist --enabled

dnf5 -y install dnf5-plugins
echo -n "max_parallel_downloads=10" >>/etc/dnf/dnf.conf

# rpmfusion repos
dnf5 -y install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# copr
dnf5 -y config-manager setopt "*fedora*".exclude="kernel-core-* kernel-modules-* kernel-uki-virt-*"
dnf5 -y config-manager setopt "*updates*".exclude="kernel-core-* kernel-modules-* kernel-uki-virt-*"

# packages install
dnf5 -y swap ffmpeg-free ffmpeg --allowerasing -y

dnf5 -y install zsh
