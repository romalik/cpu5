#ifndef MMU_H__
#define MMU_H__

#define RESET_PAGING 0x4800
#define SET_PAGING   0x4801

#define MMU_ON() *(unsigned char *)(SET_PAGING) = 1
#define MMU_OFF() *(unsigned char *)(RESET_PAGING) = 1

void init_mmu();
void write_tlb(unsigned char idx, unsigned char page, unsigned char value, unsigned char flags);
#endif