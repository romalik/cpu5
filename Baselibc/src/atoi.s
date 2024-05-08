
 ; glb uint16_t : unsigned
 ; glb int16_t : int
 ; glb uint8_t : unsigned char
 ; glb int8_t : char
 ; glb intmax_t : int
 ; glb uintmax_t : unsigned
 ; glb size_t : unsigned
 ; glb off_t : unsigned
 ; glb blk_t : unsigned
 ; glb pid_t : int
 ; glb imaxabs : (
 ; prm     __n : int
 ;     ) int
.section text
imaxabs:
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     __n : (@4) : int
 ; return
 ; loc     <something> : int
 ; RPN'ized expression: "__n 0 (something3) < __n __n -u ? "
 ; Expanded expression: "(@4) *(2) 0 < [sh||->4] (@4) *(2) goto &&[4] (@4) *(2) -u &&[5] "
 ; Expression stack:    "(@4) *(2) 0 < [sh||->4] (@4) *(2) [goto->5] &&[4] (@4) *(2) -u &&[5] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 006<tokLogAnd> "5" size(0) REG: z0  
 ;  -  - 006<tokLogAnd> "4" size(0) REG: z0  
 ;  -  -  - 090<tokShortCirc> "-4" size(0) REG: z0  
 ;  -  -  -  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  -  -  - 021<tokGoto> "5" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 080<tokUnaryMinus> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 006<tokLogAnd> "5" size(2) REG: r0  
 ;  -  - 006<tokLogAnd> "4" size(2) REG: r0  
 ;  -  -  - 090<tokShortCirc> "-4" size(2) REG: r0  
 ;  -  -  -  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  - 001<tokNumInt> "0" size(2) REG: r4  *
 ;  -  -  - 021<tokGoto> "5" size(2) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  -  - 080<tokUnaryMinus> "0" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokLess]- a0 r4  value(0) size (2)
ldd X, $L6
tsub r0, a0, r4
tsbc r1, a1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L6:
 ; r0 <-[tokShortCirc]- r0  value(-4) size (2)
 ; tokShortCirc
 ; Jump if not zero to L4
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L4
jnz
 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokGoto]- a0  value(5) size (2)
 ; Unconditional jump to L5
ldd X, $L5
jmp
 ; r0 <-[tokLogAnd]- r0 r0  value(4) size (2)
 ; tokLogAndOr
L4:
 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokUnaryMinus]- a0  value(0) size (2)
 ;; optimize this
mov A, a0
not
inc
mov r0, A
ld A,0
mov B,A
mov A, a1
adc
mov r1, A
 ; r0 <-[tokLogAnd]- r0 r0  value(5) size (2)
 ; tokLogAndOr
L5:
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L1:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb strtoimax : (
 ; prm     <something> : * char
 ; prm     <something> : * * char
 ; prm     <something> : int
 ;     ) int
 ; glb strtoumax : (
 ; prm     <something> : * char
 ; prm     <something> : * * char
 ; prm     <something> : int
 ;     ) unsigned
 ; glb strntoimax : (
 ; prm     <something> : * char
 ; prm     <something> : * * char
 ; prm     <something> : int
 ; prm     <something> : unsigned
 ;     ) int
 ; glb strntoumax : (
 ; prm     <something> : * char
 ; prm     <something> : * * char
 ; prm     <something> : int
 ; prm     <something> : unsigned
 ;     ) unsigned
 ; glb abs : (
 ; prm     __n : int
 ;     ) int
.section text
abs:
.export abs
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     __n : (@4) : int
 ; return
 ; RPN'ized expression: "__n 0 < __n __n -u ? "
 ; Expanded expression: "(@4) *(2) 0 < [sh||->9] (@4) *(2) goto &&[9] (@4) *(2) -u &&[10] "
 ; Expression stack:    "(@4) *(2) 0 < [sh||->9] (@4) *(2) [goto->10] &&[9] (@4) *(2) -u &&[10] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 006<tokLogAnd> "10" size(0) REG: z0  
 ;  -  - 006<tokLogAnd> "9" size(0) REG: z0  
 ;  -  -  - 090<tokShortCirc> "-9" size(0) REG: z0  
 ;  -  -  -  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  -  -  - 021<tokGoto> "10" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 080<tokUnaryMinus> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 006<tokLogAnd> "10" size(2) REG: r0  
 ;  -  - 006<tokLogAnd> "9" size(2) REG: r0  
 ;  -  -  - 090<tokShortCirc> "-9" size(2) REG: r0  
 ;  -  -  -  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  - 001<tokNumInt> "0" size(2) REG: r4  *
 ;  -  -  - 021<tokGoto> "10" size(2) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  -  - 080<tokUnaryMinus> "0" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokLess]- a0 r4  value(0) size (2)
