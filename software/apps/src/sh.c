#define NULL 0

unsigned char do_syscall(unsigned char id, unsigned char arg, void * arg_ptr) {
    unsigned char retval;
    asm("mov A,a5");
    asm("mov XH,A");
    asm("mov A,a4");
    asm("mov XL,A");
    asm("mov A,a2");
    asm("mov B,A");
    asm("mov A,a0");
    asm("syscall");
    asm("mov A,B");
    asm("mov l-2,A");
    return retval;
}

void putc(char c) {
    do_syscall(1, c, 0);
}

char getc() {
    return do_syscall(2, 0, 0);
}

void exec(char * path) {
    do_syscall(5, 0, path);
}



void puts(char * s) {
    while(*s) {
        putc(*s);
        s++;        
    }
}

#define MAX_LENGTH 127

char in_str[MAX_LENGTH];
char * getline() {
   char c;
   int count = 0;
   char * s = in_str;
   while(1) {
      c = getc();

      if(!c) continue;
 
      putc(c);

      if(c == '\n' || c == '\r') {
         *s = 0;
         return in_str;
      } else {
        if(count < MAX_LENGTH - 1) {
            *s = c;
            s++;
            count++;
        }
      }
   }
}

int strcmp(const char *s1, const char *s2)
{
	const unsigned char *c1 = (const unsigned char *)s1;
	const unsigned char *c2 = (const unsigned char *)s2;
	unsigned char ch;
	int d = 0;

	while (1) {
		d = (int)(ch = *c1++) - (int)*c2++;
		if (d || !ch)
			break;
	}

	return d;
}


char *strchr(const char *s, int c)
{
	while (*s != (char)c) {
		if (!*s)
			return NULL;
		s++;
	}

	return (char *)s;
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

#define N_CMDS 8

void echo(int argc, char ** argv) {
    char i = 0;
    for(i = 1; i<argc; i++) {
        puts(argv[i]); puts(" ");
    }
    puts("\n");
}

void stats(int argc, char ** argv) {
    do_syscall(3, 0, 0);
}

void hlt(int argc, char ** argv) {
    asm("hlt");
}


void (*funcs[])() = {(void*)0, echo, stats, hlt};
char *cmds[] = {"exit", "echo", "stats", "hlt"};

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


int main() {
    int cmd_idx;
    int argc;
    char *cmd;
    char ** argv;

    puts("Shell\n");
    while (1)
    {
        puts("# ");
        cmd = getline();
        //puts("cmd: "); puts(cmd); puts("\n");
        argv = build_argv(cmd, &argc);
        cmd_idx = get_cmd_idx(argv[0]);

        if (cmd_idx < 0)
        {

            exec(argv[0]);
            // shouldn't return if correct
            puts("Bad command or filename\n");
        } else if(cmd_idx == 0) {
            puts("Exiting.\n");
            break;
        }
        else
        {
            funcs[cmd_idx](argc,argv);
        }
    }

    puts("while(1){}\n");
    while(1){};
    return 0;
}