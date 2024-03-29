#!/usr/bin/env bash

set -x

ctr=$(buildah from "ghcr.io/ublue-os/base-main:${FEDORA_VERSION:-37}")

buildah mount "$ctr"

buildah run "$ctr" -- systemctl enable getty@tty1.service

buildah run "$ctr" -- rpm-ostree install \
    alacritty \
    awesome \
    borgbackup \
    dbus-x11 \
    dunst \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-hangul \
    gnome-keyring \
    gnome-keyring-pam \
    network-manager-applet \
    rofi \
    sxhkd \
    volumeicon \
    xsecurelock \
    xset \
    xsetroot \
    xss-lock \
    zsh && \
    rpm-ostree remove firefox firefox-langpacks && \
    rpm-ostree cleanup -m && \
    ostree container commit

buildah run "$ctr" -- flatpak remote-modify --enable flathub

buildah umount "$ctr"

buildah commit "$ctr" "docker.io/edgecube/ublue-os-awesome:${FEDORA_VERSION:-37}"

buildah rm "$ctr"