ldd X, $L11
tsub r0, a0, r4
tsbc r1, a1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L11:
 ; r0 <-[tokShortCirc]- r0  value(-9) size (2)
 ; tokShortCirc
 ; Jump if not zero to L9
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L9
jnz
 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokGoto]- a0  value(10) size (2)
 ; Unconditional jump to L10
ldd X, $L10
jmp
 ; r0 <-[tokLogAnd]- r0 r0  value(9) size (2)
 ; tokLogAndOr
L9:
 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokUnaryMinus]- a0  value(0) size (2)
 ;; optimize this
mov A, a0
not
inc
mov r0, A
ld A,0
mov B,A
mov A, a1
adc
mov r1, A
 ; r0 <-[tokLogAnd]- r0 r0  value(10) size (2)
 ; tokLogAndOr
L10:
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L7:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb atoi : (
 ; prm     <something> : * char
 ;     ) int
 ; glb free : (
 ; prm     <something> : * void
 ;     ) void
 ; glb malloc : (
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb calloc : (
 ; prm     <something> : unsigned
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb realloc : (
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb add_malloc_block : (
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ;     ) void
 ; glb get_malloc_memory_status : (
 ; prm     <something> : * unsigned
 ; prm     <something> : * unsigned
 ;     ) void
 ; glb malloc_lock_t : * (void) char
 ; glb malloc_unlock_t : * (void) void
 ; glb set_malloc_locking : (
 ; prm     <something> : * (void) char
 ; prm     <something> : * (void) void
 ;     ) void
 ; glb __comparefunc_t : * (
 ; prm     <something> : * void
 ; prm     <something> : * void
 ;     ) int
 ; glb bsearch : (
 ; prm     <something> : * void
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ; prm     <something> : unsigned
 ; prm     <something> : * (
 ; prm         <something> : * void
 ; prm         <something> : * void
 ;         ) int
 ;     ) * void
 ; glb qsort : (
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ; prm     <something> : unsigned
 ; prm     <something> : * (
 ; prm         <something> : * void
 ; prm         <something> : * void
 ;         ) int
 ;     ) void
 ; glb seed48 : (
 ; prm     <something> : * unsigned
 ;     ) * unsigned
 ; glb rand : (void) int
.section text
rand:
.export rand
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; return
 ; loc     <something> : int
 ; RPN'ized expression: "( lrand48 ) (something14) "
 ; Expanded expression: " lrand48 ()0 "
 ; Expression stack:    "( lrand48 )0 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 041<tokCall> "0" size(0) REG: z0  
 ;  -  - 016<tokIdent> "365" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "0" size(2) REG: r0  
 ;  -  - 016<tokIdent> "365" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(365) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0  value(0) size (2)
 ; pushed 0 args
 ; no args, reserve 2 bytes for retval
SP-=2
ldd X, $lrand48
jmp
popw r0
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L12:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb srand : (
 ; prm     __s : unsigned
 ;     ) void
.section text
srand:
.export srand
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     __s : (@4) : unsigned
 ; RPN'ized expression: "( __s srand48 ) "
 ; Expanded expression: " (@4) *(2)  srand48 ()2 "
 ; Expression stack:    "( (@4) *(2) , srand48 )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 016<tokIdent> "362" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "362" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(362) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a0 r2  value(2) size (2)
pushw a0
 ; pushed 1 args
ldd X, $srand48
jmp
popw r0



L15:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb srandom : (
 ; prm     __s : unsigned
 ;     ) void
.section text
srandom:
.export srandom
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     __s : (@4) : unsigned
 ; RPN'ized expression: "( __s srand48 ) "
 ; Expanded expression: " (@4) *(2)  srand48 ()2 "
 ; Expression stack:    "( (@4) *(2) , srand48 )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 016<tokIdent> "371" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "371" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(371) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a0 r2  value(2) size (2)
pushw a0
 ; pushed 1 args
ldd X, $srand48
jmp
popw r0



L17:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb va_list : * char
 ; glb memccpy : (
 ; prm     <something> : * void
 ; prm     <something> : * void
 ; prm     <something> : int
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb memchr : (
 ; prm     <something> : * void
 ; prm     <something> : int
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb memrchr : (
 ; prm     <something> : * void
 ; prm     <something> : int
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb memcmp : (
 ; prm     <something> : * void
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ;     ) int
 ; glb memcpy : (
 ; prm     <something> : * void
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb memmove : (
 ; prm     <something> : * void
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb memset : (
 ; prm     <something> : * void
 ; prm     <something> : int
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb memmem : (
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ;     ) * void
 ; glb memswap : (
 ; prm     <something> : * void
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ;     ) void
 ; glb bzero : (
 ; prm     <something> : * void
 ; prm     <something> : unsigned
 ;     ) void
 ; glb strcasecmp : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) int
 ; glb strncasecmp : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ; prm     <something> : unsigned
 ;     ) int
 ; glb strcat : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) * char
 ; glb strchr : (
 ; prm     <something> : * char
 ; prm     <something> : int
 ;     ) * char
 ; glb index : (
 ; prm     <something> : * char
 ; prm     <something> : int
 ;     ) * char
 ; glb strrchr : (
 ; prm     <something> : * char
 ; prm     <something> : int
 ;     ) * char
 ; glb rindex : (
 ; prm     <something> : * char
 ; prm     <something> : int
 ;     ) * char
 ; glb strcmp : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) int
 ; glb strcpy : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) * char
 ; glb strcspn : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) unsigned
 ; glb strdup : (
 ; prm     <something> : * char
 ;     ) * char
 ; glb strndup : (
 ; prm     <something> : * char
 ; prm     <something> : unsigned
 ;     ) * char
 ; glb strlen : (
 ; prm     <something> : * char
 ;     ) unsigned
 ; glb strnlen : (
 ; prm     <something> : * char
 ; prm     <something> : unsigned
 ;     ) unsigned
 ; glb strncat : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ; prm     <something> : unsigned
 ;     ) * char
 ; glb strlcat : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ; prm     <something> : unsigned
 ;     ) unsigned
 ; glb strncmp : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ; prm     <something> : unsigned
 ;     ) int
 ; glb strncpy : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ; prm     <something> : unsigned
 ;     ) * char
 ; glb strlcpy : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ; prm     <something> : unsigned
 ;     ) unsigned
 ; glb strpbrk : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) * char
 ; glb strsep : (
 ; prm     <something> : * * char
 ; prm     <something> : * char
 ;     ) * char
 ; glb strspn : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) unsigned
 ; glb strstr : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) * char
 ; glb strtok : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ;     ) * char
 ; glb strtok_r : (
 ; prm     <something> : * char
 ; prm     <something> : * char
 ; prm     <something> : * * char
 ;     ) * char
 ; glb strcoll : (
 ; prm     s1 : * char
 ; prm     s2 : * char
 ;     ) int
