gcc -O2 -s -static-libgcc -fPIC *.c -shared -o ../../bin/linux64/libpng.so -I../zlib -L../../bin/linux64 -lz
