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

unsigned char do_syscall(unsigned char id, unsigned char arg) {
    unsigned char retval;
    asm("ldd X,0x1234");
    asm("mov A,a2");
    asm("mov B,A");
    asm("mov A,a0");
    asm("syscall");
    asm("mov l-2,A");
    return retval;
}

void puts_scall(char * s) {
    while(*s) {
        do_syscall(1, *s);
        s++;        
    }
}

void test_func(int argc, char ** argv)
{
    unsigned char retval = 0;
    puts("scall 1 arg '!'\n");
    retval = do_syscall(1, '!');
    puts("return: "); printhex(retval); puts("\n");

    puts("test puts_scall: ");
    puts_scall("puts through scall\n");
}


void echo(int argc, char ** argv)
{
    char i = 0;
    for(i = 1; i<argc; i++) {
        puts(argv[i]); puts(" ");
    }
    puts("\n");
/*
    puts("echo:\n");
    while (1)
    {
        char c = getc();
        if (c)
        {
            putc(c);
        }
    }
    */
}

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

void (*loaded_bin)(void) = 0xA000;

void exec(int argc, char ** argv) {
    if(argc < 2) {
        return;
    }
    struct stat st;
    if(stat(argv[1], &st)) {
        puts("File not found\n");
    } else {
        //temporary map kernel page 0x0a to 0x1a to load app
        MMU_OFF();
        write_tlb(0, 0xa, 0x1a, 0xff);
        MMU_ON();
        read_file((unsigned char *)(0xA000), st.blk, 0, st.size);
        MMU_OFF();
        write_tlb(0, 0xa, 0xa, 0xff);
        MMU_ON();

        puts("File read\nset TLB idx and Jump..\n");
        /*
        asm("ldd X, 0xA000");
        asm("jmp");
        */
        write_tlb_index(1);
        loaded_bin();

    }
}

void exec2(int argc, char ** argv) {
    /*
    exec_process("app1.bin", 1);
    exec_process("app2.bin", 2);
    current_proc = 0;
    do_switch = 1;
    while(1) {} //spin a bit, never return after sched()
    */
}

void uptime(int argc, char ** argv) {
    puts("System is up for "); printhex(tick_counter); puts(" ticks.\n");
}

#define STORAGE_ADDR_LOW    0x4000
#define STORAGE_ADDR_MID    0x4001
#define STORAGE_ADDR_HIGH   0x4002
#define STORAGE_DATA        0x4804
/*
void load_page() {
    MMU_OFF();
    write_tlb(0, 0x0A, 0x10, 0);
    MMU_ON();

    *(unsigned char *)(STORAGE_ADDR_MID)  = 0;
    *(unsigned char *)(STORAGE_ADDR_HIGH) = 0;
    for(int i = 0; i<0x100; i++) {
        *(unsigned char *)(STORAGE_ADDR_LOW) = i;
        *(unsigned char *)(0xA000 + i) = *(unsigned char *)(STORAGE_DATA);
    }

    puts("Load complete\n");
    puts("0xA000: "); puts((char*)(0xA000)); puts("\n");

}
*/
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



#define N_CMDS 8

void (*funcs[])() = {test_func, print_process_list, echo, list_files, cat, exec, exec2, uptime};
char *cmds[] = {"s", "ps", "echo", "ls", "cat", "exec", "exec2", "uptime"};

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


    puts("!!! OVERFLOW FLAG INCORRECT IN ALUGENERATOR (0x80 instead of 0x08) !!!\n");

    puts("Kernel ready\n");

/*
    if(getc() != 'a') {
            puts("Exec init ["); puts(INIT_PROCESS); puts("]...\n");
            exec_process(INIT_PROCESS, 1);
            start_sched();
            while(1) {} //spin a bit, never return after sched()
    }
*/

#if 1

    int cmd_idx;

    int argc;
    char ** argv;
    while (1)
    {
        printhex(tick_counter);
        puts(" > ");
        cmd = getline();

        if(!strcmp(cmd,"init")) {
            puts("Exec init ["); puts(INIT_PROCESS); puts("]...\n");
            exec_process(INIT_PROCESS, 1);
            start_sched();
            while(1) {} //spin a bit, never return after sched()
        }

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


