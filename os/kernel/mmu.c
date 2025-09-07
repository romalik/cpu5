#include "mmu.h"

#define TLB_BASE  0x6000
#define TLBF_BASE 0x7000

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
    puts(" + init mmu... ");
    for(char i = 0; i<0x10; i++) {
        write_tlb(0, i, i, 0xff-i);
        write_tlb(1, i, 0x10 + i, 0xff-i);
        write_tlb(2, i, 0x20 + i, 0xff-i);
        write_tlb(3, i, 0x30 + i, 0xff-i);
    }


    *(unsigned char *)(TLB_INDEX) = 0;
    MMU_ON();
    puts("ok\n");
}

void write_tlb_index(unsigned char idx) {
    *(unsigned char *)(TLB_INDEX) = idx;
}
