#!/usr/bin/env bash

set -ouex pipefail

preset_file="/usr/lib/systemd/system-preset/01-kyawthuite.preset"
touch "$preset_file"

system_services=(
  podman.socket
  chronyd.service
  preload.service
  podman-tcp.service
  systemd-homed.service
  systemd-resolved.service
  bootc-fetch-apply-updates.service
)

user_services=(
  podman.socket
  dms-watch.path
  flathub-setup.service
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

systemctl enable "${system_services[@]}"
systemctl mask "${mask_services[@]}"
systemctl --global enable "${user_services[@]}"

for service in "${system_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done

mkdir -p "/etc/systemd/user-preset/"

for service in "${user_services[@]}"; do
  echo "enable $service" >> "$preset_file"
done

systemctl --global preset-all
