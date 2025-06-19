#!/bin/bash
set -euo pipefail
source .env

if [ ! -d "$CPYTHON_DIR" ]; then
    echo "Error: CPython directory not found at $CPYTHON_DIR"
    exit 1
fi

# Output directory for CPython build
mkdir -p "$CPYTHON_OUT_DIR"

# Make and also dump logs
mkdir -p "$LOG_DIR"

pushd "$CPYTHON_DIR"
    make distclean || true

    export CONFIG_SITE="$SCRIPT_DIR/config.site"
    # TODO(chuqi): use newlib's libm and libc (--with-libm and --with-libc)
    # TODO(chuqi): enable optimizations in the future by --enable-optimizations
    ./configure --prefix="$CPYTHON_OUT_DIR" \
                --enable-shared=no \
                --enable-ipv6=no \
                --with-system-libmpdec=no \
                --with-decimal-contextvar=no \
                --with-doc-strings=no \
                --with-mimalloc=no \
                --with-pymalloc=no \
                --with-c-locale-coercion=no \
                --with-computed-gotos=no \
                --with-remote-debug=no \
                --disable-test-modules \
                --with-ensurepip=no | tee "$LOG_DIR/cpython_configure.log"    

    set +e
    make -j$(nproc) 2>&1 | tee "$LOG_DIR/cpython_build.log"
    if [ $? -ne 0 ]; then
        log_err "CPython build failed. Check the log at $LOG_DIR/cpython_build.log"
        exit 99
    fi
    set -e
    
    # todo(chuqi): debugging
    exit 1

    make install 2>&1 | tee "$LOG_DIR/cpython_install.log"
    if [ $? -ne 0 ]; then
        log_err "CPython install failed. Check the log at $LOG_DIR/cpython_install.log"
        exit 1
    fi
popd