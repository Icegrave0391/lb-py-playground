#!/bin/bash

source .env

CPYTHON_AUTOCFG="$CPYTHON_DIR/configure.ac"
if [ ! -f "$CPYTHON_AUTOCFG" ]; then
    echo "Error: cpython configure.ac not found at $CPYTHON_AUTOCFG"
    exit 1
fi

log_info "Searching for AC_CHECK* in $CPYTHON_AUTOCFG"

grep -R "AC_CHECK" -n "$CPYTHON_AUTOCFG" | while read -r line; do
    # Extract the file name and line number
    file=$(echo "$line" | cut -d: -f1)
    lineno=$(echo "$line" | cut -d: -f2)
    content=$(echo "$line" | cut -d: -f3-)
    
    # Print the file name and line number
    echo "File: $file, Line: $lineno"
    
    # # Print the line content
    # echo "Content: $content"
done