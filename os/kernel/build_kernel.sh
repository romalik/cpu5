#!/bin/sh

cpu5build  -o ~/cpu5/rom.hex kernel_main.c interrupts.c mmu.c uart.c klib.c syscall.c fs.c ata.c blk.c --hex
