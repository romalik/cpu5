#include "klib.h"
#include "syscall.h"
#include "interrupts.h"

/*
void print_isr_ctx() {
    puts("PC: "); printhex(ISR_CTX->pc);
    puts("\nX : "); printhex(ISR_CTX->x);
    puts("\nM : "); printhex(ISR_CTX->m);
    puts("\nF : "); printhex(ISR_CTX->f);
    puts("\nB : "); printhex(ISR_CTX->b);
    puts("\n");
    
}
*/


unsigned char sys_none() {
    return 0;
}

unsigned char sys_putchar() {
    *(unsigned char *)(0x4803) = *ISR_CTX_B;
    return 0;
}

#define NR_SYSCALL 2

unsigned char (*sys_table[])() = {
    sys_none, 
    sys_putchar
};


void __interrupt syscall_isr() {
    ISR_PROLOG
    *(unsigned int *)(ISR_CTX_PC) += 1;

    unsigned char id = *(unsigned char *)(ISR_CTX_A);

/*
    puts(" ---- hello from Syscall ---- \n");
    puts("id : "); printhex(id); puts("\n");
    print_isr_ctx();
  */  
    if(id < NR_SYSCALL) {
        *(unsigned char *)(ISR_CTX_A) = sys_table[id]();
    }
    
    //puts("\n ---- \n");
    ISR_EPILOG
}
