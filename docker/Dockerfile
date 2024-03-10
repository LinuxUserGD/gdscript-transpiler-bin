FROM gentoo/stage3:amd64-musl-llvm as build

RUN <<-EOF
    cd /var/db/repos
    echo "Downloading snapshot..."
    curl -L -o gentoo.tar.xz https://github.com/LinuxUserGD/llvm-overlay/releases/download/v1/gentoo.tar.xz
    echo "Extracting..."
    tar xpf gentoo.tar.xz --xattrs-include='*.*' --numeric-owner && rm gentoo.tar.xz && cd -
    echo "dev-python/pdm ~amd64" >> /etc/portage/package.accept_keywords/custom
    echo "dev-python/gdsbin **" >> /etc/portage/package.accept_keywords/custom
    echo "dev-python/Nuitka ~amd64" >> /etc/portage/package.accept_keywords/custom
    echo "dev-python/dep-logic ~amd64" >> /etc/portage/package.accept_keywords/custom
    echo "dev-python/truststore ~amd64" >> /etc/portage/package.accept_keywords/custom
    echo "dev-python/unearth ~amd64" >> /etc/portage/package.accept_keywords/custom
    echo "dev-python/findpython ~amd64" >> /etc/portage/package.accept_keywords/custom
    echo "dev-python/shellingham ~amd64" >> /etc/portage/package.accept_keywords/custom
    echo "Compiling git, eselect-repository..."
    EMERGE_DEFAULT_OPTS="--jobs 6" emerge dev-vcs/git app-eselect/eselect-repository
    echo "Adding custom overlay..."
    eselect repository enable gentoo
    eselect repository add clang-musl git https://github.com/clang-musl-overlay/clang-musl-overlay.git
    eselect repository add LinuxUserGD-overlay git https://codeberg.org/LinuxUserGD/overlay.git
    emerge --sync
    echo "Updating system..."
    EMERGE_DEFAULT_OPTS="--jobs 4" emerge --update --newuse --changed-use --deep --with-bdeps=y --keep-going @installed
    echo "Compiling pdm, go, gdsbin, scons"
    EMERGE_DEFAULT_OPTS="--jobs 4" emerge dev-python/pdm dev-lang/go dev-python/gdsbin::LinuxUserGD-overlay dev-build/scons dev-python/pip net-libs/nodejs::clang-musl
    emerge --oneshot @preserved-rebuild
    emerge -pv --depclean
    rm -rf /var/db/repos/*
    rm -rf /var/tmp/portage/*
    rm -rf /var/cache/distfiles/*
    echo "Compiling butler..."
    git clone https://codeberg.org/LinuxUserGD/butler.git --single-branch --depth 1 && cd butler
    go build
    mv butler .. && cd - && rm -rf butler
    git clone https://github.com/ziglang/zig-pypi.git --single-branch --depth 1
    echo "Building zig-pypi wheel..."
    cd zig-pypi
    pdm install
    pdm run make_wheels.py --version master --platform x86_64-linux
    cd -
    python -m pip install --no-cache-dir zig-pypi/dist/*.whl --break-system-packages
    rm -rf zig-pypi
    echo "Building Pixel Engine (Godot Engine fork)..."
    git clone https://github.com/LinuxUserGD/pixel-engine.git --single-branch --depth 1
    cd pixel-engine
    scons platform=linuxbsd target=template_release arch=x86_64 dev_build=no optimize=size debug_symbols=no separate_debug_symbols=no lto=thin production=yes threads=yes deprecated=no precision=single minizip=no brotli=no xaudio2=no vulkan=no opengl3=no d3d12=no openxr=no use_volk=no disable_exceptions=yes dev_mode=no tests=no fast_unsafe=no compiledb=no verbose=yes progress=yes warnings=extra werror=yes vsproj=no disable_3d=yes disable_advanced_gui=yes modules_enabled_by_default=no no_editor_splash=yes use_precise_math_checks=no scu_build=no linker=mold use_llvm=yes use_static_cpp=no use_coverage=no use_ubsan=no use_asan=no use_lsan=no use_tsan=no use_msan=no use_sowrap=no alsa=no pulseaudio=no dbus=no speechd=no fontconfig=no udev=no x11=no wayland=no libdecor=no touch=no execinfo=no module_astcenc_enabled=no module_basis_universal_enabled=no module_bmp_enabled=no module_camera_enabled=no module_csg_enabled=no module_cvtt_enabled=no module_dds_enabled=no module_enet_enabled=no module_etcpak_enabled=no module_freetype_enabled=no module_gdscript_enabled=yes module_glslang_enabled=no module_gltf_enabled=no module_gridmap_enabled=no module_hdr_enabled=no module_jpg_enabled=no module_jsonrpc_enabled=no module_ktx_enabled=no module_lightmapper_rd_enabled=no module_mbedtls_enabled=no module_meshoptimizer_enabled=no module_minimp3_enabled=no minimp3_extra_formats=no module_mobile_vr_enabled=no module_mono_enabled=no module_msdfgen_enabled=no module_multiplayer_enabled=no module_navigation_enabled=no module_noise_enabled=no module_ogg_enabled=no module_openxr_enabled=no module_raycast_enabled=no module_regex_enabled=no module_squish_enabled=no module_svg_enabled=no module_text_server_adv_enabled=no graphite=no module_text_server_fb_enabled=no module_tga_enabled=no module_theora_enabled=no module_tinyexr_enabled=no module_upnp_enabled=no module_vhacd_enabled=no module_vorbis_enabled=no module_webp_enabled=no module_webrtc_enabled=no module_websocket_enabled=no module_webxr_enabled=no module_xatlas_unwrap_enabled=no module_zip_enabled=no
    mv bin/linux* .. && cd - && rm -rf pixel-engine
    mv linux* godot4
    echo "Compiling Python (pyenv)..."
    curl https://pyenv.run | bash
    . /etc/profile
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    CC=clang CXX=clang++ pyenv install 3.11 && pyenv global 3.11
    cd ~/.pyenv
    rm -rf $(echo * | sed "s/versions//g")
    rm -rf $(echo .*)
    cd -
EOF

FROM scratch
COPY --from=build / /

CMD ["/bin/bash"]