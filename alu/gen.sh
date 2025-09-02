#!/bin/sh
./alu_generator
for file in alu_*.bin; do
objcopy --output-target=ihex --input-target=binary $file $file.hex

xxd -p -c1 $file > $file.vhex
cp ./$file.vhex ../schematics/cpu5/


done


