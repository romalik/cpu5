

unsigned char uart_buffer[256];
unsigned char uart_buffer_size;
unsigned char uart_buffer_rd_pos;
unsigned char uart_buffer_wr_pos;

void init_uart() {
    uart_buffer_size = 0;
    uart_buffer_rd_pos = 0;
    uart_buffer_wr_pos = 0;
}

char getc() {
    char c = 0;
    if(uart_buffer_size) {
        uart_buffer_size--;
        c = uart_buffer[uart_buffer_rd_pos];
        uart_buffer_rd_pos++;
    }
    return c;
}



void puts(char * s) {
    while(*s) {
        *(unsigned char *)(0x4803) = *s;
        s++;
    }
}



int putc(char c) {
    *(unsigned char *)(0x4803) = c;
}




char getc_raw() {
   char c = *(unsigned char *)(0x4803);
   if(c == 0xff) c = 0;
   return c;
}


int fxnMul() {return 0;}
int fxnMod() {return 0;}
int fxnDiv() {return 0;}


int strcmp(const char *s1, const char *s2)
{
	const unsigned char *c1 = (const unsigned char *)s1;
	const unsigned char *c2 = (const unsigned char *)s2;
	unsigned char ch;
	int d = 0;

	while (1) {
		d = (int)(ch = *c1++) - (int)*c2++;
		if (d || !ch)
			break;
	}

	return d;
}


int memset(char *dest, const char val, int n) {
    int k = n;
    while (k--) {
        *dest = val;
        dest++;
    }
    return n;
}

int memcpy(char *dest, const char *src, int n) {
    int k = n;
    while (k--) {
        *dest = *src;
        dest++;
        src++;
    }
    return n;
}

