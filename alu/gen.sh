#!/bin/sh
./alu_generator
for file in alu_*.bin; do
objcopy --output-target=ihex --input-target=binary $file $file.hex

#xxd -p -c1 $file > $file.vhex
#cp ./$file.vhex ../bin/

cp ./$file ../fw_bin/

done