.section text
strcoll:
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     s1 : (@4) : * char
 ; loc     s2 : (@6) : * char
 ; return
 ; RPN'ized expression: "( s2 , s1 strcmp ) "
 ; Expanded expression: " (@6) *(2)  (@4) *(2)  strcmp ()4 "
 ; Expression stack:    "( (@6) *(2) , (@4) *(2) , strcmp )4 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "524" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "4" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 016<tokIdent> "524" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(524) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a2 a0 r4  value(4) size (2)
pushw a2
pushw a0
 ; pushed 2 args
ldd X, $strcmp
jmp
popw r0
SP+=2
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L19:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb strxfrm : (
 ; prm     dest : * char
 ; prm     src : * char
 ; prm     n : unsigned
 ;     ) unsigned
.section text
strxfrm:
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     dest : (@4) : * char
 ; loc     src : (@6) : * char
 ; loc     n : (@8) : unsigned
 ; RPN'ized expression: "( n , src , dest strncpy ) "
 ; Expanded expression: " (@8) *(2)  (@6) *(2)  (@4) *(2)  strncpy ()6 "
 ; Expression stack:    "( (@8) *(2) , (@6) *(2) , (@4) *(2) , strncpy )6 "
 ; Expr tree before optim: 
 ; 041<tokCall> "6" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 016<tokIdent> "610" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "6" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "610" size(2) REG: r6 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokIdent]-  value(610) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a4 a2 a0 r6  value(6) size (2)
pushw a4
pushw a2
pushw a0
 ; pushed 3 args
ldd X, $strncpy
jmp
popw r0
SP+=2
SP+=2



 ; return
 ; RPN'ized expression: "( src strlen ) "
 ; Expanded expression: " (@6) *(2)  strlen ()2 "
 ; Expression stack:    "( (@6) *(2) , strlen )2 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 041<tokCall> "2" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "566" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "2" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 016<tokIdent> "566" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(566) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a2 r2  value(2) size (2)
pushw a2
 ; pushed 1 args
