#!/bin/bash
source .env

# Parse command line arguments
while getopts "p:" opt; do
    case $opt in
        p)
            VERSION="$OPTARG"
            ;;
        \?)
            echo "Usage: $0 -p <native|custom>"
            exit 1
            ;;
    esac
done

# Set the Python executable based on the version
if [ -z "$VERSION" ]; then
    echo "Usage: $0 -p <native|custom>"
    exit 1
fi

if [ "$VERSION" == "native" ]; then
    PYTHON=$(which python3)
    if [ -z "$PYTHON" ]; then
        log_err "Error: Python 3 executable not found in PATH."
        log_err "Please ensure Python 3 is installed and available in your PATH."
        exit 1
    fi
elif [ "$VERSION" == "custom" ]; then
    PYTHON="$CPYTHON_OUT_DIR/bin/python3"
    if [ ! -f "$PYTHON" ]; then
        log_err "Error: Custom Python executable not found at $PYTHON."
        log_err "Please build your CPython first."
        exit 1
    fi
else
    log_err "Invalid version specified. Use 'native' or 'custom'."
    exit 1
fi

$PYTHON -S -c "import sys; print(sys.builtin_module_names)"