[ "${portage_upgrade}" = true ] && echo "Upgrading image..." || true && \
[ "${portage_upgrade}" = false ] && echo "Installing image..." || true && \
rm -rf /etc/portage/package.use/* /etc/portage/package.accept_keywords/* /etc/portage/package.mask/* && \
echo '*/* ~amd64' > /etc/portage/package.accept_keywords/base.conf && \
echo 'dev-lang/python **' > /etc/portage/package.accept_keywords/python.conf && \
echo 'dev-games/godot **' > /etc/portage/package.accept_keywords/godot.conf && \
echo '*/* compiler-rt default-compiler-rt default-libcxx default-lld libcxx -offload openmp -polly sanitize llvm-libunwind clang' > /etc/portage/package.use/clang.conf && \
echo '*/* full-stdlib sqlite' > /etc/portage/package.use/python.conf && \
echo 'net-misc/curl -curl_quic_openssl -quic -http3 -httpsrr -adns' > /etc/portage/package.use/curl.conf && \
echo 'dev-vcs/git -perl' > /etc/portage/package.use/git.conf && \
echo 'app-alternatives/ninja -reference samurai' > /etc/portage/package.use/ninja.conf && \
echo "media-libs/freetype harfbuzz brotli" > /etc/portage/package.use/freetype.conf && \
echo "media-libs/harfbuzz icu" > /etc/portage/package.use/harfbuzz.conf && \
echo "media-libs/vulkan-loader X" > /etc/portage/package.use/vulkan.conf && \
echo '=dev-lang/python-3.13.9999' >> /etc/portage/package.mask/python.conf && \
echo '=dev-lang/python-3.14.9999' >> /etc/portage/package.mask/python.conf && \
echo '=dev-lang/python-3.15.9999' >> /etc/portage/package.mask/python.conf && \
echo '=dev-util/patchelf-0.18.0' >> /etc/portage/package.mask/patchelf.conf && \
echo 'sys-devel/gcc' > /etc/portage/package.mask/gcc.conf && \
echo 'EMERGE_DEFAULT_OPTS="--jobs 4"' >> /etc/portage/make.conf && \
echo 'LTO_ERR="-Werror=odr -Werror=conditional-type-mismatch -Werror=pointer-type-mismatch -Werror=selector-type-mismatch -Werror=strict-aliasing -Wno-implicit-function-declaration -Wno-sizeof-pointer-memaccess"' >> /etc/portage/make.conf && \
echo 'COMMON_FLAGS="-O3 -pipe -march=native -g0 -D_FORTIFY_SOURCE=3 -flto=thin"' >> /etc/portage/make.conf && \
echo 'CFLAGS="${COMMON_FLAGS}"' >> /etc/portage/make.conf && \
echo 'CXXFLAGS="${COMMON_FLAGS} ${LTO_ERR} -stdlib=libc++"' >> /etc/portage/make.conf && \
echo 'LDFLAGS="-Wl,-O3 -Wl,--as-needed -Wl,--strip-debug -Wl,--undefined-version -Wl,--icf=safe -Wl,--threads=4 -rtlib=compiler-rt -unwindlib=libunwind -stdlib=libc++ -fuse-ld=lld"' >> /etc/portage/make.conf && \
echo 'LD="ld.lld"' >> /etc/portage/make.conf && \
echo 'FEATURES="-config-protect-if-modified"' >> /etc/portage/make.conf && \
echo 'NINJA=samu' >> /etc/portage/make.conf && \
perl -i -ne 'print if ! $x{$_}++' /etc/portage/make.conf && \
wget --progress=dot:mega -O - https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz | tar -xz && \
mv gentoo-master /var/db/repos/gentoo && \
etc-update --automode -5 && \
emerge --oneshot --update --newuse --changed-use --deep --with-bdeps=y --keep-going @installed --backtrack=10000 || true && \
emerge net-misc/curl dev-python/pip --update && \
emerge app-alternatives/ninja --update && \
emerge dev-lang/go dev-python/nuitka dev-util/patchelf dev-vcs/git --update && \
emerge app-eselect/eselect-repository --update && \
eselect repository add 12101111-overlay git https://github.com/12101111/overlay.git &> /dev/null || true && \
emerge --sync 12101111-overlay && \
emerge llvm-runtimes/libatomic-stub --update && \
emerge dev-games/godot net-libs/nodejs dev-util/ruff --update && \
emerge llvm-core/llvm-conf --update && \
emerge --depclean && \
[ "${portage_upgrade}" = true ] && emerge --oneshot --update --newuse --changed-use --deep --with-bdeps=y --keep-going @installed || true && \
[ "${portage_upgrade}" = true ] && emerge --depclean || true && \
rm -r /var/db/repos/* /var/cache/distfiles/*
