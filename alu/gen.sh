#!/bin/sh
./alu_generator
for file in alu_*.bin; do
objcopy --output-target=ihex --input-target=binary $file $file.hex
done


