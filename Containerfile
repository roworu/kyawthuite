### define variables

ARG FEDORA_VERSION="${FEDORA_VERSION:-43}"
ARG ARCH="${ARCH:-x86_64}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-base}"
ARG BASE_IMAGE_FLAVOR="${BASE_IMAGE_FLAVOR:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$BASE_IMAGE_FLAVOR}"
ARG BASE_IMAGE="ghcr.io/ublue-os/kinoite-main:$FEDORA_VERSION"
ARG NVIDIA_REF="${NVIDIA_REF:-ghcr.io/bazzite-org/nvidia-drivers:latest-f${FEDORA_VERSION}-${ARCH}}"
ARG NVIDIA_BASE="${NVIDIA_BASE:-kyawthuite}"

FROM scratch AS ctx
COPY build_files /

FROM ${NVIDIA_REF} AS nvidia

################
# NORMAL BUILD
################

FROM $BASE_IMAGE AS kyawthuite

### copy shared settings
COPY system_files/shared /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/0_image_info.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/1_install_base_packages.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/2_enable_services.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/3_cachy_kernel.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/4_build-initramfs.sh

## verify final image and contents are correct.
RUN bootc container lint

################
# NVIDIA BUILD
################

FROM ${NVIDIA_BASE} AS kyawthuite-nvidia

ARG IMAGE_NAME="${IMAGE_NAME:-kyawthuite-nvidia}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-roworu}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-stable}"
ARG VERSION_TAG="${VERSION_TAG}"
ARG VERSION_PRETTY="${VERSION_PRETTY}"

COPY system_files/nvidia/shared /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=bind,from=nvidia,src=/,dst=/rpms/nvidia \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/install-nvidia && \
    /ctx/4_build-initramfs.sh

## verify final image and contents are correct.
RUN bootc container lint
