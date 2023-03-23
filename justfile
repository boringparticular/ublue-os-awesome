alias b := build
alias p := push

default: build push

build:
  buildah unshare ./build.sh

push:
  buildah push docker.io/edgecube/ublue-os-awesome:${FEDORA_VERSION:-37}
