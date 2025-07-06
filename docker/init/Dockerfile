FROM gentoo/stage3:amd64-musl-llvm AS build

WORKDIR /

COPY .run.sh /
ARG portage_upgrade=false
RUN exec /.run.sh

FROM scratch
COPY --from=build / /

CMD ["/bin/bash"]
