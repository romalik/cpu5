#!/bin/sh

mkdir -p /tmp/testbuild
rm /tmp/testbuild/*

for i in src/*.c 
do
	cpu5build -c -I include/ -I src/templates $i -o /tmp/testbuild/`basename $i`.o
	if [ $? -ne 0 ]; then
		echo $i >> /tmp/testbuild/fail.log
		#exit
	fi
done
