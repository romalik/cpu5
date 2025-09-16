#ifndef PROC_H__
#define PROC_H__
#include "interrupts.h"

struct Process {
    unsigned char status;
    unsigned char pid;
    unsigned char tlb_index;
    struct isr_ctx ctx; //12b
    unsigned char pages[16];

};

extern struct Process p_list[];
extern unsigned char current_proc_idx;

enum PROCESS_STATE {
    PROCESS_NONE = 0,
    PROCESS_RUN,
    PROCESS_WAIT,
    PROCESS_DEAD
};

void init_proc();
void load_process(const char * path, unsigned char proc_idx);
void print_process_list();

void start_sched();
void sched();


unsigned char find_free_proc();
unsigned char get_new_pid();


void force_sched();

void skip_next_proc_frame_save();

#endif