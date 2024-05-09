#ifndef SYS_TYPES_H
#define SYS_TYPES_H


/* LONG hack */
#define long int


typedef unsigned int uint16_t;
typedef int int16_t;
typedef unsigned char uint8_t;
typedef char int8_t;

typedef int intmax_t;
typedef unsigned int uintmax_t;


typedef unsigned int size_t;

typedef unsigned int off_t;
typedef unsigned int blk_t;

typedef int16_t pid_t;

typedef int16_t         intptr_t;
typedef uint16_t        uintptr_t;
typedef int16_t         ptrdiff_t;
#define INTPTR_MAX      32767
#define INTPTR_MIN      (-32768)
#define UINTPTR_MAX     65535

typedef uint8_t uint_fast8_t;
typedef int8_t int_fast8_t;
typedef uint16_t uint_fast16_t;
typedef int16_t int_fast16_t;

#define PTRDIFF_MAX     INTPTR_MAX
#define PTRDIFF_MIN     INTPTR_MIN
#define SIZE_MAX        UINTPTR_MAX

#define NULL 0


#endif /* ndef TYPES_H */
