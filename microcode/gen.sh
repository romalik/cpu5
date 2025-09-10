#!/bin/sh
./cpu4mc_compiler $1
for file in microcode_*.bin; do
od -v -A n -t x1 < $file > $file.hex
objcopy --output-target=ihex --input-target=binary $file $file.hex

xxd -p -c1 $file > $file.vhex
cp ./$file.vhex ../schematics/cpu5/
cp ./$file ../schematics/cpu5/
done


