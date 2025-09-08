#!/bin/sh

cpu5build --rom -o ~/cpu5/rom.hex kernel_main.c interrupts.c mmu.c uart.c klib.c syscall.c fs.c ata.c blk.c --hex
cpu5build --rom -o ~/cpu5/schematics/cpu5/rom.bin kernel_main.c interrupts.c mmu.c uart.c klib.c syscall.c fs.c ata.c blk.c
truncate -s 32768 ~/cpu5/schematics/cpu5/rom.bin
xxd -p -c1 ~/cpu5/schematics/cpu5/rom.bin > ~/cpu5/schematics/cpu5/rom.bin.vhex

