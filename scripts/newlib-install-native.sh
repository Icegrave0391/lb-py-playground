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

pushd $NEWLIB_OUT_DIR
    log_info "Building Newlib for native target: $TRIPLE"
    make distclean || true

    $NEWLIB_DIR/configure \
        --prefix="$NEWLIB_OUT_DIR" \
        --target="x86_64-elf" \
        --with-newlib \
        --disable-multilib
    
    make -j$(nproc) 2>&1 | tee "$LOG_DIR/newlib_build_native.log"

    make install 2>&1 | tee "$LOG_DIR/newlib_install_native.log"
popd
