#ifndef INTERRUPTS_H__
#define INTERRUPTS_H__


#define ISR_PROLOG      asm("mov A, MH"); \
                        asm("push A"); \
                        asm("mov A, ML"); \
                        asm("push A"); \
                        asm("mov A, F"); \
                        asm("push A"); \
                        asm("mov A, B"); \
                        asm("push A"); \
                        asm("ldd S, $isr_stack"); \
                        asm("movms"); \
                        asm("SP-=8"); \
                        asm("SP-=8"); \
                        asm("SP-=8");

                        /*pushed 8 bytes (pl,ph, xl, xh, ml, mh, f, b)*/
                        /*S is now 0xffff - 8 = 0xfff7*/

#define ISR_EPILOG      asm("ldd S, 0xfff7"); \
                        asm("pop A"); \
                        asm("mov B, A"); \
                        asm("pop A"); \
                        asm("mov F, A"); \
                        asm("pop A"); \
                        asm("mov ML, A"); \
                        asm("pop A"); \
                        asm("mov MH, A"); \
                        asm("pop A"); \
                        asm("mov XL, A"); \
                        asm("pop A"); \
                        asm("mov XH, A"); \
                        asm("iret");

#define IRET_ADDRESS_PTR 0xfffe

void init_interrupts();

struct isr_ctx {
    unsigned char b;
    unsigned char f;
    unsigned int m;
    unsigned int x;
    unsigned int pc;
} * ISR_CTX = (struct isr_ctx *)(0xfff8);

#endif