### define variables

ARG FEDORA_VERSION="${FEDORA_VERSION:-43}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-base}"
ARG BASE_IMAGE_FLAVOR="${BASE_IMAGE_FLAVOR:-main}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-$BASE_IMAGE_NAME-$BASE_IMAGE_FLAVOR}"
ARG BASE_IMAGE="ghcr.io/ublue-os/kinoite:stable"

### copy build scripts to root
FROM scratch AS ctx
COPY build_files /

### define main desktop build
FROM $BASE_IMAGE AS kyawthuite

### copy shared settings
COPY system_files/desktop/shared /

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

# FIXME enable cachy kernel install + default boot
#RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#    --mount=type=cache,dst=/var/cache \
#    --mount=type=cache,dst=/var/log \
#    --mount=type=tmpfs,dst=/tmp \
#    /ctx/3_cachy_kernel.sh


### linter
## verify final image and contents are correct.
RUN bootc container lint
