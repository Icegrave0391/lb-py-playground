#!/bin/bash
source .env
set -euo pipefail

if [ ! -d "$NEWLIB_DIR" ]; then
    echo "Error: Newlib directory not found at $NEWLIB_DIR"
    exit 1
fi

mkdir -p "$NEWLIB_OUT_DIR"

# —— Auto-detect triples —— #
pushd "${NEWLIB_DIR}"
    TRIPLE="$(./config.guess)"  # e.g. x86_64-pc-linux-gnu 
popd

CROSS_TARGET="${CROSS_TARGET:-x86_64-litebox}"
export PREFIX="$COMPILE_TOOLCHAIN_OUT"

###
# Build newlib for litebox
###

export OLD_PATH=$PATH
export PATH=$PREFIX/bin:$PATH

pushd $NEWLIB_OUT_DIR
# pushd "$NEWLIB_DIR"
    log_info "Building Newlib for target: litebox"
    # make distclean || true

    $NEWLIB_DIR/configure \
        --prefix="$PREFIX" \
        --target="$CROSS_TARGET" \
        --disable-multilib \
        --disable-werror 

    # todo(chuqi): figure out how to automatically fix makefile.in to track .tpo correctly
    # manually create the .deps directory for now
    mkdir -p "$NEWLIB_OUT_DIR/$CROSS_TARGET/newlib/libc/sys/litebox/.deps"
    
    make -j$(nproc) 2>&1 | tee "$LOG_DIR/newlib_build_litebox.log"

    make install 2>&1 | tee "$LOG_DIR/newlib_install_litebox.log"
popd

export PATH=$OLD_PATH