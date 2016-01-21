#!/bin/bash
#
# Script to compile geth and prepare it for staging into snapcraft.
#
# Arguments:
#       - DESTDIR: First argument as required by the script snapcraft plugin
#                  is the destination directory into which the script itself
#                  is responsible of copying the results
#
# WARNING: This script will eventually invoke docker since it's used
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


make geth geth-linux-arm-7
if [ $? -ne 0 ]; then
    echo "build_geth - ERROR: Could not build geth";
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
