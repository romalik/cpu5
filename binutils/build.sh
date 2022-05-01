#!/bin/sh

../binutils/cpu5as $1 $1.o 
../binutils/cpu5ld $1.o -o $1.hex -h
../binutils/cpu5ld $1.o -o $1.bin

