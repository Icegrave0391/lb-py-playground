#!/bin/bash
source .env
set -euo pipefail

if [ ! -d "$CROSS_BINUTILS_DIR" ]; then
    pushd $PROJ_DIR
        wget https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.xz
        tar xf binutils-2.40.tar.xz
        rm -rf binutils-2.40.tar.xz
    popd
fi

CROSS_TARGET=${CROSS_TARGET:-x86_64-litebox}

mkdir -p "$CROSS_BINUTILS_OUT_DIR"
mkdir -p "$COMPILE_TOOLCHAIN_OUT"

PREFIX="$COMPILE_TOOLCHAIN_OUT"

pushd ${CROSS_BINUTILS_OUT_DIR}
    log_info "Building Binutils for target: $CROSS_TARGET"
    make distclean || true

    $CROSS_BINUTILS_DIR/configure \
        --prefix=$PREFIX \
        --target=$CROSS_TARGET \
        --with-sysroot="$PREFIX" \
        --disable-nls \
        --disable-multilib \
        --disable-sim \
        --disable-werror

    make -j$(nproc) 2>&1 | tee "$LOG_DIR/cross_binutils_build.log"

    make install 2>&1 | tee "$LOG_DIR/cross_binutils_install.log"
popd
