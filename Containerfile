### build-time configuration
ARG FEDORA_VERSION="${FEDORA_VERSION:-43}"
ARG ARCH="${ARCH:-x86_64}"

ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-base}"
ARG BASE_IMAGE_FLAVOR="${BASE_IMAGE_FLAVOR:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$BASE_IMAGE_FLAVOR}"

ARG BASE_IMAGE="ghcr.io/ublue-os/kinoite-main:$FEDORA_VERSION"
ARG NVIDIA_REF="${NVIDIA_REF:-ghcr.io/bazzite-org/nvidia-drivers:latest-f${FEDORA_VERSION}-${ARCH}}"
ARG NVIDIA_BASE="${NVIDIA_BASE:-kyawthuite}"

################
# CONTEXT STAGE
# holds build scripts and shared files
################

FROM scratch AS ctx
COPY build_files /

################
# KERNEL BUILD
# fetch CachyOS kernel RPMs from COPR
################

FROM fedora:${FEDORA_VERSION} AS kernel-cachyos

# enable COPR repo
RUN dnf -y install dnf-plugins-core && \
    dnf -y copr enable bieszczaders/kernel-cachyos

# install kernel to populate RPM database
RUN dnf -y install \
    kernel-cachyos \
    kernel-cachyos-devel-matched

# export kernel RPM artifacts for consumption by OS build
RUN mkdir -p /rpms/kernel && \
    dnf download \
      --destdir=/rpms/kernel \
      kernel-cachyos \
      kernel-cachyos-core \
      kernel-cachyos-modules \
      kernel-cachyos-devel-matched

RUN dnf clean all

################
# NORMAL OS BUILD
################

FROM $BASE_IMAGE AS kyawthuite
FROM kernel-cachyos AS kernel

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

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=bind,from=kernel,src=/,dst=/rpms/kernel \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/install-kernel

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build-initramfs

RUN bootc container lint

################
# NVIDIA BUILD
################

# todo
