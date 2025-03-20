#include "klib.h"
#include "interrupts.h"

#define ISR_VEC_LENGTH 8
#define ISR_ADDR_OFFSET 5
char isr_vec[] = {
/* mov a,xh */ 0xe7,
/* push a   */ 0xd9,
/* mov a,xl */ 0xe6,
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


void __interrupt empty_isr() {
    ISR_PROLOG
    ISR_EPILOG
}


void sched();

int btn_counter;
void __interrupt btn_isr() {
    ISR_PROLOG

    btn_counter++;
    sched();

    ISR_EPILOG
}


extern void uart_isr();
extern void syscall_isr();

void init_interrupts() {
    puts("init interrupts\n");

    asm(".section bss");
    asm(".align 2");
    asm("isr_stack_arena:");
    asm(".skip 0xff");
    asm("isr_stack:");
    asm(".export isr_stack");
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

    memcpy((unsigned char *)(INT_VEC_SYSCALL),  isr_vec, ISR_VEC_LENGTH);    
    *(unsigned int *)(INT_VEC_SYSCALL + ISR_ADDR_OFFSET) = &syscall_isr;

    asm("ei\n");
}
