ARG FEDORA_VERSION=43

FROM scratch AS ctx
COPY build-scripts /

###
### base plasma image
###

FROM ghcr.io/ublue-os/kinoite-main:${FEDORA_VERSION} AS kyawthuite

# Fix for KeyError: 'vendor' image-builder
#RUN mkdir -p /usr/lib/bootupd/updates \
#   && cp -r /usr/lib/efi/*/*/* /usr/lib/bootupd/updates

COPY system-files/base /
COPY system-files/plasma /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/00-image_info.sh

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

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/90-cleanup.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/99-initramfs.sh

RUN bootc container lint

###
### plasma-nvidia desktop image
###

FROM ghcr.io/ublue-os/kinoite-nvidia:${FEDORA_VERSION} AS kyawthuite-nvidia

# Fix for KeyError: 'vendor' image-builder
#RUN mkdir -p /usr/lib/bootupd/updates \
#    && cp -r /usr/lib/efi/*/*/* /usr/lib/bootupd/updates

COPY system-files/base /
COPY system-files/plasma /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/00-image_info.sh

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

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/90-cleanup.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/99-initramfs.sh

RUN bootc container lint

###
### test image
###

FROM ghcr.io/ublue-os/kinoite-main:latest AS kyawthuite-test

COPY system-files/base /
COPY system-files/plasma /

#RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#    --mount=type=tmpfs,dst=/var \
#    --mount=type=tmpfs,dst=/tmp \
#    /ctx/00-dnf.sh

RUN bootc container lint

