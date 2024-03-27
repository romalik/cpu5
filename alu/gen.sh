#!/bin/sh
./alu_firmware_generator
for file in chip_*.bin; do
od -v -A n -t x1 < $file > $file.hex
objcopy --output-target=ihex --input-target=binary $file $file.hex
done


