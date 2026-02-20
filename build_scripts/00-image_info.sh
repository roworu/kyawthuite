#!/usr/bin/env bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
DATE=$(date +%Y%m%d)

echo "kyawthuite" | tee "/etc/hostname"
sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME=\"kyawthuite\"|
s|^ID=.*|ID=\"kyawthuite\"|
s|^VERSION=.*|VERSION=\"${RELEASE}.${DATE}\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"kyawthuite ${RELEASE}.${DATE}\"|

EOF