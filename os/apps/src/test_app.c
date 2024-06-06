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

void puts_scall(char * s) {
    while(*s) {
        do_syscall(1, *s);
        s++;        
    }
}

int main() {
    puts_scall("Hello from app!\n");
}