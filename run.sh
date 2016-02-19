set -e

if [ -z ${SOL_HOME+x} ]; then
    echo "ERROR: SOL_HOME is unset, set it to the install directory of sol compiler!"
    echo "ERROR: donwload from http://defold-slask.s3-website-eu-west-1.amazonaws.com/sol/sol-0.1.14.tar.gz"
    exit 1
fi

${SOL_HOME}/bin/solc --emit obj --keep -output-dir build demo.sol

llvm-gcc --verbose ./build/*.o ${SOL_HOME}/lib/x86_64-darwin/libsol-runtime.a libs/libglfw3.a libfmodex.dylib -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo -o soldemo

./soldemo
