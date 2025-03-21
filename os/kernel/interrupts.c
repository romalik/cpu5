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

int tick_counter;
void __interrupt tick_isr() {
    ISR_PROLOG

    tick_counter++;
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
    *(unsigned int *)(INT_VEC_0 + ISR_ADDR_OFFSET) = &tick_isr;

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

void save_isr_ctx_to  (struct isr_ctx * dest) {
    dest->s  =  *ISR_CTX_S;
    dest->a  =  *ISR_CTX_A;
    dest->b  =  *ISR_CTX_B;
    dest->f  =  *ISR_CTX_F;
    dest->m  =  *ISR_CTX_M;
    dest->x  =  *ISR_CTX_X;
    dest->pc =  *ISR_CTX_PC;
}

void load_isr_ctx_from(struct isr_ctx * src) {
    *ISR_CTX_S  = src->s;
    *ISR_CTX_A  = src->a;
    *ISR_CTX_B  = src->b;
    *ISR_CTX_F  = src->f;
    *ISR_CTX_M  = src->m;
    *ISR_CTX_X  = src->x;
    *ISR_CTX_PC = src->pc;
}

void print_isr_ctx(struct isr_ctx * ctx) {
    puts("pc "); printhex(ctx->pc); puts(" ");
    puts(" a "); printhex(ctx->a);  puts(" ");
    puts(" b "); printhex(ctx->b);  puts(" ");
    puts(" f "); printhex(ctx->f);  puts(" ");
    puts(" m "); printhex(ctx->m);  puts(" ");
    puts(" s "); printhex(ctx->s);  puts(" ");
    puts(" x "); printhex(ctx->x);  puts(" ");
    
}

