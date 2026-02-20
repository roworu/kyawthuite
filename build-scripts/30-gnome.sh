#!/usr/bin/env bash

set -ouex pipefail

# build extensions
dnf5 -y install glib2-devel
glib-compile-schemas /usr/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com/schemas

dnf5 -y remove glib2-devel
rm -rf /usr/share/gnome-shell/extensions/tmp
