#!/bin/sh 
make -C binutils clean install
make -C SmallerC/v0100 clean install
make -C SmallerC/v0100/ucpp
cp SmallerC/v0100/ucpp/ucpp /opt/cpu5/bin/ucpp
