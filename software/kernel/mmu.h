#ifndef MMU_H__
#define MMU_H__
#include "proc.h"

#define RESET_PAGING 0x4800
#define SET_PAGING   0x4801

#define MMU_ON() *(unsigned char *)(SET_PAGING) = 1
#define MMU_OFF() *(unsigned char *)(RESET_PAGING) = 1

void init_mmu();
void write_tlb(unsigned char idx, unsigned char page, unsigned char value, unsigned char flags);
void write_tlbf(unsigned char idx, unsigned char page, unsigned char flags);
void write_tlb_index(unsigned char idx);

unsigned char find_free_page();
unsigned char get_free_tlb();
unsigned char release_tlb(unsigned char idx);

void populate_tlb(unsigned char process_idx);
unsigned char page_refcount_inc(unsigned char page);
unsigned char page_refcount_dec(unsigned char page);

void memcpy_from_user(void * dest, void * src, unsigned int n, unsigned char process_idx);
void memcpy_to_user(void * dest, void * src, unsigned int n, unsigned char process_idx);

#endif