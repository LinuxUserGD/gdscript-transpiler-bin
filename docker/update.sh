#!/bin/bash
sed '' update/run.sh > update/.run.sh
chmod +x update/.run.sh
docker build update -t codeberg.org/linuxusergd/gdsbin-amd64-musl-llvm:latest --progress=plain
rm update/.run.sh
