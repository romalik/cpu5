#ifndef PROC_H__
#define PROC_H__


void init_proc();
void exec_process(const char * path, unsigned char p_idx);
void print_process_list();

void start_sched();
void sched();

#endif