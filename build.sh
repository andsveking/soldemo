#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: build.sh <prog>"
    echo "   for example: $ build.sh demo"
    echo "   compiles ./src/demo.sol into binary ./demo"
fi

cd $(dirname $0)
PROJ_DIR=$(pwd)
PROG_NAME=$1

if [ -z ${SOL_HOME+x} ]; then
    echo "ERROR: SOL_HOME is not set, set it to the install directory of sol compiler!"
    echo "NOTE: download from http://defold-slask.s3-website-eu-west-1.amazonaws.com/sol/sol-0.1.15.tar.gz"
    echo "      or http://defold-slask.s3-website-eu-west-1.amazonaws.com/sol/sol-0.1.15.zip"
    exit 1
fi

MAIN_SRC_FILE=${PROJ_DIR}/src/${PROG_NAME}.sol

if [ ! -f ${MAIN_SRC_FILE} ]; then
	echo "File not found: ${MAIN_SRC_FILE}"
	exit 1
fi

${SOL_HOME}/bin/solc --keep --emit obj --output-dir ${PROJ_DIR}/build/${PROG_NAME} ${MAIN_SRC_FILE}

clang --verbose ${PROJ_DIR}/build/${PROG_NAME}/*.o ${SOL_HOME}/lib/x86_64-darwin/libsol-runtime.a libs/libglfw3.a libfmodex.dylib -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo -o ${PROG_NAME}
