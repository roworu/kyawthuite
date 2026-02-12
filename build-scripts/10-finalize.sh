#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

RELEASE="$(rpm -E %fedora)"
DATE=$(date +%Y%m%d)

IMAGE_NAME="Kyawthuite"
IMAGE_ID="kyawthuite"
HOME_URL="https://github.com/roworu/kyawthuite"
SUPPORT_URL="https://github.com/roworu/kyawthuite"
BUG_REPORT_URL="https://github.com/roworu/kyawthuite/issues"

printf '%s\n' "${IMAGE_ID}" > /etc/hostname

sed -i -f - /usr/lib/os-release <<EOF_IN
s|^NAME=.*|NAME="${IMAGE_NAME}"|
s|^ID=.*|ID="${IMAGE_ID}"|
s|^VERSION=.*|VERSION="${RELEASE}.${DATE}"|
s|^PRETTY_NAME=.*|PRETTY_NAME="${IMAGE_NAME} ${RELEASE}.${DATE}"|
s|^HOME_URL=.*|HOME_URL="${HOME_URL}"|
s|^BUG_REPORT_URL=.*|BUG_REPORT_URL="${BUG_REPORT_URL}"|
s|^SUPPORT_URL=.*|SUPPORT_URL="${SUPPORT_URL}"|
s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="${IMAGE_ID}"|
EOF_IN

rm -rf /tmp/* || true
dnf5 clean all

echo "::endgroup::"
