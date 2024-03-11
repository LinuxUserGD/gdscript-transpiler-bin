#!/bin/bash
#docker system prune -a --volumes
pushd gentoo-docker-images > /dev/null
TARGET=stage3-amd64-musl-llvm ./build.sh
popd > /dev/null
docker build . -t codeberg.org/linuxusergd/gdsbin-amd64-musl-llvm
