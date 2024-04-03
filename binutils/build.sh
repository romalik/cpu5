#!/bin/sh

../binutils/cpu5as $1 $1.o 
../binutils/cpu5ld $1.o -bss 0x8000 -o $1.bin
objcopy --output-target=ihex --input-target=binary $1.bin $1.hex
