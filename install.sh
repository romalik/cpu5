#!/bin/sh 
make -C binutils clean install
make -C SmallerC/v0100 clean install
make -C SmallerC/v0100/ucpp
cp SmallerC/v0100/ucpp/ucpp /opt/cpu5/bin/ucpp

make -C alu clean all
cd alu && ./gen.sh && cd ..

make -C microcode clean all
cd microcode && ./gen.sh cpu6.txt && cd ..

