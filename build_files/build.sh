#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y ptyxis nautilus zsh

# install Hyprland copr repository and Hyprland packages
dnf5 -y copr enable solopasha/hyprland
dnf5 -y install hyprland
dnf5 -y copr disable solopasha/hyprland

# enable services
systemctl enable podman.socket
