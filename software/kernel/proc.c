#include "proc.h"
#include "interrupts.h"
#include "fs.h"
#include "mmu.h"

extern int tick_counter;

int do_switch;
int current_proc;

enum PROCESS_STATE {
    PROCESS_NONE = 0,
    PROCESS_RUN,
    PROCESS_WAIT,
    PROCESS_DEAD
};

const char * p_state_str[] = {
    '0',
    'R',
    'W',
    'D'
};

struct Process {
    unsigned char status;
    unsigned char pid;
    unsigned char tlb_index;
    unsigned char start_page;
    struct isr_ctx ctx; //12b
};

#define N_PROC 3
struct Process p_list[3];



void init_proc() {
    puts(" + init process list... ");
    current_proc = 0;
    do_switch = 0;
    memset(p_list, 0, sizeof(struct Process) * N_PROC);
    for(int i = 0; i<N_PROC; i++) {
        //puts("fill "); printhex(i);
        p_list[i].tlb_index = i; 
        p_list[i].start_page = (i) << 4;

        p_list[i].pid = i;

        p_list[i].status = PROCESS_NONE;
    }
    puts("ok\n");
}

void exec_process(const char * path, unsigned char p_idx) {
    struct stat st;
    unsigned int left_to_read;
    unsigned int read_now = 0;
    unsigned int already_read = 0;
    unsigned char c_page = 0xa;


    if(stat(path, &st)) {
        puts("File not found\n");
    } else {
        
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
                        p_list[p_idx].start_page + (already_read >> 8),
                        0xff
                     );
            MMU_ON();
            read_file((unsigned char *)(0xA000), st.blk, already_read, read_now);
            already_read += read_now;
            left_to_read -= read_now;
        }

        puts(path); puts(" loaded\n");
    }
    p_list[p_idx].ctx.pc = 0x0000;
    p_list[p_idx].status = PROCESS_RUN;

}

void print_process_list() {
    puts("pid status tlb_idx pages ctx\n");
    for(int i = 0; i<N_PROC; i++) {
        printhex(i);
        puts(" : @ ");
        printhex(&p_list[i]);
        puts(" pid = ");
        printhex(p_list[i].pid);
        puts(" ");
        putc(p_state_str[p_list[i].status]);
        puts(" ");
        printhex(p_list[i].tlb_index);
        puts(" start_page(");
        printhex(p_list[i].start_page);
        puts(") ctx (");
        print_isr_ctx(&p_list[i].ctx);
        puts(")\n");
        
    }
}


void start_sched() {
    do_switch = 1;
}

void sched() {
    if(do_switch) {
        if(tick_counter & 0x03) return;

        //puts("\n#sw from "); printhex(current_proc);
        save_isr_ctx_to(&p_list[current_proc].ctx);
        while(1) {
            current_proc++;
            if(current_proc >= N_PROC) {
                //puts(" .ovf. ");
                current_proc = 0;
            }
            if(p_list[current_proc].status == PROCESS_RUN) {
                //puts(" to "); printhex(current_proc); puts("\n");

                load_isr_ctx_from(&p_list[current_proc].ctx);

                write_tlb_index(p_list[current_proc].tlb_index);

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