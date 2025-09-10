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

void printhex(int i) {
    char printnum_buffer[8];
	char * s = printnum_buffer + 7;
	char n_rem;
	char n;
    *s = 0;
	s--;

    n = i & 0x000f;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    n = i & 0x00f0;
    n = n >> 4;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    i = i >> 8;

    n = i & 0x000f;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    n = i & 0x00f0;
    n = n >> 4;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

	*s = 'x';
	s--;
	*s = '0';
	puts(s);
}



int main() {
    int i, j;
    unsigned char * addr = (unsigned char *)(0x5000);
    puts("!Try read starting 0x5000...\n");
    while((unsigned int)(addr) < 0x8000) {
        char c = 0;
        if(((unsigned int)(addr) & 0xfff) == 0x100) {
            puts("reading addr "); printhex(addr); puts("\n");
        }
        c = *addr;
        addr+=0x100;
    }

    puts("!Try write starting 0x5000...\n");
    addr = (unsigned char *)(0x5000);
    while((unsigned int)(addr) < 0x8000) {
        char c = 0;
        if(((unsigned int)(addr) & 0xfff) == 0x100) {
            puts("writing addr "); printhex(addr); puts("\n");
        }
        *addr = c;
        addr+=0x100;
    }


    puts("VMEM Test done\n");
    while(1) {}

    /*
    while(1) {
        puts("Hello from app2!\n");
        while(1) {
            putc('2');
        }
        for(i = 10; i>0; i--) {
            for(j = 0; j<i; j++) {
                putc('*');
            }
            putc('\n');
        }
    }
    */
}