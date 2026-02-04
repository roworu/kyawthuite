#!/bin/bash

set -ouex pipefail

# cli tools
dnf5 install -y zsh htop


# steam
dnf5 install -y steam

# virt-manager
dnf5 install -y @virtualization
systemctl enable libvirtd
