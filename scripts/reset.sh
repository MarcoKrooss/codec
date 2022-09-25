#!/bin/bash

CURRENT_DIR=$(dirname $(realpath $0))

if [ -z "$1" ]; then
    echo "No codec user defined!"
    exit 1
fi

if [ -z "$CODEC_USER_DATA" ]; then
    CODEC_USER_DATA="/var/lib/codec"
fi

if [ "$2" != "-f" ] && [ "$2" != "--force" ]; then
    echo "Type 'y' to delete the codec user '$1'"
    echo "Userdata at:'$CODEC_USER_DATA/$1/.codec'"
    read INPUT_VALUE
    if [ "$INPUT_VALUE" != "y" ]; then
        echo "Abort because input was not 'y'!"
        exit 1
    fi
fi

$CURRENT_DIR/close.sh "$1"

echo "Reset .codec folder for '$1'..."
docker run -it --rm \
    -v "$CODEC_USER_DATA/$1/.codec:/app" \
    ubuntu:22.04 \
        rm -rf "/app/*"

echo "Reset ports cache for '$1'..."
docker run -it --rm \
    --name "codeccli-$1-port-helper" \
    -v "$CODEC_USER_DATA/codec_ports:/app" \
    ubuntu:22.04 \
        bash -c \
        "rm -rf /app/$1.start.port && rm -rf /app/$1.count.port"