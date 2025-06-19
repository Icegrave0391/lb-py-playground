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


function cpython_configure_and_build() {
    local ac_cv_func="$1"
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
        make -j$(nproc) 2>&1 | tee "$LOG_DIR/cpython_build_${ac_cv_func}.log"
        if [ $? -ne 0 ]; then
            log_err "CPython build failed. Check the log at $LOG_DIR/cpython_build_${ac_cv_func}.log"
    popd
            return 99
        fi
        set -e
    popd
        return 0
}

# Read functions from ac_cv_func_remains and process each one
while IFS= read -r func; do
    # Skip empty lines
    [ -z "$func" ] && continue
    
    echo "Processing function: $func"
    
    # Add the function to config.site
    echo "ac_cv_func_${func}=no" >> "$SCRIPT_DIR/config.site"
    
    # Try to build with this function disabled
    cpython_configure_and_build "$func"
    ret=$?
    
    echo "retrun code: $ret"
    if [ $ret -eq 0 ]; then
        echo "Build successful with ac_cv_func_${func}=no - keeping the line"
    elif [ $ret -eq 99 ]; then
        echo "Build failed with ac_cv_func_${func}=no - commenting out the line"
        # Remove the last line and add it back as a comment
        sed -i '$d' "$SCRIPT_DIR/config.site"
        echo "# ac_cv_func_${func}=no" >> "$SCRIPT_DIR/config.site"
    fi
done < ac_cv_func_remains