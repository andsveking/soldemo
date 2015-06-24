set -e

java -jar ../sol/compiler/build/libs/solc.jar -output-dir build demo.sol

llvm-gcc ./build/*.o ../sol/runtime/build/dist/lib/x86_64-darwin/libsol-runtime.a libs/libglfw3.a libfmodex.dylib -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo -o soldemo

./soldemo
