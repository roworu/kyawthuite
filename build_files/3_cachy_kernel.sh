#!/bin/bash

set -ouex pipefail

dnf5 -y copr enable solopasha/hyprland
dnf5 -y install hyprland
dnf5 -y copr disable solopasha/hyprland
