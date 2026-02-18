ARG FEDORA_VERSION=43

FROM scratch AS ctx
COPY build-scripts /

###
### base plasma image
###

FROM ghcr.io/ublue-os/kinoite-main:${FEDORA_VERSION} AS kyawthuite

COPY system-files/base /
COPY system-files/plasma /
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /

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
    /ctx/90-initramfs.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/99-cleanup.sh

RUN bootc container lint

###
### plasma-nvidia desktop image
###

FROM ghcr.io/ublue-os/kinoite-nvidia:${FEDORA_VERSION} AS kyawthuite-nvidia

COPY system-files/base /
COPY system-files/plasma /
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /

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
    /ctx/90-initramfs.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/99-cleanup.sh

RUN bootc container lint

###
### test image
###

FROM ghcr.io/ublue-os/kinoite-main:latest AS kyawthuite-test

COPY system-files/base /
COPY system-files/plasma /
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /

#RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#    --mount=type=tmpfs,dst=/var \
#    --mount=type=tmpfs,dst=/tmp \
#    /ctx/00-dnf.sh

RUN bootc container lint

