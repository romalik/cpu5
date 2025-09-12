cpu5build --rom -o $ROM_DIR/rom.bin kernel_main.c interrupts.c mmu.c uart.c klib.c syscall.c fs.c ata.c blk.c proc.c
truncate -s 32768 $ROM_DIR/rom.bin

