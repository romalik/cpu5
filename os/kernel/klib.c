#include "klib.h"
#include "uart.h"
extern unsigned char uart_buffer[256];
extern unsigned char uart_buffer_size;
extern unsigned char uart_buffer_rd_pos;
extern unsigned char uart_buffer_wr_pos;
char getc() {
    char c = 0;
    if(uart_buffer_size) {
        uart_buffer_size--;
        c = uart_buffer[uart_buffer_rd_pos];
        uart_buffer_rd_pos++;
    }
    return c;
}



void puts(char * s) {
    while(*s) {
        *(unsigned char *)(0x4803) = *s;
        s++;
    }
}



int putc(char c) {
    *(unsigned char *)(0x4803) = c;
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


int memset(char *dest, const char val, int n) {
    int k = n;
    while (k--) {
        *dest = val;
        dest++;
    }
    return n;
}

int memcpy(char *dest, const char *src, int n) {
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





void printhex(int i) {
    char printnum_buffer[8];
	char * s = printnum_buffer + 7;
	char n_rem;
	char n;
    *s = 0;
	s--;

    n = i & 0x000f;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    n = i & 0x00f0;
    n = n >> 4;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    i = i >> 8;

    n = i & 0x000f;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    n = i & 0x00f0;
    n = n >> 4;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

	*s = 'x';
	s--;
	*s = '0';
	puts(s);
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

char *strchr(const char *s, int c)
{
	while (*s != (char)c) {
		if (!*s)
			return NULL;
		s++;
	}

	return (char *)s;
}

