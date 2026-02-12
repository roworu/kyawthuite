#!/usr/bin/env bash

set -eoux pipefail

IMAGE_PRETTY_NAME="kyawthuite"
IMAGE_LIKE="fedora"
HOME_URL="https://github.com/roworu/kyawthuite"
SUPPORT_URL="https://github.com/roworu/kyawthuite"
BUG_SUPPORT_URL="https://github.com/roworu/kyawthuite/issues/"


# OS Release File
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"kyawthuite\"/" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$BUG_SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,}\"/" /usr/lib/os-release