ldd X, $strlen
jmp
popw r0
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L21:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb FILE : struct File
 ; glb stdin : * struct File
 ; glb stdout : * struct File
 ; glb stderr : * struct File
 ; glb fread : (
 ; prm     buf : * void
 ; prm     size : unsigned
 ; prm     nmemb : unsigned
 ; prm     stream : * struct File
 ;     ) unsigned
.section text
fread:
.export fread
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     buf : (@4) : * void
 ; loc     size : (@6) : unsigned
 ; loc     nmemb : (@8) : unsigned
 ; loc     stream : (@10) : * struct File
 ; if
 ; RPN'ized expression: "stream vmt -> *u read -> *u 0 == "
 ; Expanded expression: "(@10) *(2) 0 + *(2) 2 + *(2) 0 == "
 ; Expression stack:    "(@10) *(2) 0 + *(2) 2 + *(2) 0 == IF![25] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "25" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "10" size(0) REG: z0  *
 ;  -  -  -  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  -  -  -  - 001<tokNumInt> "2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "25" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: r2  
 ;  -  -  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: r2  
 ;  -  -  -  -  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a6 SUPPRESSED 
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "10" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  -  - 001<tokNumInt> "0" size(2) REG: r4  *
 ;  -  -  -  - 001<tokNumInt> "2" size(2) REG: r4  *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(10) size (2)
 ; !!! emit suppressed
 ; a6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r2 <-[tokAdd]- a6 r4  value(0) size (2)
tadd r2, a6, r4
tadc r3, a7, r5
 ; r2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r2
mov A, [X]
mov r2, A
 ; emit_inc_x()
X++
mov A, [X]
mov r3, A
 ; r4 <-[tokNumInt]-  value(2) size (2)
 ; possible optimization - pass size
ld r4, 2
ld r5, 0
 ; r2 <-[tokAdd]- r2 r4  value(0) size (2)
tadd r2, r2, r4
tadc r3, r3, r5
 ; r2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r2
mov A, [X]
mov r2, A
 ; emit_inc_x()
X++
mov A, [X]
mov r3, A
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- r2 r4  value(0) size (2)
ldd X, $L27
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L27:
 ; r0 <-[tokIfNot]- r0  value(25) size (2)
 ; Jump if zero to L25
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L25
jz



 ; return
 ; RPN'ized expression: "0 "
 ; Expanded expression: "0 "
 ; Expression value: 0
 ; Expression stack:    "0 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 001<tokNumInt> "0" size(2) REG: r0  *

 ; r0 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r0, 0
ld r1, 0
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Unconditional jump to L23
ldd X, $L23
jmp
L25:
 ; return
 ; RPN'ized expression: "( size nmemb * , buf , stream stream vmt -> *u read -> *u ) size / "
 ; Expanded expression: " (@6) *(2) (@8) *(2) *  (@4) *(2)  (@10) *(2)  (@10) *(2) 0 + *(2) 2 + *(2) ()6 (@6) *(2) /u "
 ; Expression stack:    "( (@6) *(2) (@8) *(2) * , (@4) *(2) , (@10) *(2) , (@10) *(2) 0 + *(2) 2 + *(2) )6 (@6) *(2) /u return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 029<tokUDiv> "0" size(0) REG: z0  
 ;  -  - 041<tokCall> "6" size(0) REG: z0  
 ;  -  -  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "10" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  -  -  - 089<tokLocalOfs> "10" size(0) REG: z0  *
 ;  -  -  -  -  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  -  -  -  -  - 001<tokNumInt> "2" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "0" size(2) REG: r0  
 ;  -  - 041<tokCall> "6" size(2) REG: r0  
 ;  -  -  - 041<tokCall> "0" size(2) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 016<tokIdent> "846" size(0) REG: r4 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a6 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "10" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: r6  
 ;  -  -  -  - 043<tokAdd> "0" size(2) REG: r6  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: r6  
 ;  -  -  -  -  -  - 043<tokAdd> "0" size(2) REG: r6  
 ;  -  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a6 SUPPRESSED 
 ;  -  -  -  -  -  -  -  - 089<tokLocalOfs> "10" size(2) REG: r6 SUPPRESSED *
 ;  -  -  -  -  -  -  - 001<tokNumInt> "0" size(2) REG: r8  *
 ;  -  -  -  -  - 001<tokNumInt> "2" size(2) REG: r8  *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 016<tokIdent> "837" size(0) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(846) size (0)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a2 a4 r4  value(0) size (2)
pushw a2
pushw a4
 ; pushed 2 args
ldd X, $fxnMul
jmp
popw r0
SP+=2
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(10) size (2)
 ; !!! emit suppressed
 ; a6 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokLocalOfs]-  value(10) size (2)
 ; !!! emit suppressed
 ; a6 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r8, 0
