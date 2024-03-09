#!/bin/bash
cd gentoo-docker-images
TARGET=stage3-amd64-musl-llvm ./build.sh
cd -
docker build . -t codeberg.org/linuxusergd/gdsbin-amd64-musl-llvm
