void puts(char * s) {
    while(*s) {
        *(unsigned char *)(0x4803) = *s;
        s++;
    }
}



int putc(char c) {
    *(unsigned char *)(0x4803) = c;
}


int isdigit(char c) {
    return (c >= '0' && c <= '9');
}

char getc() {
   char c = *(unsigned char *)(0x4803);
   if(c == 0xff) c = 0;
   return c;
}


int atoi(const char *s) {
    int res = 0;
    while (isdigit(*s)) {
        res = res * 10;
        res += (*s) - '0';
        s++;
    }
    return res;
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

char *strcpy(char *dst, const char *src)
{
	char *q = dst;
	const char *p = src;
	char ch;

	do {
		*q++ = ch = *p++;
	} while (ch);

	return dst;
}

int strlen(const void *s) {
    const char *p = (const char *)s;
    int n = 0;
    while (*p) {
        p++;
        n++;
    }
    return n;
}

void reverse(char *s) {
    int i, j;
    char c;

    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

void itoa(int n, char s[]) {
    int i, sign = 0;
    if (n < 0) { // record sign 
        s[0] = '-';
        itoa(-n, s + 1);
        return;
    }
    i = 0;
    do { // generate digits in reverse order 

        s[i++] = n % 10 + '0'; // get next digit 
    } while ((n /= 10) > 0);   // delete it 
    if (sign == 1) {
        s[i++] = '-';
    }
    s[i] = '\0';
    reverse(s);
}


char *strncpy(char *d, const char *s, unsigned int l)
{
        char *s1 = d;
        const char *s2 = s;

        while (l) {
                l--;
                if ((*s1++ = *s2++) == '\0')
                        break;
        }

        // This _is_ correct strncpy is supposed to zap 
        while (l-- != 0)
                *s1++ = '\0';
        return d;
}


int memset(unsigned int *dest, const unsigned int val, int n) {
    int k = n;
    while (k--) {
        *dest = val;
        dest++;
    }
    return n;
}

int memcpy(unsigned int *dest, const unsigned int *src, int n) {
    int k = n;
    while (k--) {
        *dest = *src;
        dest++;
        src++;
    }
    return n;
}

int memcpy_r(unsigned int *dest, const unsigned int *src, int n) {
    int k = n;
    while (k--) {
        *dest = *src;
        dest++;
        src++;
    }
    return n;
}

int memcmp(const void *mem1, const void *mem2, int len)
{
        const signed char *p1 = mem1, *p2 = mem2;

        if (!len)
                return 0;

        while (--len && *p1 == *p2) {
                p1++;
                p2++;
        }
        return *p1 - *p2;
}





char printnum_buffer[8];



void printnum(int n) {
	char neg = 0;
	char * s = printnum_buffer + 7;
	char n_rem;
	*s = 0;
	if(n == 0) {
		s--;
		*s = '0';
	}
	if(n < 0) {
		neg = 1;
		n = -n;
	}
	while(n) {
		s--;
		n_rem = n % 10;
		*s = n_rem + '0';
		n = n / 10;
	}
	if(neg) {
		s--;
		*s = '-';
	}
	puts(s);
}



/*
static void printchar(char **str, int c) {
    if (str) {
        **str = c;
        ++(*str);
    } else
        (void)putc(c);
}

#define PAD_RIGHT 1
#define PAD_ZERO 2

static int prints(char **out, const char *string, int width, int pad) {
    int pc = 0, padchar = ' ';

    if (width > 0) {
        int len = 0;
        const char *ptr;
        for (ptr = string; *ptr; ++ptr)
            ++len;
        if (len >= width)
            width = 0;
        else
            width -= len;
        if (pad & PAD_ZERO)
            padchar = '0';
    }
    if (!(pad & PAD_RIGHT)) {
        for (; width > 0; --width) {
            printchar(out, padchar);
            ++pc;
        }
    }
    for (; *string; ++string) {
        printchar(out, *string);
        ++pc;
    }
    for (; width > 0; --width) {
        printchar(out, padchar);
        ++pc;
    }

    return pc;
}

// the following should be enough for 32 bit int 
#define PRINT_BUF_LEN 12

static int printi(char **out, int i, int b, int sg, int width, int pad,
                  int letbase) {
    char *s;
    int t, neg = 0, pc = 0;
    unsigned int u = i;
    char print_buf[PRINT_BUF_LEN];

    if (i == 0) {
        print_buf[0] = '0';
        print_buf[1] = '\0';
        return prints(out, print_buf, width, pad);
    }

    if (sg && b == 10 && i < 0) {
        neg = 1;
        u = -i;
    }

    s = print_buf + PRINT_BUF_LEN - 1;
    *s = '\0';

    if (b == 16) {
        while (u) {
            t = u & 0xf;
            if (t >= 10)
                t += letbase - '0' - 10;
            *--s = t + '0';
            u = u >> 4;
        }
    } else {
        while (u) {
            t = u % b;
            if (t >= 10)
                t += letbase - '0' - 10;
            *--s = t + '0';
            u /= b;
        }
    }

    if (neg) {
        if (width && (pad & PAD_ZERO)) {
            printchar(out, '-');
            ++pc;
            --width;
        } else {
            *--s = '-';
        }
    }

    return pc + prints(out, s, width, pad);
}

static int print(char **out, int *varg) {
    char scr[2];
    int width, pad;
    int pc = 0;
    char *format = (char *)(*varg++);
    for (; *format != 0; ++format) {
        if (*format == '%') {
            ++format;
            width = pad = 0;
            if (*format == '\0')
                break;
            if (*format == '%')
                goto out;
            if (*format == '-') {
                ++format;
                pad = PAD_RIGHT;
            }
            while (*format == '0') {
                ++format;
                pad |= PAD_ZERO;
            }
            for (; *format >= '0' && *format <= '9'; ++format) {
                width *= 10;
                width += *format - '0';
            }
            if (*format == 's') {
                char *s = *((char **)varg++);
                pc += prints(out, s ? s : "(null)", width, pad);
                continue;
            }
            if (*format == 'd') {
                pc += printi(out, *varg++, 10, 1, width, pad, 'a');
                continue;
            }
            if (*format == 'x') {
                pc += printi(out, *varg++, 16, 0, width, pad, 'a');
                continue;
            }
            if (*format == 'X') {
                pc += printi(out, *varg++, 16, 0, width, pad, 'A');
                continue;
            }
            if (*format == 'u') {
                pc += printi(out, *varg++, 10, 0, width, pad, 'a');
                continue;
            }
 
            if (*format == 'c') {
                // char are converted to int then pushed on the stack 
                scr[0] = *varg++;
                scr[1] = '\0';
                pc += prints(out, scr, width, pad);
                continue;
            }
        } else {
        out:
            printchar(out, *format);
            ++pc;
        }
    }
    if (out)
        **out = '\0';
    return pc;
}

// assuming sizeof(void *) == sizeof(int) 

int printf(const char *format, ...) {
    int *varg = (int *)(&format);
    return print(0, varg);
}

int sprintf(char *out, const char *format, ...) {
    int *varg = (int *)(&format);
    return print(&out, varg);
}
*/

void printhex(int i) {
    char printnum_buffer[8];
	char * s = printnum_buffer + 7;
	char n_rem;
	char n;
   *s = 0;
	s--;

   //asm(";checkme!\n");
   n = i;
	if(n == 0) {
      //puts("\n[printhex.1]\n");
		*s = '0';
		s--;
	}

	while(n) {
      //puts("\n[printhex.2]\n");
		n_rem = n & 0x0f;
		if(n_rem > 9) {
         //puts("\n[printhex.3]\n");
			*s = n_rem + 'A' - 10;
		} else {
         //puts("\n[printhex.4]\n");
			*s = n_rem + '0';
		}
		n = n >> 4;
		s--;
	}

   n = (i>>8);
	if(n == 0) {
      //puts("\n[printhex.5]\n");
		*s = '0';
		s--;
	}

	while(n) {
      //puts("\n[printhex.6]\n");
		n_rem = n & 0x0f;
		if(n_rem > 9) {
			*s = n_rem + 'A' - 10;
		} else {
			*s = n_rem + '0';
		}
		n = n >> 4;
		s--;
	}



   //puts("\n[printhex.7]\n");

	*s = 'x';
	s--;
	*s = '0';
	puts(s);
}

#define MAX_LENGTH 127

char in_str[MAX_LENGTH];
void getline() {
   char c;
   int count = 0;
   char * s = in_str;
   while(1) {
      c = getc();

      if(!c) continue;
 

      if(c == '\n' || c == '\r') {
         *s = 0;
         return;
      } else {
        if(count < MAX_LENGTH - 1) {
            *s = c;
            s++;
            count++;
        }
      }
   }

}

void test_func() {
   puts("this is a test func\n");   
}

void test_func_2() {
   puts("another test func\n");   
}

#define N_CMDS 2

void (*funcs[])() = {test_func, test_func_2};
char * cmds[] = {"test1", "test2"};


int get_cmd_idx(char * s) {
   int i = 0;
   for(i = 0; i<N_CMDS; i++) {
      puts("comparing with ");
      puts(cmds[i]);
      puts(" : ");
      if(!strcmp(cmds[i], s)) {
         puts("success\n");
         //puts("Success at "); printhex(i); puts("\n");
         return i;
      } else {
         puts("fail\n");
         //puts("Fail at "); printhex(i); puts("\n");
      }
   }
   return -1;
}


void tests() {
   char k = 1;
   if(k == 0) {
      puts("0.0.Fail\n");
   } else {
      puts("0.0.Pass\n");

   }
   k = 0;
   if(k == 0) {
      puts("0.1.Pass\n");
   } else {
      puts("0.1.Fail\n");

   }

   int l = 0x1000;
   if(l == 0) {
      puts("0.2.Fail\n");
   } else {
      puts("0.2.Pass\n");

   }
   l = 0;
   if(l == 0) {
      puts("0.3.Pass\n");
   } else {
      puts("0.3.Fail\n");

   }

   puts("Should print 5As nad 5Bs twice\n");
   for(char i = 0; i<10; i++) {
      if(i < 5) {
         putc('A');
      } else {
         putc('B');
      }
   }
   putc('\n');

   for(int i = 0; i<10; i++) {
      if(i < 5) {
         putc('A');
      } else {
         putc('B');
      }
   }
   putc('\n');

   puts("Print 0x1234:\n");
   printhex(0x1234);
   putc('\n');

   puts("Compare 'str1' and 'str2', should print not-zero\n");
   printhex(strcmp("str1","str2"));
   putc('\n');

   puts("Compare 'str3' and 'str3', should print zero\n");
   printhex(strcmp("str3","str3"));
   putc('\n');

   if(!strcmp("str1","str2")) {
      puts("This line should NOT be printed\n");
   }

   if(strcmp("str1","str2")) {
      puts("This line SHOULD be printed\n");
   }

   int count = 10;

   if(count < 50) {
      puts("1.Pass\n");
   } else {
      puts("1.Fail\n");
   }

   count = 100;

   if(count < 50) {
      puts("2.Fail\n");
   } else {
      puts("2.Pass\n");
   }

   count = -1;
   if(count < 0) {
      puts("3.Pass\n");
   } else {
      puts("3.Fail\n");
   }

}


void main() {
   puts("Hello world!\n");
   puts("This is a test string\n");
   tests();
   puts("Tests done. Halt.\n");

   int cmd_idx;

   while(1) {
      puts("> ");
      getline();
      puts("\ncmd: ");
      puts(in_str);
      puts("\n");

      cmd_idx = get_cmd_idx(in_str);

      if(cmd_idx < 0) {
            puts("unknown command\n");
      } else {
            funcs[cmd_idx]();
      }

   }

   asm("hlt\n");
}
