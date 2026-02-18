#!/usr/bin/env bash

set -ouex pipefail


### install packages

packages=(
    plasma-desktop
    plasma-workspace
    plasma-workspace-x11
    sddm
    sddm-breeze
    sddm-wayland-plasma
    xorg-x11-server-Xorg
)

dnf5 -y install "${packages[@]}"


### enable services

preset_file="/usr/lib/systemd/system-preset/01-kyawthuite.preset"

system_services=(
#    plasmalogin
    sddm.service
)

systemctl enable "${system_services[@]}"
systemctl set-default graphical.target

for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done

# systemctl --global preset-all
