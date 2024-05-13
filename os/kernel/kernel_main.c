#include "klib.h"
#include "mmu.h"
#include "uart.h"
#include "interrupts.h"
#include "syscall.h"
#include "fs.h"

int fxnMul() { return 0; }
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

void test_func_2(int argc, char ** argv)
{
    /*
    for(int i = 0; i<argc; i++) {
        puts("arg "); printhex(i); puts(": '"); puts(argv[i]); puts("'\n");
    }
    */
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



#define N_CMDS 5

void (*funcs[])() = {test_func, test_func_2, echo, list_files, cat};
char *cmds[] = {"s", "test", "echo", "ls", "cat"};

int get_cmd_idx(char *s)
{
    int i = 0;
    for (i = 0; i < N_CMDS; i++)
    {
        if (!strcmp(cmds[i], s))
        {
            return i;
        }
    }
    return -1;
}

extern char __text_end;
extern char __data_end;
extern char __bss_end;


extern int btn_counter;
void main()
{
    char *cmd;
    int i = 0;
    btn_counter = 0;
    puts("\n\nKernel\n");
    puts("text end: "); printhex(&__text_end);
    puts("\ndata end: "); printhex(&__data_end);
    puts("\nbss end : "); printhex(&__bss_end);
    puts("\n");


    init_uart();
    init_mmu();
    init_interrupts();
    puts("Ready\n");

    int cmd_idx;

    int argc;
    char ** argv;
    while (1)
    {
        printhex(btn_counter);
        puts(" > ");
        cmd = getline();
        // puts("cmd: "); puts(cmd); puts("\n");
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
