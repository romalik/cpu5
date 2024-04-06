#!/bin/sh


DIR="$(dirname $0)"
echo $DIR
$DIR/cpu5as $1 $1.o || exit
$DIR/cpu5ld $1.o -bss 0x8000 -o $1.bin -v || exit
objcopy --output-target=ihex --input-target=binary $1.bin $1.hex
