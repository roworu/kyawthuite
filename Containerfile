ARG FEDORA_VERSION=${FEDORA_VERSION}

FROM scratch AS ctx
COPY build-scripts /

# FROM quay.io/fedora/fedora-bootc:${FEDORA_VERSION} AS base

FROM ghcr.io/ublue-os/kinoite-main:${FEDORA_VERSION} AS base

# Fix for KeyError: 'vendor' image-builder
RUN mkdir -p /usr/lib/bootupd/updates \
    && cp -r /usr/lib/efi/*/*/* /usr/lib/bootupd/updates

COPY system-files/base /

###
### base image
###

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/00-dnf.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/10-kernel.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/20-services.sh

RUN bootc container lint

###
### plasma desktop image
###

FROM base AS kyawthuite

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/10-image_info.sh

#RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#    --mount=type=tmpfs,dst=/var \
#    --mount=type=tmpfs,dst=/tmp \
#    /ctx/30-plasma.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/99-initramfs.sh

RUN bootc container lint

###
### plasma-nvidia desktop image
###

FROM base AS kyawthuite-nvidia

COPY system-files/nvidia /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/10-nvidia.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/10-image_info.sh

#RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#    --mount=type=tmpfs,dst=/var \
#    --mount=type=tmpfs,dst=/tmp \
#    /ctx/30-plasma.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/99-initramfs.sh

RUN bootc container lint
