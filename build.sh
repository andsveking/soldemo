#!/bin/bash

set -e

cd $(dirname $0)
PROJ_DIR=$(pwd)

if [ -z ${SOL_HOME+x} ]; then
    echo "ERROR: SOL_HOME is unset, set it to the install directory of sol compiler!"
    echo "NOTE: download from http://defold-slask.s3-website-eu-west-1.amazonaws.com/sol/sol-0.1.15.tar.gz"
    echo "      or http://defold-slask.s3-website-eu-west-1.amazonaws.com/sol/sol-0.1.15.zip"
    exit 1
fi

${SOL_HOME}/bin/solc --keep --emit obj --output-dir ${PROJ_DIR}/build/demo ${PROJ_DIR}/src/demo.sol

clang --verbose ${PROJ_DIR}/build/demo/*.o ${SOL_HOME}/lib/x86_64-darwin/libsol-runtime.a libs/libglfw3.a libfmodex.dylib -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo -o soldemo
