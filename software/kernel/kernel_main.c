#include "klib.h"
#include "mmu.h"
#include "uart.h"
#include "interrupts.h"
#include "syscall.h"
#include "fs.h"
#include "proc.h"
#include "blk.h"

extern int tick_counter;

unsigned int fxnMul(unsigned int a, unsigned int b) { 
    unsigned int res = 0;
    unsigned int mask = 1;


    puts("multiply \n"); printhex(a); puts(" "); printhex(b);
    for(unsigned char i = 0; i<16; i++) {
        if(mask & a) {
            res += b;
        }
        b = b << 1;
        mask = mask << 1;
    }
    puts(" = "); printhex(res); puts("\n");
    return res; 
}
int fxnMod() { return 0; }
int fxnDiv() { return 0; }



/*
#define CAT_BUFFER 100
char cat_buf[CAT_BUFFER];
void cat(int argc, char ** argv) {
    cat_buf[CAT_BUFFER-1] = 0;
    if(argc < 2) {
        return;
    }
    struct stat st;
    if(stat(argv[1], &st)) {
        puts("File not found\n");
    } else {
        puts("File "); puts(argv[1]); puts(" is at "); printhex(st.blk); puts(" sz "); printhex(st.size); puts("\n");
        unsigned int to_read = st.size;
        unsigned int c_pos = 0;
        while(to_read) {
            unsigned int read_now = CAT_BUFFER-1;
            if(read_now > to_read) read_now = to_read;
            read_file(cat_buf, st.blk, c_pos, read_now);
            puts(cat_buf);
            to_read = to_read - read_now;
            c_pos += read_now;
        }
    }
}
*/

void exec2(int argc, char ** argv) {

}


void start_init(char * path) {
    unsigned char proc_idx = find_free_proc();
    p_list[proc_idx].pid = get_new_pid();
    p_list[proc_idx].status = PROCESS_RUN;
    p_list[proc_idx].tlb_index = get_free_tlb();
    p_list[proc_idx].ctx.pc = 0x0000;
    for(unsigned char i = 0; i<16; i++) {
        p_list[proc_idx].pages[i] = find_free_page();
        page_refcount_inc(p_list[proc_idx].pages[i]);
    }


    puts("init ["); puts(path); puts("] starting...\n");
    load_process(path, proc_idx);
    populate_tlb(proc_idx);
    //print_process_list();
    //asm("hlt");
    start_sched();
    puts("Waiting for sched()\n");
    while(1) {} //spin a bit, never return after sched()
}



void exec(int argc, char ** argv) {
    start_init(argv[1]);
}

void uptime(int argc, char ** argv) {
    puts("System is up for "); printhex(tick_counter); puts(" ticks.\n");
}

#define MAX_ARGS 10
char * _argv[MAX_ARGS];
char ** build_argv(char * str, int * argc) {
    char * s = str;
    *argc = 1;
    _argv[0] = str;
    while(*s) {
        s = strchr(s, ' ');
        if(s) {
            *s = 0;
            s++;
            if((*s != ' ') && *s) {
              _argv[*argc] = s;
              (*argc)++;
            }
        } else {
            break;
        }
    }
    return _argv;
}



#define N_CMDS 4

void (*funcs[])() = {print_process_list, list_files, exec, uptime};
char *cmds[] = {"ps", "ls",  "exec", "uptime"};

int get_cmd_idx(char *s)
{
    int i = 0;
    for (i = 0; i < N_CMDS; i++)
    {
        //puts("cmp: "); puts(s); puts(" with "); puts(cmds[i]); puts("\n");
        if (!strcmp(cmds[i], s))
        {
            //puts("ok!\n");
            return i;
        }
    }
    return -1;
}

extern char __text_end;
extern char __data_end;
extern char __bss_end;


#define INIT_PROCESS "sh.bin"

void main()
{
    *(unsigned char*)(0x4004) = 'A';
    char *cmd;
    int i = 0;


    tick_counter = 0;
    puts("\n\nKernel init\n");
    puts("text end: ");   printhex(&__text_end);
    puts("\ndata end: "); printhex(&__data_end);
    puts("\nbss end : "); printhex(&__bss_end);
    puts("\n");


    init_uart();
    init_proc();
    init_mmu();
    init_interrupts();

    //print_process_list();
    
    /*
    puts("block init..\n");
    block_init();
    dump_blocks();
*/

    puts("!!! ERRORS !!!\n");
    puts("!!! OVERFLOW FLAG INCORRECT IN ALUGENERATOR (0x80 instead of 0x08) !!!\n");
    puts("!!! Backup ALU latched regs in case of fault (maybe) !!!\n");
    puts("!!! Compiler : 'c_proc = &p_list[current_proc_idx];' seemingly does not work!!!\n");
    

    puts("Kernel ready\n");


    if(1 && (getc() != 'a')) {
        start_init(INIT_PROCESS);
    }


#if 1

    int cmd_idx;

    int argc;
    char ** argv;
    while (1)
    {
        printhex(tick_counter);
        puts(" > ");
        cmd = getline();


        //puts("cmd: "); puts(cmd); puts("\n");
        argv = build_argv(cmd, &argc);
        cmd_idx = get_cmd_idx(argv[0]);

        if (cmd_idx < 0)
        {
            puts("unknown command\n");
        }
        else
        {
            funcs[cmd_idx](argc,argv);
        }
    }
    puts("Halt\n");
    asm("hlt\n");
#endif
}


