#!/bin/sh

rm ./fw_bin -r
mkdir -p fw_bin

make -C binutils clean install                          || exit 1
make -C SmallerC/v0100 clean install                    || exit 1
make -C SmallerC/v0100/ucpp                             || exit 1
cp SmallerC/v0100/ucpp/ucpp /opt/cpu5/bin/ucpp          || exit 1

make -C alu clean all                                   || exit 1
cd alu && ./gen.sh && cd ..                             || exit 1

make -C microcode clean all                             || exit 1
cd microcode && ./gen.sh cpu6.txt && cd ..              || exit 1

make -C tools clean install                             || exit 1

cd os/kernel/ && ./build_kernel.sh && cd ../../         || exit 1

cd os/apps/src && ./build.sh && cd ../../..             || exit 1

./tools/cpu5genfs fw_bin/fs/ fw_bin/fs.img              || exit 1

make -C simulation/verilator clean
make -C simulation/verilator