ld r9, 0
 ; r6 <-[tokAdd]- a6 r8  value(0) size (2)
tadd r6, a6, r8
tadc r7, a7, r9
 ; r6 <-[tokUnaryStar]- r6  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r6
mov A, [X]
mov r6, A
 ; emit_inc_x()
X++
mov A, [X]
mov r7, A
 ; r8 <-[tokNumInt]-  value(2) size (2)
 ; possible optimization - pass size
ld r8, 2
ld r9, 0
 ; r6 <-[tokAdd]- r6 r8  value(0) size (2)
tadd r6, r6, r8
tadc r7, r7, r9
 ; r6 <-[tokUnaryStar]- r6  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r6
mov A, [X]
mov r6, A
 ; emit_inc_x()
X++
mov A, [X]
mov r7, A
 ; r0 <-[tokCall]- r0 a0 a6 r6  value(6) size (2)
pushw r0
pushw a0
pushw a6
 ; pushed 3 args
 ; Call not by tokIdent - load address
movw X, r6
jmp
popw r0
SP+=2
SP+=2
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(837) size (0)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 a2 r4  value(0) size (2)
pushw r0
pushw a2
 ; pushed 2 args
ldd X, $fxnUDiv
jmp
popw r0
SP+=2
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L23:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb fwrite : (
 ; prm     buf : * void
 ; prm     size : unsigned
 ; prm     nmemb : unsigned
 ; prm     stream : * struct File
 ;     ) unsigned
.section text
fwrite:
.export fwrite
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     buf : (@4) : * void
 ; loc     size : (@6) : unsigned
 ; loc     nmemb : (@8) : unsigned
 ; loc     stream : (@10) : * struct File
 ; if
 ; RPN'ized expression: "stream vmt -> *u write -> *u 0 == "
 ; Expanded expression: "(@10) *(2) 0 + *(2) 0 + *(2) 0 == "
 ; Expression stack:    "(@10) *(2) 0 + *(2) 0 + *(2) 0 == IF![30] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "30" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "10" size(0) REG: z0  *
 ;  -  -  -  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  -  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "30" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: r2  
 ;  -  -  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: r2  
 ;  -  -  -  -  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a6 SUPPRESSED 
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "10" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  -  - 001<tokNumInt> "0" size(2) REG: r4  *
 ;  -  -  -  - 001<tokNumInt> "0" size(2) REG: r4  *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(10) size (2)
 ; !!! emit suppressed
 ; a6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r2 <-[tokAdd]- a6 r4  value(0) size (2)
tadd r2, a6, r4
tadc r3, a7, r5
 ; r2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r2
mov A, [X]
mov r2, A
 ; emit_inc_x()
X++
mov A, [X]
mov r3, A
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r2 <-[tokAdd]- r2 r4  value(0) size (2)
tadd r2, r2, r4
tadc r3, r3, r5
 ; r2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r2
mov A, [X]
mov r2, A
 ; emit_inc_x()
X++
mov A, [X]
mov r3, A
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- r2 r4  value(0) size (2)
ldd X, $L32
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L32:
 ; r0 <-[tokIfNot]- r0  value(30) size (2)
 ; Jump if zero to L30
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L30
jz



 ; return
 ; RPN'ized expression: "0 "
 ; Expanded expression: "0 "
 ; Expression value: 0
 ; Expression stack:    "0 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 001<tokNumInt> "0" size(2) REG: r0  *

 ; r0 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r0, 0
ld r1, 0
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Unconditional jump to L28
ldd X, $L28
jmp
L30:
 ; return
 ; RPN'ized expression: "( size nmemb * , buf , stream stream vmt -> *u write -> *u ) size / "
 ; Expanded expression: " (@6) *(2) (@8) *(2) *  (@4) *(2)  (@10) *(2)  (@10) *(2) 0 + *(2) 0 + *(2) ()6 (@6) *(2) /u "
 ; Expression stack:    "( (@6) *(2) (@8) *(2) * , (@4) *(2) , (@10) *(2) , (@10) *(2) 0 + *(2) 0 + *(2) )6 (@6) *(2) /u return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 029<tokUDiv> "0" size(0) REG: z0  
 ;  -  - 041<tokCall> "6" size(0) REG: z0  
 ;  -  -  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "10" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  -  -  - 089<tokLocalOfs> "10" size(0) REG: z0  *
 ;  -  -  -  -  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  -  -  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "0" size(2) REG: r0  
 ;  -  - 041<tokCall> "6" size(2) REG: r0  
 ;  -  -  - 041<tokCall> "0" size(2) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 016<tokIdent> "854" size(0) REG: r4 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a6 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "10" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: r6  
 ;  -  -  -  - 043<tokAdd> "0" size(2) REG: r6  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: r6  
 ;  -  -  -  -  -  - 043<tokAdd> "0" size(2) REG: r6  
 ;  -  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a6 SUPPRESSED 
 ;  -  -  -  -  -  -  -  - 089<tokLocalOfs> "10" size(2) REG: r6 SUPPRESSED *
 ;  -  -  -  -  -  -  - 001<tokNumInt> "0" size(2) REG: r8  *
 ;  -  -  -  -  - 001<tokNumInt> "0" size(2) REG: r8  *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 016<tokIdent> "845" size(0) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(854) size (0)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a2 a4 r4  value(0) size (2)
