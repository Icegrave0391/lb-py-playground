#!/bin/bash
source .env

if [ ! -d "$CPYTHON_DIR" ]; then
    echo "Error: cpython directory not found at $CPYTHON_DIR"
    exit 1
fi

# output directory for cpython build

mkdir -p $CPYTHON_OUT_DIR

# install cpython with minimal configuration
# TODO(chuqi): use newlib's libm and libc (--with-libm and --with-libc)
pushd $CPYTHON_DIR
    ./configure --prefix=$CPYTHON_OUT_DIR \
                --enable-shared=no \
                --with-system-libmpdec=no \
                --with-decimal-contextvars=no \
                --with-doc-strings=no \
                --with-mimalloc=no \
                --with-pymalloc=no \
                --with-c-locale-coercion=no \
                --with-computed-gotos=no \
                --with-remote-debug=no \
                --with-ensurepip=no \

    # make and also dump logs
    mkdir -p $LOG_DIR

    make -j$(nproc) 2>&1 | tee $LOG_DIR/cpython_build.log
    if [ $? -ne 0 ]; then
        log_err "cpython build failed. Check the log at $LOG_DIR/cpython_build.log"
        exit 1
    fi
    
    make install 2>&1 | tee $LOG_DIR/cpython_install.log
    if [ $? -ne 0 ]; then
        log_err "cpython install failed. Check the log at $LOG_DIR/cpython_install.log"
        exit 1
    fi
popd