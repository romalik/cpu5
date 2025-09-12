#!/bin/sh

rm ./fw_bin -r
mkdir -p fw_bin

cd os/kernel/ && ./build_kernel.sh && cd ../../         || exit 1

cd os/apps/src && ./build.sh && cd ../../..             || exit 1

cpu5mkfs fw_bin/fs/ fw_bin/fs.img              || exit 1