pushw a2
pushw a4
 ; pushed 2 args
ldd X, $fxnMul
jmp
popw r0
SP+=2
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(10) size (2)
 ; !!! emit suppressed
 ; a6 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokLocalOfs]-  value(10) size (2)
 ; !!! emit suppressed
 ; a6 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r8, 0
ld r9, 0
 ; r6 <-[tokAdd]- a6 r8  value(0) size (2)
tadd r6, a6, r8
tadc r7, a7, r9
 ; r6 <-[tokUnaryStar]- r6  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r6
mov A, [X]
mov r6, A
 ; emit_inc_x()
X++
mov A, [X]
mov r7, A
 ; r8 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r8, 0
ld r9, 0
 ; r6 <-[tokAdd]- r6 r8  value(0) size (2)
tadd r6, r6, r8
tadc r7, r7, r9
 ; r6 <-[tokUnaryStar]- r6  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r6
mov A, [X]
mov r6, A
 ; emit_inc_x()
X++
mov A, [X]
mov r7, A
 ; r0 <-[tokCall]- r0 a0 a6 r6  value(6) size (2)
pushw r0
pushw a0
pushw a6
 ; pushed 3 args
 ; Call not by tokIdent - load address
movw X, r6
jmp
popw r0
SP+=2
SP+=2
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(845) size (0)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 a2 r4  value(0) size (2)
pushw r0
pushw a2
 ; pushed 2 args
ldd X, $fxnUDiv
jmp
popw r0
SP+=2
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L28:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb fputs : (
 ; prm     s : * char
 ; prm     f : * struct File
 ;     ) int
.section text
fputs:
.export fputs
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     s : (@4) : * char
 ; loc     f : (@6) : * struct File
 ; return
 ; RPN'ized expression: "( f , ( s strlen ) , 1 , s fwrite ) "
 ; Expanded expression: " (@6) *(2)   (@4) *(2)  strlen ()2  1  (@4) *(2)  fwrite ()8 "
 ; Expression stack:    "( (@6) *(2) , ( (@4) *(2) , strlen )2 , 1 , (@4) *(2) , fwrite )8 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 041<tokCall> "8" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  - 041<tokCall> "2" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "566" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "833" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "8" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 041<tokCall> "2" size(2) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 016<tokIdent> "566" size(2) REG: r4 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r6 SUPPRESSED *
 ;  -  - 016<tokIdent> "833" size(2) REG: r8 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(566) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- a0 r4  value(2) size (2)
pushw a0
 ; pushed 1 args
ldd X, $strlen
jmp
popw r2
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r6 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokIdent]-  value(833) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a2 r2 r4 a0 r8  value(8) size (2)
pushw a2
pushw r2
pushw r4
pushw a0
 ; pushed 4 args
ldd X, $fwrite
jmp
popw r0
SP+=2
SP+=2
SP+=2
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L33:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb puts : (
 ; prm     s : * char
 ;     ) int
.section text
puts:
.export puts
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     s : (@4) : * char
 ; return

