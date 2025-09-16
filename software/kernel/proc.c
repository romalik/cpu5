#include "proc.h"
#include "interrupts.h"
#include "fs.h"
#include "mmu.h"


#define TICKS_TO_SWITCH 8

extern int tick_counter;

int do_switch;
unsigned char current_proc_idx;




const char * p_state_str[] = {
    '0',
    'R',
    'W',
    'D'
};


#define N_PROC 6
struct Process p_list[N_PROC];



void init_proc() {
    puts(" + init process list... ");
    current_proc_idx = 0xff;
    do_switch = 0;
    memset(p_list, 0, sizeof(struct Process) * N_PROC);
    puts("ok\n");
}

unsigned char find_free_proc() {
    for(unsigned char i = 0; i<N_PROC; i++) {
        if(p_list[i].status == PROCESS_NONE) {
            return i;
        }
    }
    return 0xff;
}

unsigned char get_new_pid() {
    unsigned char pid = 1;
    while(1) {
        unsigned char pid_found = 1;
        for(char i = 0; i<N_PROC; i++) {
            if((p_list[i].pid == pid) && (p_list[i].status != PROCESS_NONE)) {
                pid_found = 0;
                break;
            }
        }
        if(pid_found) {
            return pid;
        }
        pid++;
    }
}


void load_process(const char * path, unsigned char proc_idx) {
    struct stat st;
    unsigned int left_to_read;
    unsigned int read_now = 0;
    unsigned int already_read = 0;
    unsigned char c_page = 0xa;


    if(stat(path, &st)) {
        puts("File not found\n");
    } else {
        unsigned char target_page_idx = 0;
        left_to_read = st.size;
        while(left_to_read) {
            puts("Read "); printhex(already_read); puts("\n");
            if(left_to_read > 0x1000U) {
                read_now = 0x1000U;
            } else {
                read_now = left_to_read;
            }
            MMU_OFF();
            write_tlb(  0, 
                        0xa, 
                        p_list[proc_idx].pages[target_page_idx],
                        0xff
                     );
            MMU_ON();
            read_file((unsigned char *)(0xA000), st.blk, already_read, read_now);
            already_read += read_now;
            left_to_read -= read_now;
            target_page_idx++;
        }

        puts(path); puts(" loaded\n");
    }
}

void print_process_list() {
    puts("pid    status tlb_idx\n");
    for(int i = 0; i<N_PROC; i++) {
        printhex(p_list[i].pid);
        puts(" ");
        putc(p_state_str[p_list[i].status]);
        puts("     ");
        printhex(p_list[i].tlb_index);
        puts(" ctx:\n");
        print_isr_ctx(&p_list[i].ctx);
        puts("\npages:\n");
        for(int j = 0; j<16; j++) {
            puts("["); printhex(p_list[i].pages[j]); puts("]");
        }
        puts("\n");
        
    }
}


unsigned char ticks_to_next_switch;
void start_sched() {
    do_switch = 1;
    ticks_to_next_switch = TICKS_TO_SWITCH;
}


void force_sched() {
    ticks_to_next_switch = 1;
    sched();
}

void skip_next_proc_frame_save() {
    current_proc_idx = 0xff;
}

void sched() {
    if(do_switch) {
        //puts("Ticks to next switch "); printhex(ticks_to_next_switch); puts("\n");
        ticks_to_next_switch--;
        if(ticks_to_next_switch > 0) {
            return;
        }

        ticks_to_next_switch = TICKS_TO_SWITCH;

        //puts("\n#sw from "); printhex(current_proc_idx);
        if(current_proc_idx != 0xff) { // first switch from kernel
            save_isr_ctx_to(&p_list[current_proc_idx].ctx);
        }
        while(1) {
            current_proc_idx++;
            if(current_proc_idx >= N_PROC) {
                //puts(" .ovf. ");
                current_proc_idx = 0;
            }
            if(p_list[current_proc_idx].status == PROCESS_RUN) {
                //puts(" to "); printhex(current_proc_idx); puts("\n");

                load_isr_ctx_from(&p_list[current_proc_idx].ctx);

                write_tlb_index(p_list[current_proc_idx].tlb_index);

                //puts("sched switch\n");
                return;
            }
        }
        /*
        if(c_tlb_idx) c_tlb_idx = 0;
        else c_tlb_idx = 1;
        //MMU_OFF();
        write_tlb_index(c_tlb_idx+1);
        //MMU_ON();
        */

    } else {
        //putc('.');
    }

}