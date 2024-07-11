FROM codeberg.org/linuxusergd/gdsbin-amd64-musl-llvm:latest AS build

WORKDIR /

COPY .run.sh /

RUN exec /.run.sh

FROM scratch
COPY --from=build / /

CMD ["/bin/bash"]
