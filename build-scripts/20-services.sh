#!/usr/bin/env bash

set -ouex pipefail

system_services=(
  podman.socket
  systemd-resolved.service
)

user_services=(
  podman.socket
)

mask_services=(
  logrotate.timer
  logrotate.service
  akmods-keygen.target
  rpm-ostree-countme.timer
  rpm-ostree-countme.service
  systemd-remount-fs.service
  flatpak-add-fedora-repos.service
  NetworkManager-wait-online.service
  akmods-keygen@akmods-keygen.service
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
