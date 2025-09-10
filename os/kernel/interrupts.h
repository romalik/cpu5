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


#define FAULT_EPILOG    asm("ldd S, 0xfff7"); \
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
                        asm("iretf");

void init_interrupts();

/*
struct isr_ctx {
    unsigned char b;
    unsigned char f;
    unsigned int m;
    unsigned int x;
    unsigned int pc;
} * ISR_CTX = (struct isr_ctx *)(0xfff8);
*/


unsigned int  * ISR_CTX_S  = (unsigned int *) (0xFFBD);
unsigned int  * ISR_CTX_A  = (unsigned int *) (0xFFBF);
unsigned char * ISR_CTX_B  = (unsigned char *)(0xFFF8);
unsigned char * ISR_CTX_F  = (unsigned char *)(0xFFF9);
unsigned int  * ISR_CTX_M  = (unsigned int *) (0xFFFA);
unsigned int  * ISR_CTX_X  = (unsigned int *) (0xFFFC);
unsigned int  * ISR_CTX_PC = (unsigned int *) (0xFFFE);


struct isr_ctx {
    unsigned int s;
    unsigned int m;
    unsigned int x;
    unsigned int pc;
    unsigned char a;
    unsigned char b;
    unsigned char f;
    unsigned char pad;
};

void save_isr_ctx_to  (struct isr_ctx * dest);
void load_isr_ctx_from(struct isr_ctx * src);

void print_isr_ctx(struct isr_ctx * ctx);

#endif