#!/usr/bin/env bash

set -ouex pipefail

# cli tools
dnf5 install -y zsh htop fastfetch plasma-discover-rpm-ostree

# virt-manager
dnf5 install -y @virtualization; systemctl enable libvirtd
