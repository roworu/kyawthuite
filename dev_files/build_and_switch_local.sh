#!/usr/bin/env bash
set -euo pipefail

cd ..

TARGET_IMAGE=${1:-localhost/kyawthuite}
TAG=${2:-latest}
IMAGE_REF="${TARGET_IMAGE}:${TAG}"

just build "${TARGET_IMAGE}" "${TAG}"

BOOTED_IMAGE=$(sudo bootc status | awk -F': ' '/^Booted image:/ {print $2; exit}')

if [[ "${BOOTED_IMAGE}" == "${IMAGE_REF}" ]]; then
  sudo bootc upgrade
else
  sudo bootc switch --transport containers-storage "${IMAGE_REF}"
fi
