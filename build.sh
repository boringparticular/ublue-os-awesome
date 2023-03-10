#!/usr/bin/env bash

set -x
ctr=$(buildah from "ghcr.io/ublue-os/base-main:${FEDORA_VERSION:-37}")

builda run "$ctr" -- systemctl enable getty@tty1.service

buildah run "$ctr" -- rpm-ostree install \
    alacritty \
    awesome \
    borgbacksp \
    dunst \
    fcitx5 \
    fcitx5-hangul \
    fcitx5-configtool \
    gnome-keyring \
    net-tools \
    network-manager-applet \
    sxhkd \
    rofi \
    stow \
    tmux \
    util-linux-user \
    volumeicon \
    xsecurelock \
    zsh && \
    rpm-ostree cleanup -m && \
    ostree container commit

## Commit this container to an image name
buildah commit "$ctr" "docker.io/edgecube/ublue-os-awesome:${FEDORA_VERSION:-37}"
