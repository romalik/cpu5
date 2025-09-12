#ifndef KLIB_H__
#define KLIB_H__

char getc();
void puts(char * s);
int putc(char c);
int strcmp(const char *s1, const char *s2);
int memset(char *dest, const char val, int n);
int memcpy(char *dest, const char *src, int n);
int memcmp(const void *mem1, const void *mem2, int len);
void printhex(int i);
char * getline();
char *strchr(const char *s, int c);

#define NULL 0

#endif