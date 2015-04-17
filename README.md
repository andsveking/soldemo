# soldemo

    java -jar build/libs/solc.jar demo/demo.sol && llvm-gcc demo.o io.o sol.o ../runtime/build/dist/lib/x86_64-darwin/libsol-runtime.a libglfw3.a libfmodex.dylib -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo


