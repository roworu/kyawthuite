#!/usr/bin/env bash

set -ouex pipefail

dnf5 -y remove firefox firefox-langpacks \
    plasma-welcome plasma-drkonqi plasma-welcome-fedora plasma-discover-kns kcharselect

# remove update tray icon
rm -vf /etc/xdg/autostart/org.kde.discover.notifier.desktop

# remove some apps from start menu
rm -vf /usr/share/applications/org.kde.kdebugsettings.desktop
rm -vf /usr/share/applications/org.kde.khelpcenter.desktop
rm -vf /usr/share/applications/htop.desktop
rm -vf /usr/share/applications/nvtop.desktop
