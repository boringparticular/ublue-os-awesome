#!/usr/bin/env bash

set -x

ctr=$(buildah from "ghcr.io/ublue-os/base-main:${FEDORA_VERSION:-37}")

buildah mount "$ctr"

buildah run "$ctr" -- systemctl enable getty@tty1.service

buildah run "$ctr" -- rpm-ostree install \
    alacritty \
    awesome \
    borgbackup \
    dunst \
    fcitx5 \
    fcitx5-hangul \
    fcitx5-configtool \
    gnome-keyring \
    gnome-keyring-pam \
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

buildah umount "$ctr"

buildah commit "$ctr" "docker.io/edgecube/ublue-os-awesome:${FEDORA_VERSION:-37}"

buildah rm "$ctr"
