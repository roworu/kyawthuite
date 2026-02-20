#!/usr/bin/env bash

set -ouex pipefail


# todo: plasma specific settings

# remove update tray icon
rm /etc/xdg/autostart/org.kde.discover.notifier.desktop || true

# additional packages
dnf5 -y install plasma-discover-rpm-ostree