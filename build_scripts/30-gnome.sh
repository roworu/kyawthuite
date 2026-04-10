#!/usr/bin/env bash
echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

dnf5 -y remove firefox firefox-langpacks \
    gnome-classic-session gnome-tour gnome-extensions-app gnome-system-monitor \
    gnome-initial-setup gnome-shell-extension-background-logo gnome-shell-extension-apps-menu \
    gnome-shell-extension-launch-new-instance gnome-shell-extension-places-menu gnome-shell-extension-window-list

additional_flatpaks=(
    io.missioncenter.MissionCenter
)
printf "%s\n" "${additional_flatpaks[@]}" >> /usr/share/ublue-os/kyawthuite/flatpak/install

rm -vf /usr/share/applications/htop.desktop
rm -vf /usr/share/applications/nvtop.desktop