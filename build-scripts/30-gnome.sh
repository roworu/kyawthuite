#!/usr/bin/env bash

set -ouex pipefail


### install packages

packages=(
    @workstation-product-environment
)

dnf5 -y install "${packages[@]}"


### enable services

preset_file="/usr/lib/systemd/system-preset/01-kyawthuite.preset"

system_services=(
    gdm
)

systemctl enable "${system_services[@]}"

for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done

systemctl --global preset-all
