#!/usr/bin/env bash

set -ouex pipefail

# remove update tray icon
rm /etc/xdg/autostart/org.kde.discover.notifier.desktop || true

# additional packages
dnf5 -y install plasma-discover-rpm-ostree

rm -vf /usr/share/applications/org.kde.kdebugsettings.desktop
rm -vf /usr/share/applications/org.kde.khelpcenter.desktop
rm -vf /usr/share/applications/org.kde.plasma-welcome.desktop

# wallpapers
ln -sf /usr/share/wallpapers/kw-wallpaper.jxl /usr/share/backgrounds/default.jxl
ln -sf /usr/share/wallpapers/kw-wallpaper-darker.jxl /usr/share/backgrounds/default-dark.jxl
rm -f /usr/share/backgrounds/default.xml