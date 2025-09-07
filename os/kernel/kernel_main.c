#include "klib.h"
#include "mmu.h"
#include "uart.h"
#include "interrupts.h"
#include "syscall.h"
#include "fs.h"



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
    puts("echo:\n");
    while (1)
    {
        char c = getc();
        if (c)
        {
            putc(c);
        }
    }
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



void init_process_list() {
    memset(p_list, 0, sizeof(struct Process) * N_PROC);
    for(int i = 0; i<N_PROC; i++) {
        //puts("fill "); printhex(i);
        p_list[i].tlb_index = i; 
        p_list[i].start_page = (i) << 4;

        p_list[i].pid = i;
    }
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

void exec2(int argc, char ** argv) {
    exec_process("app1.bin", 1);
    exec_process("app2.bin", 2);
    current_proc = 0;
    do_switch = 1;
    while(1) {} //spin a bit, never return after sched()
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



#define N_CMDS 7

void (*funcs[])() = {test_func, print_process_list, echo, list_files, cat, exec, exec2};
char *cmds[] = {"s", "ps", "echo", "ls", "cat", "exec", "exec2"};

int get_cmd_idx(char *s)
{
    int i = 0;
    for (i = 0; i < N_CMDS; i++)
    {
        puts("cmp: "); puts(s); puts(" with "); puts(cmds[i]); puts("\n");
        if (!strcmp(cmds[i], s))
        {
            puts("ok!\n");
            return i;
        }
    }
    return -1;
}

extern char __text_end;
extern char __data_end;
extern char __bss_end;

char test_string_1[] = "Test string one";
char test_string_2[] = "Test string two";
char test_string_3[] = "Test string one";

void run_tests() {

    char a = 0xfb;
    int ai = 0xfb;
    char b = 0x0b;
    int bi = 0x0b;

    int zi = 0x00;

    puts("a  = "); printhex(a);  puts(" !a  = "); printhex(!a);  puts("\n");
    puts("ai = "); printhex(ai); puts(" !ai = "); printhex(!ai); puts("\n");
    puts("b  = "); printhex(b);  puts(" !b  = "); printhex(!b);  puts("\n");
    puts("bi = "); printhex(bi); puts(" !bi = "); printhex(!bi); puts("\n");


    if(a) {
        puts("(a) is true\n");
    }
    if(!a) {
        puts("(!a) is true\n");
    }
    if(ai) {
        puts("(ai) is true\n");
    }
    if(!ai) {
        puts("(!ai) is true\n");
    }

    puts("a  -  b = "); printhex(a - b); puts("\n");
    puts("a  +  b = "); printhex(a + b); puts("\n");
    puts("b  -  a = "); printhex(b - a); puts("\n");
    puts("ai - bi = "); printhex(ai-bi); puts("\n");
    puts("ai + bi = "); printhex(ai+bi); puts("\n");
    puts("bi - ai = "); printhex(bi-ai); puts("\n");
    puts("ai - zi = "); printhex(ai-zi); puts("\n");



    int ret = 0;

    puts("strcmp \""); puts(test_string_1); puts("\" and \""); puts(test_string_2); puts("\" : ");
    printhex(strcmp(test_string_1, test_string_2)); puts("\n");

    if(!strcmp(test_string_1, test_string_2)) {
        puts("Strings equal\n");
    } else {
        puts("Strings not equal\n");
    }

    ret = strcmp(test_string_1, test_string_2);
    puts("ret  = ");
    printhex(ret); putc('\n');
    puts("!ret = ");
    printhex(!ret); putc('\n');

    if(!ret) {
        puts("Strings equal (!ret)\n");
    } else {
        puts("Strings not equal (ret)\n");
    }


/*
    unsigned char ua = 0xaa;
    unsigned char ub = 0xbb;

    char a = 0xaa;
    char b = 0xbb;

    unsigned int uai = 0xaaaa;
    unsigned int ubi = 0xaabb;

    int ai = 0xaaaa;
    int bi = 0xaabb;

    int ret = 0;

    puts("strcmp \""); puts(test_string_1); puts("\" and \""); puts(test_string_2); puts("\" : ");
    printhex(strcmp(test_string_1, test_string_2)); puts("\n");

    if(!strcmp(test_string_1, test_string_2)) {
        puts("Strings equal\n");
    } else {
        puts("Strings not equal\n");
    }

    ret = strcmp(test_string_1, test_string_2);
    printhex(ret); putc('\n');
    printhex(!ret); putc('\n');

    if(!ret) {
        puts("Strings equal\n");
    } else {
        puts("Strings not equal\n");
    }


    puts("compare uint8's\n");

    printhex(ua); putc('\n');
    printhex(ub); putc('\n');
    if(ua == ub) {
        puts("EQ\n");
    } else {
        puts("NEQ\n");
    }

    puts("compare uint16's\n");

    printhex(uai); putc('\n');
    printhex(ubi); putc('\n');
    if(uai == ubi) {
        puts("EQ\n");
    } else {
        puts("NEQ\n");
    }

    puts("compare int8's\n");

    printhex(a); putc('\n');
    printhex(b); putc('\n');
    if(a == b) {
        puts("EQ\n");
    } else {
        puts("NEQ\n");
    }

    puts("compare int16's\n");

    printhex(ai); putc('\n');
    printhex(bi); putc('\n');
    if(ai == bi) {
        puts("EQ\n");
    } else {
        puts("NEQ\n");
    }

    if(a) {
        puts("a non zero\n");
    }
    if(!a) {
        puts("a zero\n");
    }
    
    if(ai) {
        puts("ai non zero\n");
    }
    if(!ai) {
        puts("ai zero\n");
    }
    
    if(ua) {
        puts("ua non zero\n");
    }
    if(!ua) {
        puts("ua zero\n");
    }
    
    if(uai) {
        puts("uai non zero\n");
    }
    if(!uai) {
        puts("uai zero\n");
    }
  */  


}


#include "blk.h"

extern int tick_counter;
void main()
{
    char *cmd;
    int i = 0;

    tick_counter = 0;
    puts("\n\nKernel\n");
    puts("text end: "); printhex(&__text_end);
    puts("\ndata end: "); printhex(&__data_end);
    puts("\nbss end : "); printhex(&__bss_end);
    puts("\n");

    puts("Run tests:\n");
    run_tests();
    puts("Tests done\n");


    do_switch = 0;


    init_uart();
    init_mmu();
    init_interrupts();
    init_process_list();

    //print_process_list();
    
    /*
    puts("block init..\n");
    block_init();
    dump_blocks();
*/


    puts("Ready\n");


    int cmd_idx;

    int argc;
    char ** argv;
    while (1)
    {
        printhex(tick_counter);
        puts(" > ");
        cmd = getline();
        puts("cmd: "); puts(cmd); puts("\n");
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
}



void sched() {
    if(do_switch) {
        if(tick_counter & 0x07) return;

        puts("\n#sw from "); printhex(current_proc);
        save_isr_ctx_to(&p_list[current_proc].ctx);
        while(1) {
            current_proc++;
            if(current_proc >= N_PROC) {
                puts(" .ovf. ");
                current_proc = 0;
            }
            if(p_list[current_proc].status == PROCESS_RUN) {
                puts(" to "); printhex(current_proc); puts("\n");
                load_isr_ctx_from(&p_list[current_proc].ctx);
                write_tlb_index(p_list[current_proc].tlb_index);
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