.section rodata
L37:
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( stdout , ( s strlen ) , 1 , s fwrite ) ( stdout , 1 , 1 , L37 fwrite ) + "
 ; Expanded expression: " stdout *(2)   (@4) *(2)  strlen ()2  1  (@4) *(2)  fwrite ()8  stdout *(2)  1  1  L37  fwrite ()8 + "
 ; Expression stack:    "( stdout *(2) , ( (@4) *(2) , strlen )2 , 1 , (@4) *(2) , fwrite )8 ( stdout *(2) , 1 , 1 , L37 , fwrite )8 + return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 041<tokCall> "8" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 016<tokIdent> "784" size(0) REG: z0  *
 ;  -  -  - 041<tokCall> "2" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  -  - 016<tokIdent> "566" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "833" size(0) REG: z0  *
 ;  -  - 041<tokCall> "8" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 016<tokIdent> "784" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "864" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "833" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  - 041<tokCall> "8" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: r0  
 ;  -  -  -  - 016<tokIdent> "784" size(2) REG: r0 SUPPRESSED *
 ;  -  -  - 041<tokCall> "2" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 016<tokIdent> "566" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r4  *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r6 SUPPRESSED *
 ;  -  -  - 016<tokIdent> "833" size(2) REG: r8 SUPPRESSED *
 ;  -  - 041<tokCall> "8" size(2) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: r2  
 ;  -  -  -  - 016<tokIdent> "784" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r4  *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *
 ;  -  -  - 016<tokIdent> "864" size(2) REG: r8  *
 ;  -  -  - 016<tokIdent> "833" size(2) REG: r10 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(784) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokUnaryStar]- r0  value(2) size (2)
ldd X, $stdout
mov A, [X]
mov r0, A
 ; emit_inc_x()
X++
mov A, [X]
mov r1, A
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(566) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- a0 r4  value(2) size (2)
pushw a0
 ; pushed 1 args
ldd X, $strlen
jmp
popw r2
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r6 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokIdent]-  value(833) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2 r4 a0 r8  value(8) size (2)
pushw r0
pushw r2
pushw r4
pushw a0
 ; pushed 4 args
ldd X, $fwrite
jmp
popw r0
SP+=2
SP+=2
SP+=2
 ; r2 <-[tokIdent]-  value(784) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryStar]- r2  value(2) size (2)
ldd X, $stdout
mov A, [X]
mov r2, A
 ; emit_inc_x()
X++
mov A, [X]
mov r3, A
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r8 <-[tokIdent]-  value(864) size (2)
ld r8, $(l)L37
ld r9, $(h)L37
 ; r10 <-[tokIdent]-  value(833) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- r2 r4 r6 r8 r10  value(8) size (2)
pushw r2
pushw r4
pushw r6
pushw r8
 ; pushed 4 args
ldd X, $fwrite
jmp
popw r2
SP+=2
SP+=2
SP+=2
 ; r0 <-[tokAdd]- r0 r2  value(0) size (2)
tadd r0, r0, r2
tadc r1, r1, r3
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L35:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb fputc : (
 ; prm     c : int
 ; prm     f : * struct File
 ;     ) int
.section text
fputc:
.export fputc
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     c : (@4) : int
 ; loc     f : (@6) : * struct File
 ; loc     ch : (@-2) : unsigned char
 ; RPN'ized expression: "ch c = "
 ; Expanded expression: "(@-2) (@4) *(2) =(1) "
 ; Expression stack:    "(@-2) (@4) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a0  value(2) size (2)
mov l-2, a0
 ; load to retval
mov r0, A
mov l-1, a1
 ; load to retval
mov r1, A



 ; return
 ; RPN'ized expression: "( f , 1 , 1 , ch &u fwrite ) 1 == 1 -u ch ? "
 ; Expanded expression: " (@6) *(2)  1  1  (@-2)  fwrite ()8 1 == [sh||->40] -1 goto &&[40] (@-2) *(1) &&[41] "
 ; Expression stack:    "( (@6) *(2) , 1 , 1 , (@-2) , fwrite )8 1 == [sh||->40] -1 [goto->41] &&[40] (@-2) *(1) &&[41] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 006<tokLogAnd> "41" size(0) REG: z0  
 ;  -  - 006<tokLogAnd> "40" size(0) REG: z0  
 ;  -  -  - 090<tokShortCirc> "-40" size(0) REG: z0  
 ;  -  -  -  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  -  -  -  - 041<tokCall> "8" size(0) REG: z0  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  -  -  -  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ;  -  -  -  -  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ;  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  -  -  -  - 016<tokIdent> "833" size(0) REG: z0  *
 ;  -  -  -  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ;  -  -  - 021<tokGoto> "41" size(0) REG: z0  
 ;  -  -  -  - 001<tokNumInt> "-1" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 006<tokLogAnd> "41" size(2) REG: r0  
 ;  -  - 006<tokLogAnd> "40" size(2) REG: r0  
 ;  -  -  - 090<tokShortCirc> "-40" size(2) REG: r0  
 ;  -  -  -  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  -  -  -  - 041<tokCall> "8" size(2) REG: r2  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  -  - 001<tokNumInt> "1" size(2) REG: r4  *
 ;  -  -  -  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *
 ;  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r8  *
 ;  -  -  -  -  -  - 016<tokIdent> "833" size(2) REG: r10 SUPPRESSED *
 ;  -  -  -  -  - 001<tokNumInt> "1" size(2) REG: r4  *
 ;  -  -  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  -  -  - 021<tokGoto> "41" size(0) REG: r0  
 ;  -  -  -  -  - 001<tokNumInt> "-1" size(0) REG: r0  *
 ;  -  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "1" size(1) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *

 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r8 <-[tokLocalOfs]-  value(-2) size (2)
 ; localOfs: -2, fix for [m+off] to -17
