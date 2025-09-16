#include "mmu.h"
#include "proc.h"

#define TLB_BASE  0x6000
#define TLBF_BASE 0x7000

#define TLB_INDEX    0x4802

unsigned char page_refcount[256];
unsigned char tlb_map[256];

void write_tlbf(unsigned char idx, unsigned char page, unsigned char flags) {
    unsigned int offset = (idx << 4) + page;
    unsigned int tlbf_addr = TLBF_BASE + offset;

    *(unsigned char *)(tlbf_addr) = flags;
}

void write_tlb(unsigned char idx, unsigned char page, unsigned char value, unsigned char flags) {
    unsigned int offset = (idx << 4) + page;
    unsigned int tlb_addr = TLB_BASE + offset;
    unsigned int tlbf_addr = TLBF_BASE + offset;

    *(unsigned char *)(tlb_addr) = value;
    *(unsigned char *)(tlbf_addr) = flags;
}

void init_mmu() {
    unsigned char i;
    puts(" + init mmu... ");
    for(i = 0; i<0x10; i++) {
        write_tlb(0, i, i, 3);          // kernel pages
        //write_tlb(1, i, 0x10 + i, 0);   // init pages
    }

    i = 0;
    while(1) {
        if(i < 0x10) {
            page_refcount[i] = 1; // mark kernel pages active, refcnt = 1
        } else {
            page_refcount[i] = 0; // other pages are free
        }
        if(i == 0xff) break; //keep counter 1-byte
        i++;
    }

    *(unsigned char *)(TLB_INDEX) = 0;
    MMU_ON();
    puts("ok\n");
}

unsigned char find_free_page() {
    unsigned char i = 0x10;
    while(1) {
        if(page_refcount[i] == 0) {
            return i;
        }
        if(i == 0xff) {
            return 0;
        }
        i++;
    }
}

unsigned char get_free_tlb() {
    unsigned char i = 0x01;
    while(1) {
        if(tlb_map[i] == 0) {
            tlb_map[i] = 1;
            return i;
        }
        if(i == 0xff) {
            return 0;
        }
        i++;
    }
}

unsigned char release_tlb(unsigned char idx) {
    tlb_map[idx] = 0;
}

void populate_tlb(unsigned char proc_idx) {
    MMU_OFF();
    for(unsigned char i = 0;i<16;i++) {
        unsigned char page = p_list[proc_idx].pages[i];
        unsigned char tlb_index = p_list[proc_idx].tlb_index;
    
        write_tlb(tlb_index, i, page, 0x01);
    }
    MMU_ON();
}

unsigned char page_refcount_inc(unsigned char page) {
    page_refcount[page]++;
    return page_refcount[page];
}

unsigned char page_refcount_dec(unsigned char page) {
    page_refcount[page]--;
    return page_refcount[page];
}



void write_tlb_index(unsigned char idx) {
    *(unsigned char *)(TLB_INDEX) = idx;
}



void memcpy_from_user_single_page(void * dest, void * src, unsigned int n, unsigned char process_idx) {
    unsigned char user_page = ((unsigned int)src & 0xf000u) >> 12;
    unsigned int user_offset_in_page = ((unsigned int)src & 0x0fffu);
    unsigned char physical_page = p_list[process_idx].pages[user_page];


    MMU_OFF();
    write_tlb(  0, 
                0xa, 
                physical_page,
                0xff
            );
    MMU_ON();
    memcpy(dest, (void*)(0xa000 + user_offset_in_page), n);
    puts("dest "); printhex((unsigned int)dest);
    puts("\nsrc "); printhex((unsigned int)(0xa000 + user_offset_in_page));
    puts("\nn "); printhex(n);
    puts("\nphysical page "); printhex(physical_page);
    puts("\n");
}

void memcpy_from_user(void * dest, void * src, unsigned int n, unsigned char process_idx) {
    if((((unsigned int)src) & 0xf000) == (((unsigned int)src + n) & 0xf000)) {
        memcpy_from_user_single_page(dest, src, n, process_idx);
    } else {
        puts("memcpy_user across page boundary! Not impl. Halt\n");
        asm("hlt");
    }
}
void memcpy_to_user(void * dest, void * src, unsigned int n, unsigned char process_idx) {

}
