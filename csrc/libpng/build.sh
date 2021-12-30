${X}gcc -c -O2 -DPNG_INTEL_SSE $C *.c intel/*.c -I../zlib
${X}gcc *.o -shared -o ../../bin/$P/$D -L../../bin/$P -lz $L
rm -f      ../../bin/$P/$A
${X}ar rcs ../../bin/$P/$A *.o
rm *.o
