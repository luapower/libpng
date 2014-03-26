gcc -arch i386 -O2 *.c -shared -install_name @loader_path/libpng.dylib -o ../../bin/osx32/libpng.dylib -I../zlib -L../../bin/osx32 -lz
