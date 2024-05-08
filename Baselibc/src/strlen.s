
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
 ;  -  - 016<tokIdent> "249" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "4" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 016<tokIdent> "249" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(249) size (2)
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



L1:
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
 ;  - 016<tokIdent> "335" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "6" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "335" size(2) REG: r6 SUPPRESSED *

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
 ; r6 <-[tokIdent]-  value(335) size (2)
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
 ;  -  - 016<tokIdent> "291" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "2" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 016<tokIdent> "291" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(291) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a2 r2  value(2) size (2)
pushw a2
 ; pushed 1 args
ldd X, $strlen
jmp
popw r0
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L3:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb strlen : (
 ; prm     s : * char
 ;     ) unsigned
.section text
strlen:
.export strlen
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     s : (@4) : * char
 ; loc     ss : (@-2) : * char
 ; RPN'ized expression: "ss s = "
 ; Expanded expression: "(@-2) (@4) *(2) =(2) "
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



 ; while
 ; RPN'ized expression: "ss *u "
 ; Expanded expression: "(@-2) *(2) *(-1) "
L7:
 ; Expression stack:    "(@-2) *(2) *(-1) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokUnaryStar]- l-2  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-2
mov A, [X]
mov r0, A
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L8
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L8
jz
 ; RPN'ized expression: "ss ++p "
 ; Expanded expression: "(@-2) ++p(2) "
 ; Expression stack:    "(@-2) ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokAdd]- l-2 r4  value(2) size (2)
tadd r2, l-2, r4
tadc r3, l-1, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; Unconditional jump to L7
ldd X, $L7
jmp
L8:
 ; return
 ; RPN'ized expression: "ss s - "
 ; Expanded expression: "(@-2) *(2) (@4) *(2) - "
 ; Expression stack:    "(@-2) *(2) (@4) *(2) - return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 045<tokSub> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokSub]- l-2 a0  value(0) size (2)
tsub r0, l-2, a0
tsbc r1, l-1, a1
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L5:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 


 ; Syntax/declaration table/stack:
 ; Bytes used: 2275/15360


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
 ; Ident memccpy
 ; Ident <something>
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
 ; Ident s
 ; Bytes used: 447/5632

 ; Next label number: 9
 ; Compilation succeeded.