int memcmp(const void *mem1, const void *mem2, int len)
{
        const signed char *p1 = mem1, *p2 = mem2;

        if (!len)
                return 0;

        while (--len && *p1 == *p2) {
                p1++;
                p2++;
        }
        return *p1 - *p2;
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

#define MAX_LENGTH 127

char in_str[MAX_LENGTH];
void getline() {
   char c;
   int count = 0;
   char * s = in_str;
   while(1) {
      c = getc();

      if(!c) continue;
 

      if(c == '\n' || c == '\r') {
         *s = 0;
         return;
      } else {
        if(count < MAX_LENGTH - 1) {
            *s = c;
            s++;
            count++;
        }
      }
   }

}

void test_func() {
    puts("Generate syscall\n");
    asm("syscall\n");
    puts("Done, return\n");
}

void test_func_2() {
    puts("test function\n");

}

void echo() {
    puts("echo:\n");
    while(1) {
        char c = getc();
        if(c) {
            putc(c);
        }
    }
}

#define N_CMDS 3

void (*funcs[])() = {test_func, test_func_2, echo};
char * cmds[] = {"s", "test", "echo"};


int get_cmd_idx(char * s) {
   int i = 0;
   for(i = 0; i<N_CMDS; i++) {
      if(!strcmp(cmds[i], s)) {
         return i;
      }
   }
   return -1;
}


#define TLB_BASE  0x6000
#define TLBF_BASE 0x7000

#define RESET_PAGING 0x4800
#define SET_PAGING   0x4801
#define TLB_INDEX    0x4802

void write_tlb(unsigned char idx, unsigned char page, unsigned char value, unsigned char flags) {
    unsigned int offset = (idx << 4) + page;
    unsigned int tlb_addr = TLB_BASE + offset;
    unsigned int tlbf_addr = TLBF_BASE + offset;
/*
    puts("[TLB]  Write "); printhex(value&0xff); puts(" to "); printhex(tlb_addr); puts("\n");
    puts("[TLBF] Write "); printhex(flags&0xff); puts(" to "); printhex(tlbf_addr); puts("\n");
*/
    *(unsigned char *)(tlb_addr) = value;
    *(unsigned char *)(tlbf_addr) = flags;
}

void init_mmu() {
    puts("init mmu\n");
    for(char i = 0; i<0x10; i++) {
        write_tlb(0, i, i, 0xff-i);
    }

    *(unsigned char *)(TLB_INDEX) = 0;
    *(unsigned char *)(SET_PAGING) = 1;
}


/*
isr_0_jmp:
; mov a, xl
; push a
; mov a, xh
; push a
; ldd x, $isr_0 ;;low, high
.word $isr_0
; jmp
*/

#define ISR_VEC_LENGTH 8
#define ISR_ADDR_OFFSET 5
char isr_vec[] = {
/* mov a,xl */ 0xe6,
/* push a   */ 0xd9,
/* mov a,xh */ 0xe7,
/* push a   */ 0xd9,
/* ldd x,   */ 0xde,
/*       low*/ 0x00,
/*      high*/ 0x00,
/* jmp      */ 0xaf
};

#define INT_VEC_0       0xFF00
#define INT_VEC_1       0xFF10
#define INT_VEC_2       0xFF20
#define INT_VEC_3       0xFF30
#define INT_VEC_SYSCALL 0xFF40


int btn_counter;



#define ISR_PROLOG      asm("mov A, ML"); \
                        asm("push A"); \
                        asm("mov A, MH"); \
                        asm("push A"); \
                        asm("mov A, F"); \
                        asm("push A"); \
                        asm("ldd S, $isr_stack"); \
                        asm("movms"); \
                        asm("SP-=8"); \
                        asm("SP-=8");

                        /*pushed 7 bytes (pl,ph, xl, xh, ml, mh, f)*/
                        /*S is now 0xffff - 7 = 0xfff8*/

#define ISR_EPILOG      asm("ldd S, 0xfff8"); \
                        asm("pop A"); \
                        asm("mov F, A"); \
                        asm("pop A"); \
                        asm("mov MH, A"); \
                        asm("pop A"); \
                        asm("mov ML, A"); \
                        asm("pop A"); \
                        asm("mov XH, A"); \
                        asm("pop A"); \
                        asm("mov XL, A"); \
                        asm("iret");

#define IRET_ADDRESS_PTR 0xfffe

void __interrupt empty_isr() {
    ISR_PROLOG
    ISR_EPILOG
}



void __interrupt btn_isr() {
    ISR_PROLOG

    btn_counter++;


    ISR_EPILOG
}

void __interrupt uart_isr() {
    ISR_PROLOG
    if(uart_buffer_size < 0xffU) {
        uart_buffer[uart_buffer_wr_pos] = *(unsigned char *)(0x4803);
        uart_buffer_wr_pos++;
        uart_buffer_size++;
    } else {
        char dummy = *(unsigned char *)(0x4803);
    }
    ISR_EPILOG
}


void __interrupt syscall_isr() {
    ISR_PROLOG

    *(unsigned int *)(IRET_ADDRESS_PTR) += 1;
    puts(" ---- hello from Syscall ---- \n");

    ISR_EPILOG
}

void init_interrupts() {
    puts("init interrupts\n");

    asm(".section bss");
    asm(".align 2");
    asm("isr_stack_arena:");
    asm(".skip 0xff");
    asm("isr_stack:");
    asm(".skip 1");
    asm(".section text");

    memcpy((unsigned char *)(INT_VEC_0),        isr_vec, ISR_VEC_LENGTH);
    *(unsigned int *)(INT_VEC_0 + ISR_ADDR_OFFSET) = &btn_isr;

    memcpy((unsigned char *)(INT_VEC_1),        isr_vec, ISR_VEC_LENGTH);    
    *(unsigned int *)(INT_VEC_1 + ISR_ADDR_OFFSET) = &empty_isr;

    memcpy((unsigned char *)(INT_VEC_2),        isr_vec, ISR_VEC_LENGTH);    
    *(unsigned int *)(INT_VEC_2 + ISR_ADDR_OFFSET) = &empty_isr;

    memcpy((unsigned char *)(INT_VEC_3),        isr_vec, ISR_VEC_LENGTH);    
    *(unsigned int *)(INT_VEC_3 + ISR_ADDR_OFFSET) = &uart_isr;

    // Manually increment PC (X after switch) in Syscall isr
    memcpy((unsigned char *)(INT_VEC_SYSCALL),  isr_vec, ISR_VEC_LENGTH);    
    *(unsigned int *)(INT_VEC_SYSCALL + ISR_ADDR_OFFSET) = &syscall_isr;

    asm("ei\n");
}

void main() {
   int i = 0;
   btn_counter = 0;
   puts("\n\nKernel\n");
   init_uart();
   init_mmu();
   init_interrupts();
   puts("Ready\n");

   int cmd_idx;


   while(1) {
      printhex(btn_counter);
      puts(" > ");
      getline();
      cmd_idx = get_cmd_idx(in_str);

      if(cmd_idx < 0) {
            puts("unknown command\n");
      } else {
            funcs[cmd_idx]();
      }

   }
   puts("Halt\n");
   asm("hlt\n");
}
