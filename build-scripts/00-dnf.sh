#!/usr/bin/env bash

set -ouex pipefail

dnf5 -y install dnf5-plugins
echo -n "max_parallel_downloads=10" >>/etc/dnf/dnf.conf

# rpmfusion repos
dnf5 -y install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# terra repos
dnf5 -y install --nogpgcheck --repofrompath \
  'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras,-mesa}

# copr
dnf5 -y config-manager setopt "*fedora*".exclude="mesa-* kernel-core-* kernel-modules-* kernel-uki-virt-* kernel-core"
dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable che/nerd-fonts

# packages install
dnf5 -y swap ffmpeg-free ffmpeg --allowerasing -y

dnf5 -y install zsh
