FROM scratch AS ctx
COPY build_scripts /

###
### base plasma image
###
FROM ghcr.io/ublue-os/kinoite-main:43 AS kinoite
COPY system_files/base /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/00-base.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/90-finilize.sh

RUN bootc container lint

###
### plasma-nvidia image
###
FROM ghcr.io/ublue-os/kinoite-nvidia:43 AS kinoite-nvidia
ARG INSTALL_NVIDIA="TRUE"
ENV INSTALL_NVIDIA=${INSTALL_NVIDIA}

COPY system_files/base /
COPY system_files/nvidia /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/00-base.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/90-finilize.sh

RUN bootc container lint
