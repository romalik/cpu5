#include "klib.h"
#include "syscall.h"
#include "interrupts.h"
#include "proc.h"
#include "mmu.h"
#include "fs.h"

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
    *(unsigned char *)(0x4004) = *ISR_CTX_B;
    return 0;
}

unsigned char sys_getchar() {
    *ISR_CTX_B = getc();
    return 0;
}

extern int tick_counter;
unsigned char sys_stats() {
    print_process_list();
    puts("System is up for "); printhex(tick_counter); puts(" ticks.\n");
    puts("current_proc pages\n");
    for(int i = 0; i<16; i++) {
        printhex(p_list[current_proc_idx].pages[i]); puts("\n");
    }
    return 0;
}

unsigned char sys_fork() {
    struct Process * new_proc = find_free_proc();
    unsigned char new_pid = get_new_pid();

    if(!new_proc) {
        *ISR_CTX_B = 0xff;
        return 0;
    }




    return 0;
}

unsigned char sys_exec() {
    char buf[16];
    struct stat st;
    MMU_OFF();
    write_tlb_index(0); // will work with pages, explicitly set kernel
    memcpy_from_user(buf, *ISR_CTX_X, 16, current_proc_idx);

    puts("sys_exec() path '"); puts(buf); puts("'\n");
    
    if(stat(buf, &st)) {
            puts("File not found\n");
    } else {
        for(int j = 0; j<16; j++) {
            page_refcount_dec(p_list[current_proc_idx].pages[j]);
            p_list[current_proc_idx].pages[j] = find_free_page();
            page_refcount_inc(p_list[current_proc_idx].pages[j]);
        }

        load_process(buf, current_proc_idx);
        populate_tlb(current_proc_idx);

        //p_list[current_proc_idx].ctx.pc = 0x0000;
        //skip_next_proc_frame_save();
        //force_sched();

        *ISR_CTX_PC = 0x0000;

        MMU_OFF();
        write_tlb_index(p_list[current_proc_idx].tlb_index); // will work with pages, explicitly set kernel

        ISR_EPILOG

        //not reached
    }


    MMU_OFF();
    write_tlb_index(p_list[current_proc_idx].tlb_index); // will work with pages, explicitly set kernel

    *ISR_CTX_B = 1;

    return 0;
}


#define NR_SYSCALL 6

unsigned char (*sys_table[NR_SYSCALL])() = {
    sys_none, 
    sys_putchar,
    sys_getchar,
    sys_stats,
    sys_fork,
    sys_exec
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
