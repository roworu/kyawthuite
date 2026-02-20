#!/usr/bin/env bash

set -ouex pipefail


# todo: plasma specific settings

# remove update tray icon
rm /etc/xdg/autostart/org.kde.discover.notifier.desktop || true

# additional packages
dnf5 -y install plasma-discover-rpm-ostree

rm -vf /usr/share/applications/org.kde.kdebugsettings.desktop
rm -vf /usr/share/applications/org.kde.khelpcenter.desktop
rm -vf /usr/share/applications/org.kde.plasma-welcome.desktop