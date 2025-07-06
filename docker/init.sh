#!/bin/bash
pushd gentoo-docker-images > /dev/null
TARGET=stage3-amd64-musl-llvm ./build.sh
popd > /dev/null
sed '' init/run.sh > init/.run.sh
chmod +x init/.run.sh
docker build init -t codeberg.org/linuxusergd/gdsbin-amd64-musl-llvm:latest --progress=plain
rm init/.run.sh
