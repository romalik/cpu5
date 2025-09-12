unsigned char do_syscall(unsigned char id, unsigned char arg) {
    unsigned char retval;
    asm("ldd X,0x1234");
    asm("mov A,a2");
    asm("mov B,A");
    asm("mov A,a0");
    asm("syscall");
    asm("mov l-2,A");
    return retval;
}

void putc(char c) {
    do_syscall(1, c);
}

void puts(char * s) {
    while(*s) {
        putc(*s);
        s++;        
    }
}

int main() {
    int i, j;
    puts("Hello from app!\n");
    for(i = 10; i>0; i--) {
        for(j = 0; j<i; j++) {
            putc('*');
        }
        putc('\n');
    }

}