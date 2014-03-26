gcc -arch x86_64 -O2 *.c -shared -install_name @loader_path/libpng.dylib -o ../../bin/osx64/libpng.dylib -I../zlib -L../../bin/osx64 -lz
