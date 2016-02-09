#!/bin/bash
#
# Script to compile geth and prepare it for staging into snapcraft.
#
# Arguments:
#       - DESTDIR: First argument as required by the script snapcraft plugin
#                  is the destination directory into which the script itself
#                  is responsible of copying the results
#
# WARNING: If you build any architectures with make other than the native one
#          or armhf, this script will eventually invoke docker since it's used
#          by geth's makefile for cross-compiling. Either run it with sudo
#          or better yet follow this guide to allow non-root user invocation
#          of the docker daemon:
#          http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo

if [ $# -ne 1 ]; then
   echo "build_geth - ERROR: Invoked with ${#} parameters while only needing 1";
   exit 1
fi

DEST_DIR=$1

git clone https://github.com/ethereum/go-ethereum.git
if [ $? -ne 0 ]; then
    echo "build_geth - ERROR: Could not clone repository";
    exit 1
fi

cd go-ethereum
git checkout develop
if [ $? -ne 0 ]; then
    echo "build_geth - ERROR: Could not checkout develop";
    exit 1
fi


make geth
if [ $? -ne 0 ]; then
    echo "build_geth - ERROR: Could not build geth";
    exit 1
fi

# Do not use the makefile for geth-linux-arm-7. Assume user has properly
# setup cross compiling for armhf and this way we avoid docker at least for
# the time being
CGO_ENABLED=1 CC=arm-linux-gnueabihf-gcc-5 CXX=arm-linux-gnueabihf-g++-5 GOARCH=arm GOARM=7 build/env.sh go build -o build/bin/geth-linux-arm-7 ./cmd/geth
if [ $? -ne 0 ]; then
    echo "build_geth - ERROR: Could not build geth-linux-arm-7";
    exit 1
fi

EXEC=geth

if [ ! -e "build/bin/geth" -o ! -e "build/bin/geth-linux-arm-7" ]; then
    echo "build_geth - ERROR: Could not find resulting geth binary";
    exit 1
fi

mkdir -p $DEST_DIR/x86_64-linux-gnu/ && cp build/bin/geth $DEST_DIR/x86_64-linux-gnu/geth;
mkdir -p $DEST_DIR/arm-linux-gnueabihf/ && cp build/bin/geth-linux-arm-7 $DEST_DIR/arm-linux-gnueabihf/geth;

if [ $? -ne 0 ]; then
    echo "build_geth - ERROR: Could not properly copy the produced binaries";
    exit 1
fi
