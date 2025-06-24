#!/bin/bash
source .env
set -euo pipefail

if [ ! -d "$CROSS_GCC_DIR" ]; then
    pushd $PROJ_DIR
        wget https://ftp.gnu.org/gnu/gcc/gcc-12.4.0/gcc-12.4.0.tar.xz
        tar xf gcc-12.4.0.tar.xz
        rm -rf gcc-12.4.0.tar.xz
    popd
fi


mkdir -p "$CROSS_GCC_OUT_DIR"
CROSS_TARGET=${CROSS_TARGET:-x86_64-litebox}

export PREFIX=$COMPILE_TOOLCHAIN_OUT
export SYSROOT=$PREFIX

stage0() {\
    pushd $CROSS_GCC_DIR
        ./contrib/download_prerequisites
    popd

    pushd $CROSS_GCC_OUT_DIR
        log_info "Building gcc for target: $CROSS_TARGET"
        # make distclean || true

        $CROSS_GCC_DIR/configure \
            --prefix=$PREFIX \
            --target=$CROSS_TARGET \
            --with-sysroot=$PREFIX \
            --disable-werror \
            --disable-multilib \
            --disable-nls \
            --disable-libssp \
            --disable-libquadmath \
            --disable-libquadmath-support \
            --enable-languages=c,c++ \
            --with-newlib 

        make -j$(nproc) all-gcc all-target-libgcc 2>&1 | tee "$LOG_DIR/cross_gcc_stage0_build.log"
        make install-gcc install-target-libgcc 2>&1 | tee "$LOG_DIR/cross_gcc_stage0_install.log"
    popd
}

stage0

# pushd ${CROSS_GCC_OUT_DIR}
#     log_info "Building gcc for target: $CROSS_TARGET"
#     make distclean || true

#     $CROSS_GCC_DIR/configure \
#         --prefix="$HOME/local" \
#         --target=$CROSS_TARGET \
#         --disable-werror \
#         --disable-multilib \
#         --with-as=/usr/bin/as \
#         --with-ld=/usr/bin/ld \
#         --disable-libssp \
#         --disable-libquadmath \
#         --disable-libstdcxx \
#         --enable-languages=c,c++
    
#     make -j$(nproc) 2>&1 | tee "$LOG_DIR/cross_gcc_build.log"
#     sudo make install 2>&1 | tee "$LOG_DIR/cross_gcc_install.log"

#     # also create a symlink for the x86_64-elf-cc
#     if [ ! -f "$HOME/local/bin/x86_64-elf-cc" ]; then
#         sudo ln -s "$HOME/local/bin/x86_64-elf-gcc" "$HOME/local/bin/x86_64-elf-cc"
#     fi
# popd
