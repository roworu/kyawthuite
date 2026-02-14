#!/bin/bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

shopt -s nullglob

packages=(
    # for controllers to work
    steam-devices

    # devtools
    distrobox
    podman
    podman-compose
    git

    # codecs / multimedia
    @multimedia
    libheif-freeworld
    qt-heif-image-plugin

    # fonts
    jetbrains-mono-fonts

    # package managment
    flatpak plasma-discover-rpm-ostree

    # cli tools
    zsh
    fastfetch
)

dnf5 -y install "${packages[@]}"

dnf5 -y swap ffmpeg-free ffmpeg --allowerasing

packages=(
    # games
    kmahjongg
    kmines
    kpat

    # preinstalled apps
    akregator
    kmail
    headerthemeeditor
    ktn
    neochat
    pimdataexporter
    sieveeditor
    kmousetool
    kmouth
    im-chooser
    korganizer
    kaddressbook
    khelpcenter
    dragon
    elisa-player
    kamoso
    kolourpaint
    skanpage
    k3b
    gcdmaster
    qrca
    ktorrent
    kdeconnect
    nwg-panel
    mediawriter
    krusader
    digikam
    showfoto
    uuctl
    firefox
)

dnf5 -y remove "${packages[@]}"


curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo && \
echo "Default=true" | tee -a /etc/flatpak/remotes.d/flathub.flatpakrepo > /dev/null
flatpak remote-add --if-not-exists --system flathub /etc/flatpak/remotes.d/flathub.flatpakrepo
flatpak remote-modify --system --enable flathub

echo "::endgroup::"
