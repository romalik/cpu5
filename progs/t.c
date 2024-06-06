void puts(char * s) {
    while(*s) {
        *(unsigned char *)(0x4803) = *s;
        s++;
    }
}

#define IRET_ADDRESS_PTR 0xfffe
void main() {
	puts("\n\nt.c\n");

    *(unsigned int *)(IRET_ADDRESS_PTR) += 1;

	puts("halt\n");
	asm("hlt\n");
}
