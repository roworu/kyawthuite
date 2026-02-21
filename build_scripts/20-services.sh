#!/usr/bin/env bash

set -ouex pipefail

system_services=(
  podman.socket
  systemd-resolved.service
  libvirtd.service
)

user_services=(
  podman.socket
)

mask_services=(
  # we add these repos manually
  flatpak-add-fedora-repos.service
  systemd-remount-fs.service
  # speed up boot time
  NetworkManager-wait-online.service
  # to not mess with custom kernel installation
  akmods-keygen.target
  akmods-keygen@akmods-keygen.service
  # disable automatic updates download
  bootc-fetch-apply-updates.service
)

# enable/disable system services
systemctl enable "${system_services[@]}"
systemctl mask "${mask_services[@]}"
systemctl --global enable "${user_services[@]}"

preset_file="/usr/lib/systemd/system-preset/01-kyawthuite.preset"
touch "$preset_file"
for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done

# enable user services
mkdir -p "/etc/systemd/user-preset/"
preset_file="/etc/systemd/user-preset/01-kyawthuite.preset"
touch "$preset_file"
for service in "${user_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done

systemctl --global preset-all