ld A, 17
mov B,A
mov A,ML
sub
mov r8,A
ld A, 0
mov B,A
mov A,MH
sbc
mov r9,A
 ; r10 <-[tokIdent]-  value(833) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- a2 r4 r6 r8 r10  value(8) size (2)
pushw a2
pushw r4
pushw r6
pushw r8
 ; pushed 4 args
ldd X, $fwrite
jmp
popw r2
SP+=2
SP+=2
SP+=2
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r0 <-[tokEQ]- r2 r4  value(0) size (2)
ldd X, $L42
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L42:
 ; r0 <-[tokShortCirc]- r0  value(-40) size (2)
 ; tokShortCirc
 ; Jump if not zero to L40
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L40
jnz
 ; r0 <-[tokNumInt]-  value(-1) size (0)


 ; Syntax/declaration table/stack:
 ; Bytes used: 4115/15360


 ; Macro table:
 ; Macro __SMALLER_C__ = `0x0100`
 ; Macro __SMALLER_C_16__ = ``
 ; Macro __SMALLER_C_SCHAR__ = ``
 ; Macro __SMALLER_C_UWCHAR__ = ``
 ; Macro __SMALLER_C_WCHAR16__ = ``
 ; Bytes used: 110/5120


 ; Identifier table:
 ; Ident 
 ; Ident uint16_t
 ; Ident int16_t
 ; Ident uint8_t
 ; Ident int8_t
 ; Ident intmax_t
 ; Ident uintmax_t
 ; Ident size_t
 ; Ident off_t
 ; Ident blk_t
 ; Ident pid_t
 ; Ident imaxabs
 ; Ident __n
 ; Ident strtoimax
 ; Ident <something>
 ; Ident strtoumax
 ; Ident strntoimax
 ; Ident strntoumax
 ; Ident abs
 ; Ident atoi
 ; Ident free
 ; Ident malloc
 ; Ident calloc
 ; Ident realloc
 ; Ident add_malloc_block
 ; Ident get_malloc_memory_status
 ; Ident malloc_lock_t
 ; Ident malloc_unlock_t
 ; Ident set_malloc_locking
 ; Ident __comparefunc_t
 ; Ident bsearch
 ; Ident qsort
 ; Ident seed48
 ; Ident rand
 ; Ident srand
 ; Ident __s
 ; Ident srandom
 ; Ident va_list
 ; Ident memccpy
 ; Ident memchr
 ; Ident memrchr
 ; Ident memcmp
 ; Ident memcpy
 ; Ident memmove
 ; Ident memset
 ; Ident memmem
 ; Ident memswap
 ; Ident bzero
 ; Ident strcasecmp
 ; Ident strncasecmp
 ; Ident strcat
 ; Ident strchr
 ; Ident index
 ; Ident strrchr
 ; Ident rindex
 ; Ident strcmp
 ; Ident strcpy
 ; Ident strcspn
 ; Ident strdup
 ; Ident strndup
 ; Ident strlen
 ; Ident strnlen
 ; Ident strncat
 ; Ident strlcat
 ; Ident strncmp
 ; Ident strncpy
 ; Ident strlcpy
 ; Ident strpbrk
 ; Ident strsep
 ; Ident strspn
 ; Ident strstr
 ; Ident strtok
 ; Ident strtok_r
 ; Ident strcoll
 ; Ident s1
 ; Ident s2
 ; Ident strxfrm
 ; Ident dest
 ; Ident src
 ; Ident n
 ; Ident File
 ; Ident FILE
 ; Ident File_methods
 ; Ident write
 ; Ident instance
 ; Ident bp
 ; Ident read
 ; Ident vmt
 ; Ident stdin
 ; Ident stdout
 ; Ident stderr
 ; Ident fread
 ; Ident buf
 ; Ident size
 ; Ident nmemb
 ; Ident stream
 ; Ident fwrite
 ; Ident fputs
 ; Ident s
 ; Ident f
 ; Ident puts
 ; Ident fputc
 ; Ident c
 ; Ident 39
 ; Ident ch
 ; Bytes used: 878/5632

 ; Compilation failed.
