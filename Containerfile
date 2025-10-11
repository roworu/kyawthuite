### define variables

ARG FEDORA_VERSION="${FEDORA_VERSION:-42}"
ARG BASE_IMAGE="ghcr.io/fedora-bootc/${FEDORA_VERSION}"

### copy build scripts to root
FROM scratch AS ctx
COPY build_files /

### define main desktop build
FROM ${BASE_IMAGE} as kyawthuite

### copy shared settings
COPY system_files/desktop/shared /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
