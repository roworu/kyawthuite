#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

RELEASE="$(rpm -E %fedora)"
DATE=$(date +%Y%m%d)

echo "kyawthuite" | tee "/etc/hostname"
sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME=\"kyawthuite\"|
s|^ID=.*|ID=\"kyawthuite\"|
s|^VERSION=.*|VERSION=\"${RELEASE}.${DATE}\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"kyawthuite ${RELEASE}.${DATE}\"|
s|^LOGO=.*|LOGO=\"cachyos\"|

/^REDHAT_BUGZILLA_PRODUCT=/d
/^REDHAT_BUGZILLA_PRODUCT_VERSION=/d
/^REDHAT_SUPPORT_PRODUCT=/d
/^REDHAT_SUPPORT_PRODUCT_VERSION=/d
EOF

find /etc/yum.repos.d/ -maxdepth 1 -type f -name '*.repo' ! -name 'fedora.repo' ! -name 'fedora-updates.repo' ! -name 'fedora-updates-testing.repo' -exec rm -f {} +
rm -rf /tmp/* || true
dnf5 clean all

echo "::endgroup::"
