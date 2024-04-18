
 ; glb puts : (
 ; prm     s : * char
 ;     ) void
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
 ; while
 ; RPN'ized expression: "s *u "
 ; Expanded expression: "(@4) *(2) *(-1) "
L3:
 ; Expression stack:    "(@4) *(2) *(-1) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokUnaryStar]- a0  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, a0
mov A, [X]
mov r0, A
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L4
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L4
jz
 ; {
 ; loc         <something> : * unsigned char
 ; RPN'ized expression: "18435 (something5) *u s *u = "
 ; Expanded expression: "18435 (@4) *(2) *(-1) =(1) "
 ; Expression stack:    "18435 (@4) *(2) *(-1) =(1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "1" size(0) REG: z0  
 ;  - 001<tokNumInt> "18435" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "1" size(1) REG: r0  
 ;  - 001<tokNumInt> "18435" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(18435) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryStar]- a0  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, a0
mov A, [X]
mov r2, A
 ; r0 <-[tokAssign]- r0 r2  value(1) size (1)
ldd X, 0x4803
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "s ++p "
 ; Expanded expression: "(@4) ++p(2) "
 ; Expression stack:    "(@4) ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokAdd]- a0 r4  value(2) size (2)
tadd r2, a0, r4
tadc r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a0, r2
 ; load to retval
mov r0, A
mov a1, r3
 ; load to retval
mov r1, A



 ; }
 ; Unconditional jump to L3
ldd X, $L3
jmp
L4:
L1:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb putc : (
 ; prm     c : char
 ;     ) int
.section text
putc:
.export putc
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     c : (@4) : char
 ; loc     <something> : * unsigned char
 ; RPN'ized expression: "18435 (something8) *u c = "
 ; Expanded expression: "18435 (@4) *(-1) =(1) "
 ; Expression stack:    "18435 (@4) *(-1) =(1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "1" size(0) REG: z0  
 ;  - 001<tokNumInt> "18435" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "1" size(1) REG: r0  
 ;  - 001<tokNumInt> "18435" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(18435) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a0  value(1) size (1)
ldd X, 0x4803
mov A, a0
mov [X], A
 ; load to retval
mov r0, A



L6:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb getc : () char
.section text
getc:
.export getc
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     c : (@-2) : char
 ; loc     <something> : * unsigned char
 ; RPN'ized expression: "c 18435 (something11) *u = "
 ; Expanded expression: "(@-2) 18435 *(1) =(-1) "
 ; Expression stack:    "(@-2) 18435 *(1) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "1" size(0) REG: z0  
 ;  -  - 001<tokNumInt> "18435" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 019<tokInt> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "1" size(1) REG: r2  
 ;  -  -  - 001<tokNumInt> "18435" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(18435) size (2)
 ; possible optimization - pass size
ld r2, 3
ld r3, 72
 ; r2 <-[tokUnaryStar]- r2  value(1) size (1)
 ; deref from non-ident non-local tok : tokNumInt suppress 0
movw X, r2
mov A, [X]
mov r2, A
 ; r2 <-[tokInt]- r2  value(0) size (2)
ld A, 0x00
mov r3, A
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "c 255 == "
 ; Expanded expression: "(@-2) *(-1) 255 == "
 ; Expression stack:    "(@-2) *(-1) 255 == IF![12] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "12" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "255" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "12" size(-1) REG: r0  
 ;  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "255" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(255) size (-1)
 ; possible optimization - pass size
ld r4, 255
 ; r0 <-[tokEQ]- l-2 r4  value(0) size (-1)
ldd X, $L14
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L14:
 ; r0 <-[tokIfNot]- r0  value(12) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L12
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L12
jz



 ; RPN'ized expression: "c 0 = "
 ; Expanded expression: "(@-2) 0 =(-1) "
 ; Expression stack:    "(@-2) 0 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r2, 0
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-2, r2
 ; load to retval
mov r0, A



L12:
 ; return
 ; RPN'ized expression: "c "
 ; Expanded expression: "(@-2) *(-1) "
 ; Expression stack:    "(@-2) *(-1) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokInt]- l-2  value(0) size (2)
mov r0, l-2
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L9:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb isdigit : (
 ; prm     c : char
 ;     ) int
.section text
isdigit:
.export isdigit
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

 ; loc     c : (@4) : char
 ; return
 ; RPN'ized expression: "c 48 >= c 57 <= && "
 ; Expanded expression: "(@4) *(-1) 48 >= [sh&&->17] (@4) *(-1) 57 <= &&[17] "
 ; Expression stack:    "(@4) *(-1) 48 >= [sh&&->17] (@4) *(-1) 57 <= &&[17] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 006<tokLogAnd> "17" size(0) REG: z0  
 ;  -  - 090<tokShortCirc> "17" size(0) REG: z0  
 ;  -  -  - 011<tokGEQ> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ;  -  - 010<tokLEQ> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "57" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 006<tokLogAnd> "17" size(-1) REG: r0  
 ;  -  -  - 090<tokShortCirc> "17" size(-1) REG: r0  
 ;  -  -  -  - 011<tokGEQ> "0" size(-1) REG: r0  
 ;  -  -  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: a0 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  - 001<tokNumInt> "48" size(-1) REG: r4  *
 ;  -  -  - 010<tokLEQ> "0" size(-1) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "57" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r4, 48
 ; r0 <-[tokGEQ]- a0 r4  value(0) size (-1)
ldd X, $L18
tsub r0, a0, r4
ld r0, 0
jl
ld r0, 1
; --- end of comparison:
L18:
 ; r0 <-[tokShortCirc]- r0  value(17) size (-1)
 ; tokShortCirc
 ; Jump if zero to L17
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L17
jz
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(57) size (-1)
 ; possible optimization - pass size
ld r4, 57
 ; r0 <-[tokLEQ]- a0 r4  value(0) size (-1)
ldd X, $L19
tsub r0, a0, r4
ld r0, 0
jg
ld r0, 1
; --- end of comparison:
L19:
 ; r0 <-[tokLogAnd]- r0 r0  value(17) size (-1)
 ; tokLogAndOr
L17:
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L15:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb atoi : (
 ; prm     s : * char
 ;     ) int
.section text
atoi:
.export atoi
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     s : (@4) : * char
 ; loc     res : (@-2) : int
 ; RPN'ized expression: "res 0 = "
 ; Expanded expression: "(@-2) 0 =(2) "
 ; Expression stack:    "(@-2) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; while
 ; RPN'ized expression: "( s *u isdigit ) "
 ; Expanded expression: " (@4) *(2) *(-1)  isdigit ()2 "
L22:
 ; Expression stack:    "( (@4) *(2) *(-1) , isdigit )2 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 041<tokCall> "2" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "26" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "2" size(2) REG: r0  
 ;  -  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  -  - 016<tokIdent> "26" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokUnaryStar]- a0  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, a0
mov A, [X]
mov r0, A
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r2 <-[tokIdent]-  value(26) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $isdigit
jmp
popw r0
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L23
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L23
jz
 ; {
 ; RPN'ized expression: "res res 10 * = "
 ; Expanded expression: "(@-2) (@-2) *(2) 10 * =(2) "
 ; Expression stack:    "(@-2) (@-2) *(2) 10 * =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 041<tokCall> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "10" size(2) REG: r4  *
 ;  -  - 019<tokInt> "0" size(2) REG: r6  
 ;  -  -  - 016<tokIdent> "50" size(0) REG: r6 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r6 <-[tokIdent]-  value(50) size (0)
 ; !!! emit suppressed
 ; r6 <-[tokInt]- r6  value(0) size (2)
ld A, 0x00
mov r7, A
 ; r2 <-[tokCall]- l-2 r4 r6  value(0) size (2)
pushw l-2
pushw r4
 ; pushed 2 args
 ; Call not by tokIdent - load address
movw X, r6
jmp
popw r2
SP+=2
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "res s *u 48 - += "
 ; Expanded expression: "(@-2) (@4) *(2) *(-1) 48 - +=(2) "
 ; Expression stack:    "(@-2) (@4) *(2) *(-1) 48 - +=(2) "
 ; Expr tree before optim: 
 ; 068<tokAssignAdd> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 068<tokAssignAdd> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ;  - 045<tokSub> "0" size(-1) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(-1) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ;  -  - 045<tokSub> "0" size(-1) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  -  -  - 001<tokNumInt> "48" size(-1) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 019<tokInt> "0" size(2) REG: r4  
 ;  -  -  - 045<tokSub> "0" size(-1) REG: r4  
 ;  -  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: r4  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r4 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "48" size(-1) REG: r6  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokUnaryStar]- a0  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, a0
mov A, [X]
mov r4, A
 ; r6 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r6, 48
 ; r4 <-[tokSub]- r4 r6  value(0) size (-1)
tsub r4, r4, r6
 ; r4 <-[tokInt]- r4  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r5, A
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



 ; RPN'ized expression: "s ++p "
 ; Expanded expression: "(@4) ++p(2) "
 ; Expression stack:    "(@4) ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokAdd]- a0 r4  value(2) size (2)
tadd r2, a0, r4
tadc r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a0, r2
 ; load to retval
mov r0, A
mov a1, r3
 ; load to retval
mov r1, A



 ; }
 ; Unconditional jump to L22
ldd X, $L22
jmp
L23:
 ; return
 ; RPN'ized expression: "res "
 ; Expanded expression: "(@-2) *(2) "
 ; Expression stack:    "(@-2) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- l-2  value(0) size (2)
mov r0, l-2
mov r1, l-1
 ; tokReturn



L20:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb strcmp : (
 ; prm     s1 : * char
 ; prm     s2 : * char
 ;     ) int
.section text
strcmp:
.export strcmp
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     s1 : (@4) : * char
 ; loc     s2 : (@6) : * char
 ; loc     c1 : (@-2) : * unsigned char
 ; loc     <something> : * unsigned char
 ; RPN'ized expression: "c1 s1 (something26) = "
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



 ; loc     c2 : (@-4) : * unsigned char
 ; loc     <something> : * unsigned char
 ; RPN'ized expression: "c2 s2 (something27) = "
 ; Expanded expression: "(@-4) (@6) *(2) =(2) "
 ; Expression stack:    "(@-4) (@6) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a2  value(2) size (2)
mov l-4, a2
 ; load to retval
mov r0, A
mov l-3, a3
 ; load to retval
mov r1, A



 ; loc     ch : (@-6) : unsigned char
 ; loc     d : (@-8) : int
 ; RPN'ized expression: "d 0 = "
 ; Expanded expression: "(@-8) 0 =(2) "
 ; Expression stack:    "(@-8) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-8" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-8" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-8) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-8, r2
 ; load to retval
mov r0, A
mov l-7, r3
 ; load to retval
mov r1, A



 ; while
 ; RPN'ized expression: "1 "
 ; Expanded expression: "1 "
 ; Expression value: 1
L28:
 ; {
 ; loc         <something> : int
 ; loc         <something> : int
 ; RPN'ized expression: "d ch c1 ++p *u = (something30) c2 ++p *u (something31) - = "
 ; Expanded expression: "(@-8) (@-6) (@-2) ++p(2) *(1) =(1) (@-4) ++p(2) *(1) - =(2) "
 ; Expression stack:    "(@-8) (@-6) (@-2) ++p(2) *(1) =(1) (@-4) ++p(2) *(1) - =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-8" size(0) REG: z0  *
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 061<tokAssign> "1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "1" size(0) REG: z0  
 ;  -  -  -  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "1" size(0) REG: z0  
 ;  -  -  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 061<tokAssign> "2" size(2) REG: r0  
 ;  -  - 089<tokLocalOfs> "-8" size(2) REG: r0 SUPPRESSED *
 ;  -  - 019<tokInt> "0" size(2) REG: r2  
 ;  -  -  - 045<tokSub> "0" size(1) REG: r2  
 ;  -  -  -  - 061<tokAssign> "1" size(1) REG: r2  
 ;  -  -  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  - 078<tokUnaryStar> "1" size(1) REG: r4  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  -  - 078<tokUnaryStar> "1" size(1) REG: r4  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *
 ;  - 061<tokAssign> "2" size(2) REG: r4  
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r6  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r6 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r8  *

 ; r0 <-[tokLocalOfs]-  value(-8) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokUnaryStar]- l-2  value(1) size (1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-2
mov A, [X]
mov r4, A
 ; r2 <-[tokAssign]- r2 r4  value(1) size (1)
mov l-6, r4
 ; load to retval
mov r2, A
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokUnaryStar]- l-4  value(1) size (1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-4
mov A, [X]
mov r4, A
 ; r2 <-[tokSub]- r2 r4  value(0) size (1)
tsub r2, r2, r4
 ; r2 <-[tokInt]- r2  value(0) size (2)
ld A, 0x00
mov r3, A
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-8, r2
 ; load to retval
mov r0, A
mov l-7, r3
 ; load to retval
mov r1, A
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokAdd]- l-2 r6  value(2) size (2)
tadd r4, l-2, r6
tadc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r8, 1
ld r9, 0
 ; r6 <-[tokAdd]- l-4 r8  value(2) size (2)
tadd r6, l-4, r8
tadc r7, l-3, r9
 ; r4 <-[tokAssign]- r4 r6  value(2) size (2)
mov l-4, r6
 ; load to retval
mov r4, A
mov l-3, r7
 ; load to retval
mov r5, A
 ; r0 <-[tokSequential]- r0 r2 r4  value(0) size (0)
 ; tokSequential



 ; if
 ; RPN'ized expression: "d ch 0 == || "
 ; Expanded expression: "(@-8) *(2) _Bool [sh||->34] (@-6) *(1) 0 == ||[34] "
 ; Expression stack:    "(@-8) *(2) _Bool [sh||->34] (@-6) *(1) 0 == ||[34] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 007<tokLogOr> "34" size(0) REG: z0  
 ;  -  - 090<tokShortCirc> "-34" size(0) REG: z0  
 ;  -  -  - 120<tok_Bool> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-8" size(0) REG: z0  *
 ;  -  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 007<tokLogOr> "34" size(2) REG: r0  
 ;  -  - 090<tokShortCirc> "-34" size(2) REG: r0  
 ;  -  -  - 120<tok_Bool> "0" size(2) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-8 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-8" size(2) REG: r0 SUPPRESSED *
 ;  -  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  -  - 008<tokEQ> "0" size(1) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "1" size(1) REG: l-6 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "0" size(1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-8) size (2)
 ; !!! emit suppressed
 ; l-8 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tok_Bool]- l-8  value(0) size (2)
; maybe omit it all? Why convert to bool?
; XXX Optimize size!
tor r0, l-8, l-7
ld r1, 0
;;;;;; ; r0 <-[tokShortCirc]- r0  value(-34) size (2)
 ; tokShortCirc
 ; Jump if not zero to L34
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L34
jnz
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(1) size (1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (1)
 ; possible optimization - pass size
ld r4, 0
 ; r0 <-[tokEQ]- l-6 r4  value(0) size (1)
ldd X, $L35
tsub r0, l-6, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L35:
 ; r0 <-[tokInt]- r0  value(0) size (2)
ld A, 0x00
mov r1, A
 ; r0 <-[tokLogOr]- r0 r0  value(34) size (2)
 ; tokLogAndOr
L34:
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L32
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L32
jz
 ; break
 ; Unconditional jump to L29
ldd X, $L29
jmp
L32:
 ; }
 ; Unconditional jump to L28
ldd X, $L28
jmp
L29:
 ; return
 ; RPN'ized expression: "d "
 ; Expanded expression: "(@-8) *(2) "
 ; Expression stack:    "(@-8) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-8" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-8 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-8" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-8) size (2)
 ; !!! emit suppressed
 ; l-8 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- l-8  value(0) size (2)
mov r0, l-8
mov r1, l-7
 ; tokReturn



L24:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb strcpy : (
 ; prm     dst : * char
 ; prm     src : * char
 ;     ) * char
.section text
strcpy:
.export strcpy
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     dst : (@4) : * char
 ; loc     src : (@6) : * char
 ; loc     q : (@-2) : * char
 ; RPN'ized expression: "q dst = "
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



 ; loc     p : (@-4) : * char
 ; RPN'ized expression: "p src = "
 ; Expanded expression: "(@-4) (@6) *(2) =(2) "
 ; Expression stack:    "(@-4) (@6) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a2  value(2) size (2)
mov l-4, a2
 ; load to retval
mov r0, A
mov l-3, a3
 ; load to retval
mov r1, A



 ; loc     ch : (@-6) : char
 ; do
L38:
 ; {
 ; RPN'ized expression: "q ++p *u ch p ++p *u = = "
 ; Expanded expression: "(@-2) ++p(2) (@-6) (@-4) ++p(2) *(-1) =(-1) =(-1) "
 ; Expression stack:    "(@-2) ++p(2) (@-6) (@-4) ++p(2) *(-1) =(-1) =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 061<tokAssign> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 061<tokAssign> "-1" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  -  - 061<tokAssign> "-1" size(-1) REG: r2  
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: r4  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *
 ;  - 061<tokAssign> "2" size(2) REG: r4  
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r6  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r6 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r8  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokUnaryStar]- l-4  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-4
mov A, [X]
mov r4, A
 ; r2 <-[tokAssign]- r2 r4  value(-1) size (-1)
mov l-6, r4
 ; load to retval
mov r2, A
 ; r0 <-[tokAssign]- l-2 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-2
mov A, r2
mov [X], A
 ; load to retval
mov r0, A
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokAdd]- l-2 r6  value(2) size (2)
tadd r4, l-2, r6
tadc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r8, 1
ld r9, 0
 ; r6 <-[tokAdd]- l-4 r8  value(2) size (2)
tadd r6, l-4, r8
tadc r7, l-3, r9
 ; r4 <-[tokAssign]- r4 r6  value(2) size (2)
mov l-4, r6
 ; load to retval
mov r4, A
mov l-3, r7
 ; load to retval
mov r5, A
 ; r0 <-[tokSequential]- r0 r2 r4  value(0) size (0)
 ; tokSequential



 ; }
 ; while
 ; RPN'ized expression: "ch "
 ; Expanded expression: "(@-6) *(-1) "
L39:
 ; Expression stack:    "(@-6) *(-1) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokInt]- l-6  value(0) size (2)
mov r0, l-6
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if not zero to L38
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L38
jnz
L40:
 ; return
 ; RPN'ized expression: "dst "
 ; Expanded expression: "(@4) *(2) "
 ; Expression stack:    "(@4) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- a0  value(0) size (2)
mov r0, a0
mov r1, a1
 ; tokReturn



L36:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb strlen : (
 ; prm     s : * void
 ;     ) int
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

 ; loc     s : (@4) : * void
 ; loc     p : (@-2) : * char
 ; loc     <something> : * char
 ; RPN'ized expression: "p s (something43) = "
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



 ; loc     n : (@-4) : int
 ; RPN'ized expression: "n 0 = "
 ; Expanded expression: "(@-4) 0 =(2) "
 ; Expression stack:    "(@-4) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; while
 ; RPN'ized expression: "p *u "
 ; Expanded expression: "(@-2) *(2) *(-1) "
L44:
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



 ; Jump if zero to L45
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L45
jz
 ; {
 ; RPN'ized expression: "p ++p "
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



 ; RPN'ized expression: "n ++p "
 ; Expanded expression: "(@-4) ++p(2) "
 ; Expression stack:    "(@-4) ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokAdd]- l-4 r4  value(2) size (2)
tadd r2, l-4, r4
tadc r3, l-3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; }
 ; Unconditional jump to L44
ldd X, $L44
jmp
L45:
 ; return
 ; RPN'ized expression: "n "
 ; Expanded expression: "(@-4) *(2) "
 ; Expression stack:    "(@-4) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- l-4  value(0) size (2)
mov r0, l-4
mov r1, l-3
 ; tokReturn



L41:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb reverse : (
 ; prm     s : * char
 ;     ) void
.section text
reverse:
.export reverse
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     s : (@4) : * char
 ; loc     i : (@-2) : int
 ; loc     j : (@-4) : int
 ; loc     c : (@-6) : char
 ; for
 ; RPN'ized expression: "i 0 = j ( s strlen ) 1 - = ,b "
 ; Expanded expression: "(@-2) 0 =(2) void (@-4)  (@4) *(2)  strlen ()2 1 - =(2) ,b "
 ; Expression stack:    "(@-2) 0 =(2) void (@-4) ( (@4) *(2) , strlen )2 1 - =(2) ,b "
 ; Expr tree before optim: 
 ; 048<tokComma> "0" size(0) REG: z0  
 ;  - 017<tokVoid> "0" size(0) REG: z0  
 ;  -  - 061<tokAssign> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  - 061<tokAssign> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  -  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  -  - 041<tokCall> "2" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  -  - 016<tokIdent> "75" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ; Expr tree: 
 ; 048<tokComma> "0" size(2) REG: r0  
 ;  - 017<tokVoid> "0" size(2) REG: r0  
 ;  -  - 061<tokAssign> "2" size(2) REG: r0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "0" size(2) REG: r2  *
 ;  - 061<tokAssign> "2" size(2) REG: r0  
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  -  - 045<tokSub> "0" size(2) REG: r2  
 ;  -  -  - 041<tokCall> "2" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 016<tokIdent> "75" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A
 ; r0 <-[tokVoid]- r0  value(0) size (2)
 ; tokVoid
 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(75) size (2)
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
 ; r2 <-[tokSub]- r2 r4  value(0) size (2)
tsub r2, r2, r4
tsbc r3, r3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A
 ; r0 <-[tokComma]- r0 r0  value(0) size (2)
 ; tokComma



L48:
 ; RPN'ized expression: "i j < "
 ; Expanded expression: "(@-2) *(2) (@-4) *(2) < "
 ; Expression stack:    "(@-2) *(2) (@-4) *(2) < IF![51] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "51" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "51" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokLess]- l-2 l-4  value(0) size (2)
ldd X, $L52
tsub r0, l-2, l-4
tsbc r1, l-1, l-3
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L52:
 ; r0 <-[tokIfNot]- r0  value(51) size (2)
 ; Jump if zero to L51
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L51
jz



 ; RPN'ized expression: "i ++p j --p ,b "
 ; Expanded expression: "(@-2) ++p(2) void (@-4) --p(2) ,b "
 ; {
 ; RPN'ized expression: "c s i + *u = "
 ; Expanded expression: "(@-6) (@4) *(2) (@-2) *(2) + *(-1) =(-1) "
 ; Expression stack:    "(@-6) (@4) *(2) (@-2) *(2) + *(-1) =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: r2  
 ;  -  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokAdd]- a0 l-2  value(0) size (2)
tadd r2, a0, l-2
tadc r3, a1, l-1
 ; r2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r2
mov A, [X]
mov r2, A
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-6, r2
 ; load to retval
mov r0, A



 ; RPN'ized expression: "s i + *u s j + *u = "
 ; Expanded expression: "(@4) *(2) (@-2) *(2) + (@4) *(2) (@-4) *(2) + *(-1) =(-1) "
 ; Expression stack:    "(@4) *(2) (@-2) *(2) + (@4) *(2) (@-4) *(2) + *(-1) =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: r2  
 ;  -  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAdd]- a0 l-2  value(0) size (2)
tadd r0, a0, l-2
tadc r1, a1, l-1
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokAdd]- a0 l-4  value(0) size (2)
tadd r2, a0, l-4
tadc r3, a1, l-3
 ; r2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r2
mov A, [X]
mov r2, A
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, r0
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "s j + *u c = "
 ; Expanded expression: "(@4) *(2) (@-4) *(2) + (@-6) *(-1) =(-1) "
 ; Expression stack:    "(@4) *(2) (@-4) *(2) + (@-6) *(-1) =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: l-6 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAdd]- a0 l-4  value(0) size (2)
tadd r0, a0, l-4
tadc r1, a1, l-3
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 l-6  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, r0
mov A, l-6
mov [X], A
 ; load to retval
mov r0, A



 ; }
L49:
 ; Expression stack:    "(@-2) ++p(2) void (@-4) --p(2) ,b "
 ; Expr tree before optim: 
 ; 048<tokComma> "0" size(0) REG: z0  
 ;  - 017<tokVoid> "0" size(0) REG: z0  
 ;  -  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 082<tokPostDec> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 048<tokComma> "0" size(2) REG: r0  
 ;  -  - 017<tokVoid> "0" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *
 ;  - 061<tokAssign> "2" size(2) REG: r4  
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *
 ;  -  - 045<tokSub> "2" size(2) REG: r6  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r6 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r8  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokVoid]- l-2  value(0) size (2)
 ; tokVoid
 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokComma]- r0 l-4  value(0) size (2)
 ; tokComma
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokAdd]- l-2 r6  value(2) size (2)
tadd r4, l-2, r6
tadc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r8, 1
ld r9, 0
 ; r6 <-[tokSub]- l-4 r8  value(2) size (2)
tsub r6, l-4, r8
tsbc r7, l-3, r9
 ; r4 <-[tokAssign]- r4 r6  value(2) size (2)
mov l-4, r6
 ; load to retval
mov r4, A
mov l-3, r7
 ; load to retval
mov r5, A
 ; r0 <-[tokSequential]- r0 r2 r4  value(0) size (0)
 ; tokSequential



 ; Unconditional jump to L48
ldd X, $L48
jmp
L51:
L46:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb itoa : (
 ; prm     n : int
 ; prm     s : * char
 ;     ) void
.section text
itoa:
.export itoa
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     n : (@4) : int
 ; loc     s : (@6) : * char
 ; loc     i : (@-2) : int
 ; loc     sign : (@-4) : int
 ; RPN'ized expression: "sign 0 = "
 ; Expanded expression: "(@-4) 0 =(2) "
 ; Expression stack:    "(@-4) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "n 0 < "
 ; Expanded expression: "(@4) *(2) 0 < "
 ; Expression stack:    "(@4) *(2) 0 < IF![55] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "55" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "55" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokLess]- a0 r4  value(0) size (2)
ldd X, $L57
tsub r0, a0, r4
tsbc r1, a1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L57:
 ; r0 <-[tokIfNot]- r0  value(55) size (2)
 ; Jump if zero to L55
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L55
jz



 ; {
 ; RPN'ized expression: "s 0 + *u 45 = "
 ; Expanded expression: "(@6) *(2) 0 + 45 =(-1) "
 ; Expression stack:    "(@6) *(2) 0 + 45 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ;  - 001<tokNumInt> "45" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r2  *
 ;  - 001<tokNumInt> "45" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAdd]- a2 r2  value(0) size (2)
tadd r0, a2, r2
tadc r1, a3, r3
 ; r2 <-[tokNumInt]-  value(45) size (-1)
 ; possible optimization - pass size
ld r2, 45
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, r0
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "( s 1 + , n -u itoa ) "
 ; Expanded expression: " (@6) *(2) 1 +  (@4) *(2) -u  itoa ()4 "
 ; Expression stack:    "( (@6) *(2) 1 + , (@4) *(2) -u , itoa )4 "
 ; Expr tree before optim: 
 ; 041<tokCall> "4" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ;  - 080<tokUnaryMinus> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 016<tokIdent> "92" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "4" size(2) REG: r0  
 ;  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r2  *
 ;  - 080<tokUnaryMinus> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  - 016<tokIdent> "92" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; r0 <-[tokAdd]- a2 r2  value(0) size (2)
tadd r0, a2, r2
tadc r1, a3, r3
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryMinus]- a0  value(0) size (2)
 ;; optimize this
mov A, a0
not
inc
mov r2, A
ld A,0
mov B,A
mov A, a1
adc
mov r3, A
 ; r4 <-[tokIdent]-  value(92) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2 r4  value(4) size (2)
pushw r0
pushw r2
 ; pushed 2 args
ldd X, $itoa
jmp
popw r0
SP+=2



 ; return
 ; Unconditional jump to L53
ldd X, $L53
jmp
 ; }
L55:
 ; RPN'ized expression: "i 0 = "
 ; Expanded expression: "(@-2) 0 =(2) "
 ; Expression stack:    "(@-2) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; do
L58:
 ; {
 ; RPN'ized expression: "s i ++p + *u n 10 % 48 + = "
 ; Expanded expression: "(@6) *(2) (@-2) ++p(2) + (@4) *(2) 10 % 48 + =(-1) "
 ; Expression stack:    "(@6) *(2) (@-2) ++p(2) + (@4) *(2) 10 % 48 + =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 037<tokMod> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 061<tokAssign> "-1" size(-1) REG: r0  
 ;  -  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  -  - 041<tokCall> "0" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "10" size(2) REG: r4  *
 ;  -  -  -  - 019<tokInt> "0" size(2) REG: r6  
 ;  -  -  -  -  - 016<tokIdent> "114" size(0) REG: r6 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "48" size(2) REG: r4  *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAdd]- a2 l-2  value(0) size (2)
tadd r0, a2, l-2
tadc r1, a3, l-1
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r6 <-[tokIdent]-  value(114) size (0)
 ; !!! emit suppressed
 ; r6 <-[tokInt]- r6  value(0) size (2)
ld A, 0x00
mov r7, A
 ; r2 <-[tokCall]- a0 r4 r6  value(0) size (2)
pushw a0
pushw r4
 ; pushed 2 args
 ; Call not by tokIdent - load address
movw X, r6
jmp
popw r2
SP+=2
 ; r4 <-[tokNumInt]-  value(48) size (2)
 ; possible optimization - pass size
ld r4, 48
ld r5, 0
 ; r2 <-[tokAdd]- r2 r4  value(0) size (2)
tadd r2, r2, r4
tadc r3, r3, r5
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, r0
mov A, r2
mov [X], A
 ; load to retval
mov r0, A
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokAdd]- l-2 r6  value(2) size (2)
tadd r4, l-2, r6
tadc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r0 <-[tokSequential]- r0 r2  value(0) size (0)
 ; tokSequential



 ; }
 ; while
 ; RPN'ized expression: "n 10 /= 0 > "
 ; Expanded expression: "(@4) 10 /=(2) 0 > "
L59:
 ; Expression stack:    "(@4) 10 /=(2) 0 > IF[58] "
 ; Expr tree before optim: 
 ; 022<tokIf> "58" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 066<tokAssignDiv> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 066<tokAssignDiv> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 001<tokNumInt> "10" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 047<tokDiv> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(2) REG: z0  *
 ; Expr tree: 
 ; 022<tokIf> "58" size(2) REG: r0  
 ;  - 062<tokMore> "0" size(2) REG: r0  
 ;  -  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 041<tokCall> "2" size(2) REG: r4  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r4 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "10" size(2) REG: r6  *
 ;  -  -  -  - 019<tokInt> "0" size(2) REG: r8  
 ;  -  -  -  -  - 016<tokIdent> "114" size(0) REG: r8 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r6, 10
ld r7, 0
 ; r8 <-[tokIdent]-  value(114) size (0)
 ; !!! emit suppressed
 ; r8 <-[tokInt]- r8  value(0) size (2)
ld A, 0x00
mov r9, A
 ; r4 <-[tokCall]- a0 r6 r8  value(2) size (2)
pushw a0
pushw r6
 ; pushed 2 args
 ; Call not by tokIdent - load address
movw X, r8
jmp
popw r4
SP+=2
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov a0, r4
 ; load to retval
mov r2, A
mov a1, r5
 ; load to retval
mov r3, A
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokMore]- r2 r4  value(0) size (2)
ldd X, $L61
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L61:
 ; r0 <-[tokIf]- r0  value(58) size (2)
 ; Jump if not zero to L58
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L58
jnz



L60:
 ; if
 ; RPN'ized expression: "sign 1 == "
 ; Expanded expression: "(@-4) *(2) 1 == "
 ; Expression stack:    "(@-4) *(2) 1 == IF![62] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "62" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "62" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r0 <-[tokEQ]- l-4 r4  value(0) size (2)
ldd X, $L64
tsub r0, l-4, r4
tsbc r1, l-3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L64:
 ; r0 <-[tokIfNot]- r0  value(62) size (2)
 ; Jump if zero to L62
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L62
jz



 ; {
 ; RPN'ized expression: "s i ++p + *u 45 = "
 ; Expanded expression: "(@6) *(2) (@-2) ++p(2) + 45 =(-1) "
 ; Expression stack:    "(@6) *(2) (@-2) ++p(2) + 45 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "45" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 061<tokAssign> "-1" size(-1) REG: r0  
 ;  -  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "45" size(-1) REG: r2  *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAdd]- a2 l-2  value(0) size (2)
tadd r0, a2, l-2
tadc r1, a3, l-1
 ; r2 <-[tokNumInt]-  value(45) size (-1)
 ; possible optimization - pass size
ld r2, 45
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, r0
mov A, r2
mov [X], A
 ; load to retval
mov r0, A
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokAdd]- l-2 r6  value(2) size (2)
tadd r4, l-2, r6
tadc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r0 <-[tokSequential]- r0 r2  value(0) size (0)
 ; tokSequential



 ; }
L62:
 ; RPN'ized expression: "s i + *u 0 = "
 ; Expanded expression: "(@6) *(2) (@-2) *(2) + 0 =(-1) "
 ; Expression stack:    "(@6) *(2) (@-2) *(2) + 0 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAdd]- a2 l-2  value(0) size (2)
tadd r0, a2, l-2
tadc r1, a3, l-1
 ; r2 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r2, 0
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, r0
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "( s reverse ) "
 ; Expanded expression: " (@6) *(2)  reverse ()2 "
 ; Expression stack:    "( (@6) *(2) , reverse )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  - 016<tokIdent> "83" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "83" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(83) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a2 r2  value(2) size (2)
pushw a2
 ; pushed 1 args
ldd X, $reverse
jmp
popw r0



L53:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb strncpy : (
 ; prm     d : * char
 ; prm     s : * char
 ; prm     l : unsigned
 ;     ) * char
.section text
strncpy:
.export strncpy
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     d : (@4) : * char
 ; loc     s : (@6) : * char
 ; loc     l : (@8) : unsigned
 ; loc     s1 : (@-2) : * char
 ; RPN'ized expression: "s1 d = "
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



 ; loc     s2 : (@-4) : * char
 ; RPN'ized expression: "s2 s = "
 ; Expanded expression: "(@-4) (@6) *(2) =(2) "
 ; Expression stack:    "(@-4) (@6) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a2  value(2) size (2)
mov l-4, a2
 ; load to retval
mov r0, A
mov l-3, a3
 ; load to retval
mov r1, A



 ; while
 ; RPN'ized expression: "l "
 ; Expanded expression: "(@8) *(2) "
L67:
 ; Expression stack:    "(@8) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- a4  value(0) size (2)
mov r0, a4
mov r1, a5
 ; tokReturn



 ; Jump if zero to L68
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L68
jz
 ; {
 ; RPN'ized expression: "l --p "
 ; Expanded expression: "(@8) --p(2) "
 ; Expression stack:    "(@8) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "8" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "8" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "8" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "8" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- a4 r4  value(2) size (2)
tsub r2, a4, r4
tsbc r3, a5, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a4, r2
 ; load to retval
mov r0, A
mov a5, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "s1 ++p *u s2 ++p *u = 0 == "
 ; Expanded expression: "(@-2) ++p(2) (@-4) ++p(2) *(-1) =(-1) 0 == "
 ; Expression stack:    "(@-2) ++p(2) (@-4) ++p(2) *(-1) =(-1) 0 == IF![69] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "69" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 061<tokAssign> "-1" size(0) REG: z0  
 ;  -  -  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 076<tokIfNot> "69" size(-1) REG: r0  
 ;  -  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  -  - 061<tokAssign> "-1" size(-1) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: r4  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "0" size(-1) REG: r4  *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *
 ;  - 061<tokAssign> "2" size(2) REG: r4  
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r6  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r6 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r8  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokUnaryStar]- l-4  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-4
mov A, [X]
mov r4, A
 ; r2 <-[tokAssign]- l-2 r4  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-2
mov A, r4
mov [X], A
 ; load to retval
mov r2, A
 ; r4 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r4, 0
 ; r0 <-[tokEQ]- r2 r4  value(0) size (-1)
ldd X, $L71
tsub r0, r2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L71:
 ; r0 <-[tokIfNot]- r0  value(69) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L69
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L69
jz
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokAdd]- l-2 r6  value(2) size (2)
tadd r4, l-2, r6
tadc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r8, 1
ld r9, 0
 ; r6 <-[tokAdd]- l-4 r8  value(2) size (2)
tadd r6, l-4, r8
tadc r7, l-3, r9
 ; r4 <-[tokAssign]- r4 r6  value(2) size (2)
mov l-4, r6
 ; load to retval
mov r4, A
mov l-3, r7
 ; load to retval
mov r5, A
 ; r0 <-[tokSequential]- r0 r2 r4  value(0) size (0)
 ; tokSequential



 ; break
 ; Unconditional jump to L68
ldd X, $L68
jmp
L69:
 ; }
 ; Unconditional jump to L67
ldd X, $L67
jmp
L68:
 ; while
 ; RPN'ized expression: "l --p 0 != "
 ; Expanded expression: "(@8) --p(2) 0 != "
L72:
 ; Expression stack:    "(@8) --p(2) 0 != IF![73] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "73" size(0) REG: z0  
 ;  - 009<tokNEQ> "0" size(0) REG: z0  
 ;  -  - 082<tokPostDec> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "8" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "8" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 076<tokIfNot> "73" size(2) REG: r0  
 ;  -  - 009<tokNEQ> "0" size(2) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "0" size(2) REG: r4  *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *
 ;  -  - 045<tokSub> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "8" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *

 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokNEQ]- a4 r4  value(0) size (2)
ldd X, $L74
tsub r0, a4, r4
tsbc r1, a5, r5
ld r1, 0
ld r0, 0
jz
ld r0, 1
; --- end of comparison:
L74:
 ; r0 <-[tokIfNot]- r0  value(73) size (2)
 ; Jump if zero to L73
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L73
jz
 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokSub]- a4 r6  value(2) size (2)
tsub r4, a4, r6
tsbc r5, a5, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov a4, r4
 ; load to retval
mov r2, A
mov a5, r5
 ; load to retval
mov r3, A
 ; r0 <-[tokSequential]- r0 r2  value(0) size (0)
 ; tokSequential



 ; RPN'ized expression: "s1 ++p *u 0 = "
 ; Expanded expression: "(@-2) ++p(2) 0 =(-1) "
 ; Expression stack:    "(@-2) ++p(2) 0 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 081<tokPostInc> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 061<tokAssign> "-1" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(-1) REG: r2  *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 043<tokAdd> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r2, 0
 ; r0 <-[tokAssign]- l-2 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-2
mov A, r2
mov [X], A
 ; load to retval
mov r0, A
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokAdd]- l-2 r6  value(2) size (2)
tadd r4, l-2, r6
tadc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r0 <-[tokSequential]- r0 r2  value(0) size (0)
 ; tokSequential



 ; Unconditional jump to L72
ldd X, $L72
jmp
L73:
 ; return
 ; RPN'ized expression: "d "
 ; Expanded expression: "(@4) *(2) "
 ; Expression stack:    "(@4) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- a0  value(0) size (2)
mov r0, a0
mov r1, a1
 ; tokReturn



L65:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb memset : (
 ; prm     dest : * unsigned
 ; prm     val : unsigned
 ; prm     n : int
 ;     ) int
.section text
memset:
.export memset
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     dest : (@4) : * unsigned
 ; loc     val : (@6) : unsigned
 ; loc     n : (@8) : int
 ; loc     k : (@-2) : int
 ; RPN'ized expression: "k n = "
 ; Expanded expression: "(@-2) (@8) *(2) =(2) "
 ; Expression stack:    "(@-2) (@8) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a4  value(2) size (2)
mov l-2, a4
 ; load to retval
mov r0, A
mov l-1, a5
 ; load to retval
mov r1, A



 ; while
 ; RPN'ized expression: "k --p "
 ; Expanded expression: "(@-2) --p(2) "
L77:
 ; Expression stack:    "(@-2) --p(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 082<tokPostDec> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 020<tokReturn> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 045<tokSub> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- l-2  value(0) size (2)
mov r0, l-2
mov r1, l-1
 ; tokReturn
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokSub]- l-2 r6  value(2) size (2)
tsub r4, l-2, r6
tsbc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r0 <-[tokSequential]- r0 r2  value(0) size (0)
 ; tokSequential



 ; Jump if zero to L78
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L78
jz
 ; {
 ; RPN'ized expression: "dest *u val = "
 ; Expanded expression: "(@4) *(2) (@6) *(2) =(2) "
 ; Expression stack:    "(@4) *(2) (@6) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- a0 a2  value(2) size (2)
 ; assign to non-ident non-local lvalue
movw X, a0
mov A, a2
mov [X], A
 ; load to retval
mov r0, A
 ; emit_inc_x()
X++
mov A, a3
mov [X], A
 ; load to retval
mov r1, A



 ; RPN'ized expression: "dest ++p "
 ; Expanded expression: "(@4) 2 +=p(2) "
 ; Expression stack:    "(@4) 2 +=p(2) "
 ; Expr tree before optim: 
 ; 083<tokPostAdd> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 083<tokPostAdd> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "2" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(2) size (2)
 ; possible optimization - pass size
ld r4, 2
ld r5, 0
 ; r2 <-[tokAdd]- a0 r4  value(2) size (2)
tadd r2, a0, r4
tadc r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a0, r2
 ; load to retval
mov r0, A
mov a1, r3
 ; load to retval
mov r1, A



 ; }
 ; Unconditional jump to L77
ldd X, $L77
jmp
L78:
 ; return
 ; RPN'ized expression: "n "
 ; Expanded expression: "(@8) *(2) "
 ; Expression stack:    "(@8) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- a4  value(0) size (2)
mov r0, a4
mov r1, a5
 ; tokReturn



L75:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb memcpy : (
 ; prm     dest : * unsigned
 ; prm     src : * unsigned
 ; prm     n : int
 ;     ) int
.section text
memcpy:
.export memcpy
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     dest : (@4) : * unsigned
 ; loc     src : (@6) : * unsigned
 ; loc     n : (@8) : int
 ; loc     k : (@-2) : int
 ; RPN'ized expression: "k n = "
 ; Expanded expression: "(@-2) (@8) *(2) =(2) "
 ; Expression stack:    "(@-2) (@8) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a4  value(2) size (2)
mov l-2, a4
 ; load to retval
mov r0, A
mov l-1, a5
 ; load to retval
mov r1, A



 ; while
 ; RPN'ized expression: "k --p "
 ; Expanded expression: "(@-2) --p(2) "
L81:
 ; Expression stack:    "(@-2) --p(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 082<tokPostDec> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 020<tokReturn> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 045<tokSub> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- l-2  value(0) size (2)
mov r0, l-2
mov r1, l-1
 ; tokReturn
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokSub]- l-2 r6  value(2) size (2)
tsub r4, l-2, r6
tsbc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r0 <-[tokSequential]- r0 r2  value(0) size (0)
 ; tokSequential



 ; Jump if zero to L82
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L82
jz
 ; {
 ; RPN'ized expression: "dest *u src *u = "
 ; Expanded expression: "(@4) *(2) (@6) *(2) *(2) =(2) "
 ; Expression stack:    "(@4) *(2) (@6) *(2) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryStar]- a2  value(2) size (2)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, a2
mov A, [X]
mov r2, A
 ; emit_inc_x()
X++
mov A, [X]
mov r3, A
 ; r0 <-[tokAssign]- a0 r2  value(2) size (2)
 ; assign to non-ident non-local lvalue
movw X, a0
mov A, r2
mov [X], A
 ; load to retval
mov r0, A
 ; emit_inc_x()
X++
mov A, r3
mov [X], A
 ; load to retval
mov r1, A



 ; RPN'ized expression: "dest ++p "
 ; Expanded expression: "(@4) 2 +=p(2) "
 ; Expression stack:    "(@4) 2 +=p(2) "
 ; Expr tree before optim: 
 ; 083<tokPostAdd> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 083<tokPostAdd> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "2" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(2) size (2)
 ; possible optimization - pass size
ld r4, 2
ld r5, 0
 ; r2 <-[tokAdd]- a0 r4  value(2) size (2)
tadd r2, a0, r4
tadc r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a0, r2
 ; load to retval
mov r0, A
mov a1, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "src ++p "
 ; Expanded expression: "(@6) 2 +=p(2) "
 ; Expression stack:    "(@6) 2 +=p(2) "
 ; Expr tree before optim: 
 ; 083<tokPostAdd> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 083<tokPostAdd> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "6" size(2) REG: z0  *
 ;  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "6" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "2" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(2) size (2)
 ; possible optimization - pass size
ld r4, 2
ld r5, 0
 ; r2 <-[tokAdd]- a2 r4  value(2) size (2)
tadd r2, a2, r4
tadc r3, a3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a2, r2
 ; load to retval
mov r0, A
mov a3, r3
 ; load to retval
mov r1, A



 ; }
 ; Unconditional jump to L81
ldd X, $L81
jmp
L82:
 ; return
 ; RPN'ized expression: "n "
 ; Expanded expression: "(@8) *(2) "
 ; Expression stack:    "(@8) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- a4  value(0) size (2)
mov r0, a4
mov r1, a5
 ; tokReturn



L79:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb memcpy_r : (
 ; prm     dest : * unsigned
 ; prm     src : * unsigned
 ; prm     n : int
 ;     ) int
.section text
memcpy_r:
.export memcpy_r
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     dest : (@4) : * unsigned
 ; loc     src : (@6) : * unsigned
 ; loc     n : (@8) : int
 ; loc     k : (@-2) : int
 ; RPN'ized expression: "k n = "
 ; Expanded expression: "(@-2) (@8) *(2) =(2) "
 ; Expression stack:    "(@-2) (@8) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a4  value(2) size (2)
mov l-2, a4
 ; load to retval
mov r0, A
mov l-1, a5
 ; load to retval
mov r1, A



 ; while
 ; RPN'ized expression: "k --p "
 ; Expanded expression: "(@-2) --p(2) "
L85:
 ; Expression stack:    "(@-2) --p(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 082<tokPostDec> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 020<tokReturn> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 045<tokSub> "2" size(2) REG: r4  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r4 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "1" size(2) REG: r6  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- l-2  value(0) size (2)
mov r0, l-2
mov r1, l-1
 ; tokReturn
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; r4 <-[tokSub]- l-2 r6  value(2) size (2)
tsub r4, l-2, r6
tsbc r5, l-1, r7
 ; r2 <-[tokAssign]- r2 r4  value(2) size (2)
mov l-2, r4
 ; load to retval
mov r2, A
mov l-1, r5
 ; load to retval
mov r3, A
 ; r0 <-[tokSequential]- r0 r2  value(0) size (0)
 ; tokSequential



 ; Jump if zero to L86
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L86
jz
 ; {
 ; RPN'ized expression: "dest *u src *u = "
 ; Expanded expression: "(@4) *(2) (@6) *(2) *(2) =(2) "
 ; Expression stack:    "(@4) *(2) (@6) *(2) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryStar]- a2  value(2) size (2)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, a2
mov A, [X]
mov r2, A
 ; emit_inc_x()
X++
mov A, [X]
mov r3, A
 ; r0 <-[tokAssign]- a0 r2  value(2) size (2)
 ; assign to non-ident non-local lvalue
movw X, a0
mov A, r2
mov [X], A
 ; load to retval
mov r0, A
 ; emit_inc_x()
X++
mov A, r3
mov [X], A
 ; load to retval
mov r1, A



 ; RPN'ized expression: "dest ++p "
 ; Expanded expression: "(@4) 2 +=p(2) "
 ; Expression stack:    "(@4) 2 +=p(2) "
 ; Expr tree before optim: 
 ; 083<tokPostAdd> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 083<tokPostAdd> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "2" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(2) size (2)
 ; possible optimization - pass size
ld r4, 2
ld r5, 0
 ; r2 <-[tokAdd]- a0 r4  value(2) size (2)
tadd r2, a0, r4
tadc r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a0, r2
 ; load to retval
mov r0, A
mov a1, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "src ++p "
 ; Expanded expression: "(@6) 2 +=p(2) "
 ; Expression stack:    "(@6) 2 +=p(2) "
 ; Expr tree before optim: 
 ; 083<tokPostAdd> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 083<tokPostAdd> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "6" size(2) REG: z0  *
 ;  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "6" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "2" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "2" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(2) size (2)
 ; possible optimization - pass size
ld r4, 2
ld r5, 0
 ; r2 <-[tokAdd]- a2 r4  value(2) size (2)
tadd r2, a2, r4
tadc r3, a3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a2, r2
 ; load to retval
mov r0, A
mov a3, r3
 ; load to retval
mov r1, A



 ; }
 ; Unconditional jump to L85
ldd X, $L85
jmp
L86:
 ; return
 ; RPN'ized expression: "n "
 ; Expanded expression: "(@8) *(2) "
 ; Expression stack:    "(@8) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "8" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- a4  value(0) size (2)
mov r0, a4
mov r1, a5
 ; tokReturn



L83:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb memcmp : (
 ; prm     mem1 : * void
 ; prm     mem2 : * void
 ; prm     len : int
 ;     ) int
.section text
memcmp:
.export memcmp
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     mem1 : (@4) : * void
 ; loc     mem2 : (@6) : * void
 ; loc     len : (@8) : int
 ; loc     p1 : (@-2) : * signed char
 ; RPN'ized expression: "p1 mem1 = "
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



 ; loc     p2 : (@-4) : * signed char
 ; RPN'ized expression: "p2 mem2 = "
 ; Expanded expression: "(@-4) (@6) *(2) =(2) "
 ; Expression stack:    "(@-4) (@6) *(2) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "6" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a2  value(2) size (2)
mov l-4, a2
 ; load to retval
mov r0, A
mov l-3, a3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "len 0 == "
 ; Expanded expression: "(@8) *(2) 0 == "
 ; Expression stack:    "(@8) *(2) 0 == IF![89] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "89" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "89" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- a4 r4  value(0) size (2)
ldd X, $L91
tsub r0, a4, r4
tsbc r1, a5, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L91:
 ; r0 <-[tokIfNot]- r0  value(89) size (2)
 ; Jump if zero to L89
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L89
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



 ; Unconditional jump to L87
ldd X, $L87
jmp
L89:
 ; while
 ; RPN'ized expression: "len -- p1 *u p2 *u == && "
 ; Expanded expression: "(@8) --(2) _Bool [sh&&->94] (@-2) *(2) *(-1) (@-4) *(2) *(-1) == &&[94] "
L92:
 ; Expression stack:    "(@8) --(2) _Bool [sh&&->94] (@-2) *(2) *(-1) (@-4) *(2) *(-1) == &&[94] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 006<tokLogAnd> "94" size(0) REG: z0  
 ;  -  - 090<tokShortCirc> "94" size(0) REG: z0  
 ;  -  -  - 120<tok_Bool> "0" size(0) REG: z0  
 ;  -  -  -  - 013<tokDec> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ;  -  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 013<tokDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "8" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "8" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "8" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 006<tokLogAnd> "94" size(2) REG: r0  
 ;  -  - 090<tokShortCirc> "94" size(2) REG: r0  
 ;  -  -  - 120<tok_Bool> "0" size(2) REG: r0  
 ;  -  -  -  - 061<tokAssign> "2" size(2) REG: r0  
 ;  -  -  -  -  - 089<tokLocalOfs> "8" size(2) REG: r0 SUPPRESSED *
 ;  -  -  -  -  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a4 SUPPRESSED 
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "8" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  -  - 001<tokNumInt> "1" size(2) REG: r4  *
 ;  -  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  -  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: r2  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: r4  
 ;  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(8) size (2)
 ; !!! emit suppressed
 ; a4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- a4 r4  value(2) size (2)
tsub r2, a4, r4
tsbc r3, a5, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a4, r2
 ; load to retval
mov r0, A
mov a5, r3
 ; load to retval
mov r1, A
 ; r0 <-[tok_Bool]- r0  value(0) size (2)
; maybe omit it all? Why convert to bool?
; XXX Optimize size!
tor r0, r0, r1
ld r1, 0
;;;;;; ; r0 <-[tokShortCirc]- r0  value(94) size (2)
 ; tokShortCirc
 ; Jump if zero to L94
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L94
jz
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryStar]- l-2  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-2
mov A, [X]
mov r2, A
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokUnaryStar]- l-4  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-4
mov A, [X]
mov r4, A
 ; r0 <-[tokEQ]- r2 r4  value(0) size (-1)
ldd X, $L95
tsub r0, r2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L95:
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokLogAnd]- r0 r0  value(94) size (2)
 ; tokLogAndOr
L94:
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L93
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L93
jz
 ; {
 ; RPN'ized expression: "p1 ++p "
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



 ; RPN'ized expression: "p2 ++p "
 ; Expanded expression: "(@-4) ++p(2) "
 ; Expression stack:    "(@-4) ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokAdd]- l-4 r4  value(2) size (2)
tadd r2, l-4, r4
tadc r3, l-3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; }
 ; Unconditional jump to L92
ldd X, $L92
jmp
L93:
 ; return
 ; RPN'ized expression: "p1 *u p2 *u - "
 ; Expanded expression: "(@-2) *(2) *(-1) (@-4) *(2) *(-1) - "
 ; Expression stack:    "(@-2) *(2) *(-1) (@-4) *(2) *(-1) - return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 045<tokSub> "0" size(-1) REG: r0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokUnaryStar]- l-2  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-2
mov A, [X]
mov r0, A
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryStar]- l-4  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
movw X, l-4
mov A, [X]
mov r2, A
 ; r0 <-[tokSub]- r0 r2  value(0) size (-1)
tsub r0, r0, r2
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L87:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; RPN'ized expression: "8 "
 ; Expanded expression: "8 "
 ; Expression value: 8
 ; glb printnum_buffer : [8u] char
.section bss
printnum_buffer:
.export printnum_buffer
.skip 8

 ; glb printnum : (
 ; prm     n : int
 ;     ) void
.section text
printnum:
.export printnum
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     n : (@4) : int
 ; loc     neg : (@-2) : char
 ; RPN'ized expression: "neg 0 = "
 ; Expanded expression: "(@-2) 0 =(-1) "
 ; Expression stack:    "(@-2) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; loc     s : (@-4) : * char
 ; RPN'ized expression: "s printnum_buffer 7 + = "
 ; Expanded expression: "(@-4) printnum_buffer 7 + =(2) "
 ; Expression stack:    "(@-4) printnum_buffer 7 + =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 016<tokIdent> "178" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "7" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  - 016<tokIdent> "178" size(2) REG: r2  *
 ;  -  - 001<tokNumInt> "7" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(178) size (2)
ld r2, $(l)printnum_buffer
ld r3, $(h)printnum_buffer
 ; r4 <-[tokNumInt]-  value(7) size (2)
 ; possible optimization - pass size
ld r4, 7
ld r5, 0
 ; r2 <-[tokAdd]- r2 r4  value(0) size (2)
tadd r2, r2, r4
tadc r3, r3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; loc     n_rem : (@-6) : char
 ; RPN'ized expression: "s *u 0 = "
 ; Expanded expression: "(@-4) *(2) 0 =(-1) "
 ; Expression stack:    "(@-4) *(2) 0 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r2, 0
 ; r0 <-[tokAssign]- l-4 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-4
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; if
 ; RPN'ized expression: "n 0 == "
 ; Expanded expression: "(@4) *(2) 0 == "
 ; Expression stack:    "(@4) *(2) 0 == IF![98] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "98" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "98" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- a0 r4  value(0) size (2)
ldd X, $L100
tsub r0, a0, r4
tsbc r1, a1, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L100:
 ; r0 <-[tokIfNot]- r0  value(98) size (2)
 ; Jump if zero to L98
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L98
jz



 ; {
 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-4) --p(2) "
 ; Expression stack:    "(@-4) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-4 r4  value(2) size (2)
tsub r2, l-4, r4
tsbc r3, l-3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "s *u 48 = "
 ; Expanded expression: "(@-4) *(2) 48 =(-1) "
 ; Expression stack:    "(@-4) *(2) 48 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "48" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r2, 48
 ; r0 <-[tokAssign]- l-4 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-4
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
L98:
 ; if
 ; RPN'ized expression: "n 0 < "
 ; Expanded expression: "(@4) *(2) 0 < "
 ; Expression stack:    "(@4) *(2) 0 < IF![101] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "101" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "101" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokLess]- a0 r4  value(0) size (2)
ldd X, $L103
tsub r0, a0, r4
tsbc r1, a1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L103:
 ; r0 <-[tokIfNot]- r0  value(101) size (2)
 ; Jump if zero to L101
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L101
jz



 ; {
 ; RPN'ized expression: "neg 1 = "
 ; Expanded expression: "(@-2) 1 =(-1) "
 ; Expression stack:    "(@-2) 1 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "1" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (-1)
 ; possible optimization - pass size
ld r2, 1
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-2, r2
 ; load to retval
mov r0, A



 ; RPN'ized expression: "n n -u = "
 ; Expanded expression: "(@4) (@4) *(2) -u =(2) "
 ; Expression stack:    "(@4) (@4) *(2) -u =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 080<tokUnaryMinus> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 080<tokUnaryMinus> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryMinus]- a0  value(0) size (2)
 ;; optimize this
mov A, a0
not
inc
mov r2, A
ld A,0
mov B,A
mov A, a1
adc
mov r3, A
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a0, r2
 ; load to retval
mov r0, A
mov a1, r3
 ; load to retval
mov r1, A



 ; }
L101:
 ; while
 ; RPN'ized expression: "n "
 ; Expanded expression: "(@4) *(2) "
L104:
 ; Expression stack:    "(@4) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- a0  value(0) size (2)
mov r0, a0
mov r1, a1
 ; tokReturn



 ; Jump if zero to L105
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L105
jz
 ; {
 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-4) --p(2) "
 ; Expression stack:    "(@-4) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-4 r4  value(2) size (2)
tsub r2, l-4, r4
tsbc r3, l-3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "n_rem n 10 % = "
 ; Expanded expression: "(@-6) (@4) *(2) 10 % =(-1) "
 ; Expression stack:    "(@-6) (@4) *(2) 10 % =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 037<tokMod> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 041<tokCall> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "10" size(2) REG: r4  *
 ;  -  - 019<tokInt> "0" size(2) REG: r6  
 ;  -  -  - 016<tokIdent> "221" size(0) REG: r6 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r6 <-[tokIdent]-  value(221) size (0)
 ; !!! emit suppressed
 ; r6 <-[tokInt]- r6  value(0) size (2)
ld A, 0x00
mov r7, A
 ; r2 <-[tokCall]- a0 r4 r6  value(0) size (2)
pushw a0
pushw r4
 ; pushed 2 args
 ; Call not by tokIdent - load address
movw X, r6
jmp
popw r2
SP+=2
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-6, r2
 ; load to retval
mov r0, A



 ; RPN'ized expression: "s *u n_rem 48 + = "
 ; Expanded expression: "(@-4) *(2) (@-6) *(-1) 48 + =(-1) "
 ; Expression stack:    "(@-4) *(2) (@-6) *(-1) 48 + =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "48" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r4, 48
 ; r2 <-[tokAdd]- l-6 r4  value(0) size (-1)
tadd r2, l-6, r4
 ; r0 <-[tokAssign]- l-4 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-4
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "n n 10 / = "
 ; Expanded expression: "(@4) (@4) *(2) 10 / =(2) "
 ; Expression stack:    "(@4) (@4) *(2) 10 / =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 047<tokDiv> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 041<tokCall> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "10" size(2) REG: r4  *
 ;  -  - 019<tokInt> "0" size(2) REG: r6  
 ;  -  -  - 016<tokIdent> "229" size(0) REG: r6 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r6 <-[tokIdent]-  value(229) size (0)
 ; !!! emit suppressed
 ; r6 <-[tokInt]- r6  value(0) size (2)
ld A, 0x00
mov r7, A
 ; r2 <-[tokCall]- a0 r4 r6  value(0) size (2)
pushw a0
pushw r4
 ; pushed 2 args
 ; Call not by tokIdent - load address
movw X, r6
jmp
popw r2
SP+=2
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a0, r2
 ; load to retval
mov r0, A
mov a1, r3
 ; load to retval
mov r1, A



 ; }
 ; Unconditional jump to L104
ldd X, $L104
jmp
L105:
 ; if
 ; RPN'ized expression: "neg "
 ; Expanded expression: "(@-2) *(-1) "
 ; Expression stack:    "(@-2) *(-1) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokInt]- l-2  value(0) size (2)
mov r0, l-2
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L106
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L106
jz
 ; {
 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-4) --p(2) "
 ; Expression stack:    "(@-4) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-4 r4  value(2) size (2)
tsub r2, l-4, r4
tsbc r3, l-3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "s *u 45 = "
 ; Expanded expression: "(@-4) *(2) 45 =(-1) "
 ; Expression stack:    "(@-4) *(2) 45 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "45" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "45" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(45) size (-1)
 ; possible optimization - pass size
ld r2, 45
 ; r0 <-[tokAssign]- l-4 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-4
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
L106:
 ; RPN'ized expression: "( s puts ) "
 ; Expanded expression: " (@-4) *(2)  puts ()2 "
 ; Expression stack:    "( (@-4) *(2) , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- l-4 r2  value(2) size (2)
pushw l-4
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



L96:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb printhex : (
 ; prm     i : int
 ;     ) void
.section text
printhex:
.export printhex
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
 ; prolog end

 ; loc     i : (@4) : int
 ; RPN'ized expression: "8 "
 ; Expanded expression: "8 "
 ; Expression value: 8
 ; loc     printnum_buffer : (@-8) : [8u] char
 ; loc     s : (@-10) : * char
 ; RPN'ized expression: "s printnum_buffer 7 + = "
 ; Expanded expression: "(@-10) (@-1) =(2) "
 ; Expression stack:    "(@-10) (@-1) =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 089<tokLocalOfs> "-1" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 089<tokLocalOfs> "-1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-1) size (2)
 ; localOfs: -1, fix for [m+off] to -16
ld A, 16
mov B,A
mov A,ML
sub
mov r2,A
ld A, 0
mov B,A
mov A,MH
sbc
mov r3,A
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-10, r2
 ; load to retval
mov r0, A
mov l-9, r3
 ; load to retval
mov r1, A



 ; loc     n_rem : (@-12) : char
 ; loc     n : (@-14) : char
 ; RPN'ized expression: "s *u 0 = "
 ; Expanded expression: "(@-10) *(2) 0 =(-1) "
 ; Expression stack:    "(@-10) *(2) 0 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r2, 0
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-10) --p(2) "
 ; Expression stack:    "(@-10) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-10 r4  value(2) size (2)
tsub r2, l-10, r4
tsbc r3, l-9, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-10, r2
 ; load to retval
mov r0, A
mov l-9, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "n i 15 & = "
 ; Expanded expression: "(@-14) (@4) *(2) 15 & =(-1) "
 ; Expression stack:    "(@-14) (@4) *(2) 15 & =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  - 038<tokAnd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "15" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 038<tokAnd> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "15" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(15) size (2)
 ; possible optimization - pass size
ld r4, 15
ld r5, 0
 ; r2 <-[tokAnd]- a0 r4  value(0) size (2)
tand r2, a0, r4
tand r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-14, r2
 ; load to retval
mov r0, A



 ; if
 ; RPN'ized expression: "n 9 > "
 ; Expanded expression: "(@-14) *(-1) 9 > "
 ; Expression stack:    "(@-14) *(-1) 9 > IF![110] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "110" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "9" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "110" size(-1) REG: r0  
 ;  - 062<tokMore> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "9" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(9) size (-1)
 ; possible optimization - pass size
ld r4, 9
 ; r0 <-[tokMore]- l-14 r4  value(0) size (-1)
ldd X, $L112
tsub r0, l-14, r4
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L112:
 ; r0 <-[tokIfNot]- r0  value(110) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L110
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L110
jz



 ; {
 ; RPN'ized expression: "s *u n 97 + 10 - = "
 ; Expanded expression: "(@-10) *(2) (@-14) *(-1) 97 + 10 - =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-14) *(-1) 97 + 10 - =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "97" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "0" size(-1) REG: r2  
 ;  -  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "97" size(-1) REG: r4  *
 ;  -  - 001<tokNumInt> "10" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(97) size (-1)
 ; possible optimization - pass size
ld r4, 97
 ; r2 <-[tokAdd]- l-14 r4  value(0) size (-1)
tadd r2, l-14, r4
 ; r4 <-[tokNumInt]-  value(10) size (-1)
 ; possible optimization - pass size
ld r4, 10
 ; r2 <-[tokSub]- r2 r4  value(0) size (-1)
tsub r2, r2, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
 ; Unconditional jump to L111
ldd X, $L111
jmp
L110:
 ; else
 ; {
 ; RPN'ized expression: "s *u n 48 + = "
 ; Expanded expression: "(@-10) *(2) (@-14) *(-1) 48 + =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-14) *(-1) 48 + =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "48" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r4, 48
 ; r2 <-[tokAdd]- l-14 r4  value(0) size (-1)
tadd r2, l-14, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
L111:
 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-10) --p(2) "
 ; Expression stack:    "(@-10) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-10 r4  value(2) size (2)
tsub r2, l-10, r4
tsbc r3, l-9, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-10, r2
 ; load to retval
mov r0, A
mov l-9, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "n i 240 & = "
 ; Expanded expression: "(@-14) (@4) *(2) 240 & =(-1) "
 ; Expression stack:    "(@-14) (@4) *(2) 240 & =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  - 038<tokAnd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "240" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 038<tokAnd> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "240" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(240) size (2)
 ; possible optimization - pass size
ld r4, 240
ld r5, 0
 ; r2 <-[tokAnd]- a0 r4  value(0) size (2)
tand r2, a0, r4
tand r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-14, r2
 ; load to retval
mov r0, A



 ; RPN'ized expression: "n n 4 >> = "
 ; Expanded expression: "(@-14) (@-14) *(-1) 4 >> =(-1) "
 ; Expression stack:    "(@-14) (@-14) *(-1) 4 >> =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  - 005<tokRShift> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 005<tokRShift> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "4" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(4) size (-1)
 ; possible optimization - pass size
ld r4, 4
 ; r2 <-[tokRShift]- l-14 r4  value(0) size (-1)
tshr r2, l-14, r0
tshr r2, r2, r0
tshr r2, r2, r0
tshr r2, r2, r0
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-14, r2
 ; load to retval
mov r0, A



 ; if
 ; RPN'ized expression: "n 9 > "
 ; Expanded expression: "(@-14) *(-1) 9 > "
 ; Expression stack:    "(@-14) *(-1) 9 > IF![113] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "113" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "9" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "113" size(-1) REG: r0  
 ;  - 062<tokMore> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "9" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(9) size (-1)
 ; possible optimization - pass size
ld r4, 9
 ; r0 <-[tokMore]- l-14 r4  value(0) size (-1)
ldd X, $L115
tsub r0, l-14, r4
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L115:
 ; r0 <-[tokIfNot]- r0  value(113) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L113
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L113
jz



 ; {
 ; RPN'ized expression: "s *u n 97 + 10 - = "
 ; Expanded expression: "(@-10) *(2) (@-14) *(-1) 97 + 10 - =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-14) *(-1) 97 + 10 - =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "97" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "0" size(-1) REG: r2  
 ;  -  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "97" size(-1) REG: r4  *
 ;  -  - 001<tokNumInt> "10" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(97) size (-1)
 ; possible optimization - pass size
ld r4, 97
 ; r2 <-[tokAdd]- l-14 r4  value(0) size (-1)
tadd r2, l-14, r4
 ; r4 <-[tokNumInt]-  value(10) size (-1)
 ; possible optimization - pass size
ld r4, 10
 ; r2 <-[tokSub]- r2 r4  value(0) size (-1)
tsub r2, r2, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
 ; Unconditional jump to L114
ldd X, $L114
jmp
L113:
 ; else
 ; {
 ; RPN'ized expression: "s *u n 48 + = "
 ; Expanded expression: "(@-10) *(2) (@-14) *(-1) 48 + =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-14) *(-1) 48 + =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "48" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r4, 48
 ; r2 <-[tokAdd]- l-14 r4  value(0) size (-1)
tadd r2, l-14, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
L114:
 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-10) --p(2) "
 ; Expression stack:    "(@-10) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-10 r4  value(2) size (2)
tsub r2, l-10, r4
tsbc r3, l-9, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-10, r2
 ; load to retval
mov r0, A
mov l-9, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "i i 8 >> = "
 ; Expanded expression: "(@4) (@4) *(2) 8 >> =(2) "
 ; Expression stack:    "(@4) (@4) *(2) 8 >> =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  - 005<tokRShift> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "8" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 005<tokRShift> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "8" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(8) size (2)
 ; possible optimization - pass size
ld r4, 8
ld r5, 0
 ; r2 <-[tokRShift]- a0 r4  value(0) size (2)
mov r2, a1
ld A,0
mov r3, A
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov a0, r2
 ; load to retval
mov r0, A
mov a1, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "n i 15 & = "
 ; Expanded expression: "(@-14) (@4) *(2) 15 & =(-1) "
 ; Expression stack:    "(@-14) (@4) *(2) 15 & =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  - 038<tokAnd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "15" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 038<tokAnd> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "15" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(15) size (2)
 ; possible optimization - pass size
ld r4, 15
ld r5, 0
 ; r2 <-[tokAnd]- a0 r4  value(0) size (2)
tand r2, a0, r4
tand r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-14, r2
 ; load to retval
mov r0, A



 ; if
 ; RPN'ized expression: "n 9 > "
 ; Expanded expression: "(@-14) *(-1) 9 > "
 ; Expression stack:    "(@-14) *(-1) 9 > IF![116] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "116" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "9" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "116" size(-1) REG: r0  
 ;  - 062<tokMore> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "9" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(9) size (-1)
 ; possible optimization - pass size
ld r4, 9
 ; r0 <-[tokMore]- l-14 r4  value(0) size (-1)
ldd X, $L118
tsub r0, l-14, r4
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L118:
 ; r0 <-[tokIfNot]- r0  value(116) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L116
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L116
jz



 ; {
 ; RPN'ized expression: "s *u n 97 + 10 - = "
 ; Expanded expression: "(@-10) *(2) (@-14) *(-1) 97 + 10 - =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-14) *(-1) 97 + 10 - =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "97" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "0" size(-1) REG: r2  
 ;  -  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "97" size(-1) REG: r4  *
 ;  -  - 001<tokNumInt> "10" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(97) size (-1)
 ; possible optimization - pass size
ld r4, 97
 ; r2 <-[tokAdd]- l-14 r4  value(0) size (-1)
tadd r2, l-14, r4
 ; r4 <-[tokNumInt]-  value(10) size (-1)
 ; possible optimization - pass size
ld r4, 10
 ; r2 <-[tokSub]- r2 r4  value(0) size (-1)
tsub r2, r2, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
 ; Unconditional jump to L117
ldd X, $L117
jmp
L116:
 ; else
 ; {
 ; RPN'ized expression: "s *u n 48 + = "
 ; Expanded expression: "(@-10) *(2) (@-14) *(-1) 48 + =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-14) *(-1) 48 + =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "48" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r4, 48
 ; r2 <-[tokAdd]- l-14 r4  value(0) size (-1)
tadd r2, l-14, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
L117:
 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-10) --p(2) "
 ; Expression stack:    "(@-10) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-10 r4  value(2) size (2)
tsub r2, l-10, r4
tsbc r3, l-9, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-10, r2
 ; load to retval
mov r0, A
mov l-9, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "n i 240 & = "
 ; Expanded expression: "(@-14) (@4) *(2) 240 & =(-1) "
 ; Expression stack:    "(@-14) (@4) *(2) 240 & =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  - 038<tokAnd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "240" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 038<tokAnd> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "240" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(240) size (2)
 ; possible optimization - pass size
ld r4, 240
ld r5, 0
 ; r2 <-[tokAnd]- a0 r4  value(0) size (2)
tand r2, a0, r4
tand r3, a1, r5
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-14, r2
 ; load to retval
mov r0, A



 ; RPN'ized expression: "n n 4 >> = "
 ; Expanded expression: "(@-14) (@-14) *(-1) 4 >> =(-1) "
 ; Expression stack:    "(@-14) (@-14) *(-1) 4 >> =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  - 005<tokRShift> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 005<tokRShift> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "4" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(4) size (-1)
 ; possible optimization - pass size
ld r4, 4
 ; r2 <-[tokRShift]- l-14 r4  value(0) size (-1)
tshr r2, l-14, r0
tshr r2, r2, r0
tshr r2, r2, r0
tshr r2, r2, r0
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-14, r2
 ; load to retval
mov r0, A



 ; if
 ; RPN'ized expression: "n 9 > "
 ; Expanded expression: "(@-14) *(-1) 9 > "
 ; Expression stack:    "(@-14) *(-1) 9 > IF![119] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "119" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "9" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "119" size(-1) REG: r0  
 ;  - 062<tokMore> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "9" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(9) size (-1)
 ; possible optimization - pass size
ld r4, 9
 ; r0 <-[tokMore]- l-14 r4  value(0) size (-1)
ldd X, $L121
tsub r0, l-14, r4
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L121:
 ; r0 <-[tokIfNot]- r0  value(119) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L119
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L119
jz



 ; {
 ; RPN'ized expression: "s *u n 97 + 10 - = "
 ; Expanded expression: "(@-10) *(2) (@-14) *(-1) 97 + 10 - =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-14) *(-1) 97 + 10 - =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "97" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "0" size(-1) REG: r2  
 ;  -  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "97" size(-1) REG: r4  *
 ;  -  - 001<tokNumInt> "10" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(97) size (-1)
 ; possible optimization - pass size
ld r4, 97
 ; r2 <-[tokAdd]- l-14 r4  value(0) size (-1)
tadd r2, l-14, r4
 ; r4 <-[tokNumInt]-  value(10) size (-1)
 ; possible optimization - pass size
ld r4, 10
 ; r2 <-[tokSub]- r2 r4  value(0) size (-1)
tsub r2, r2, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
 ; Unconditional jump to L120
ldd X, $L120
jmp
L119:
 ; else
 ; {
 ; RPN'ized expression: "s *u n 48 + = "
 ; Expanded expression: "(@-10) *(2) (@-14) *(-1) 48 + =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-14) *(-1) 48 + =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "48" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r4, 48
 ; r2 <-[tokAdd]- l-14 r4  value(0) size (-1)
tadd r2, l-14, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
L120:
 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-10) --p(2) "
 ; Expression stack:    "(@-10) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-10 r4  value(2) size (2)
tsub r2, l-10, r4
tsbc r3, l-9, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-10, r2
 ; load to retval
mov r0, A
mov l-9, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "s *u 120 = "
 ; Expanded expression: "(@-10) *(2) 120 =(-1) "
 ; Expression stack:    "(@-10) *(2) 120 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 001<tokNumInt> "120" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "120" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(120) size (-1)
 ; possible optimization - pass size
ld r2, 120
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "s --p "
 ; Expanded expression: "(@-10) --p(2) "
 ; Expression stack:    "(@-10) --p(2) "
 ; Expr tree before optim: 
 ; 082<tokPostDec> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 082<tokPostDec> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  - 045<tokSub> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-10" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokSub]- l-10 r4  value(2) size (2)
tsub r2, l-10, r4
tsbc r3, l-9, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-10, r2
 ; load to retval
mov r0, A
mov l-9, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "s *u 48 = "
 ; Expanded expression: "(@-10) *(2) 48 =(-1) "
 ; Expression stack:    "(@-10) *(2) 48 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "48" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(48) size (-1)
 ; possible optimization - pass size
ld r2, 48
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-10
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "( s puts ) "
 ; Expanded expression: " (@-10) *(2)  puts ()2 "
 ; Expression stack:    "( (@-10) *(2) , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- l-10 r2  value(2) size (2)
pushw l-10
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



L108:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; RPN'ized expression: "127 "
 ; Expanded expression: "127 "
 ; Expression value: 127
 ; glb in_str : [127u] char
.section bss
in_str:
.export in_str
.skip 127

 ; glb getline : () void
.section text
getline:
.export getline
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     c : (@-2) : char
 ; loc     count : (@-4) : int
 ; RPN'ized expression: "count 0 = "
 ; Expanded expression: "(@-4) 0 =(2) "
 ; Expression stack:    "(@-4) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; loc     s : (@-6) : * char
 ; RPN'ized expression: "s in_str = "
 ; Expanded expression: "(@-6) in_str =(2) "
 ; Expression stack:    "(@-6) in_str =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 016<tokIdent> "218" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "218" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(218) size (2)
ld r2, $(l)in_str
ld r3, $(h)in_str
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



 ; while
 ; RPN'ized expression: "1 "
 ; Expanded expression: "1 "
 ; Expression value: 1
L124:
 ; {
 ; RPN'ized expression: "c ( getc ) = "
 ; Expanded expression: "(@-2)  getc ()0 =(-1) "
 ; Expression stack:    "(@-2) ( getc )0 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 041<tokCall> "0" size(0) REG: z0  
 ;  -  - 016<tokIdent> "20" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 041<tokCall> "0" size(2) REG: r2  
 ;  -  - 016<tokIdent> "20" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(20) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- r2  value(0) size (2)
 ; pushed 0 args
 ; no args, reserve 2 bytes for retval
SP-=2
ldd X, $getc
jmp
popw r2
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-2, r2
 ; load to retval
mov r0, A



 ; if
 ; RPN'ized expression: "c 0 == "
 ; Expanded expression: "(@-2) *(-1) 0 == "
 ; Expression stack:    "(@-2) *(-1) 0 == IF![126] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "126" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "126" size(-1) REG: r0  
 ;  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r4, 0
 ; r0 <-[tokEQ]- l-2 r4  value(0) size (-1)
ldd X, $L128
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L128:
 ; r0 <-[tokIfNot]- r0  value(126) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L126
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L126
jz



 ; continue
 ; Unconditional jump to L124
ldd X, $L124
jmp
L126:
 ; if
 ; RPN'ized expression: "c 10 == c 13 == || "
 ; Expanded expression: "(@-2) *(-1) 10 == [sh||->131] (@-2) *(-1) 13 == ||[131] "
 ; Expression stack:    "(@-2) *(-1) 10 == [sh||->131] (@-2) *(-1) 13 == ||[131] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 007<tokLogOr> "131" size(0) REG: z0  
 ;  -  - 090<tokShortCirc> "-131" size(0) REG: z0  
 ;  -  -  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  -  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "13" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 007<tokLogOr> "131" size(-1) REG: r0  
 ;  -  -  - 090<tokShortCirc> "-131" size(-1) REG: r0  
 ;  -  -  -  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  -  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  -  - 001<tokNumInt> "10" size(-1) REG: r4  *
 ;  -  -  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "13" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (-1)
 ; possible optimization - pass size
ld r4, 10
 ; r0 <-[tokEQ]- l-2 r4  value(0) size (-1)
ldd X, $L132
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L132:
 ; r0 <-[tokShortCirc]- r0  value(-131) size (-1)
 ; tokShortCirc
 ; Jump if not zero to L131
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L131
jnz
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(13) size (-1)
 ; possible optimization - pass size
ld r4, 13
 ; r0 <-[tokEQ]- l-2 r4  value(0) size (-1)
ldd X, $L133
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L133:
 ; r0 <-[tokLogOr]- r0 r0  value(131) size (-1)
 ; tokLogAndOr
L131:
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L129
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L129
jz
 ; {
 ; RPN'ized expression: "s *u 0 = "
 ; Expanded expression: "(@-6) *(2) 0 =(-1) "
 ; Expression stack:    "(@-6) *(2) 0 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r2, 0
 ; r0 <-[tokAssign]- l-6 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-6
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; return
 ; Unconditional jump to L122
ldd X, $L122
jmp
 ; }
 ; Unconditional jump to L130
ldd X, $L130
jmp
L129:
 ; else
 ; {
 ; if
 ; RPN'ized expression: "count 127 1 - < "
 ; Expanded expression: "(@-4) *(2) 126 < "
 ; Expression stack:    "(@-4) *(2) 126 < IF![134] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "134" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "126" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "134" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "126" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(126) size (2)
 ; possible optimization - pass size
ld r4, 126
ld r5, 0
 ; r0 <-[tokLess]- l-4 r4  value(0) size (2)
ldd X, $L136
tsub r0, l-4, r4
tsbc r1, l-3, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L136:
 ; r0 <-[tokIfNot]- r0  value(134) size (2)
 ; Jump if zero to L134
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L134
jz



 ; {
 ; RPN'ized expression: "s *u c = "
 ; Expanded expression: "(@-6) *(2) (@-2) *(-1) =(-1) "
 ; Expression stack:    "(@-6) *(2) (@-2) *(-1) =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- l-6 l-2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
movw X, l-6
mov A, l-2
mov [X], A
 ; load to retval
mov r0, A



 ; RPN'ized expression: "s ++p "
 ; Expanded expression: "(@-6) ++p(2) "
 ; Expression stack:    "(@-6) ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokAdd]- l-6 r4  value(2) size (2)
tadd r2, l-6, r4
tadc r3, l-5, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "count ++p "
 ; Expanded expression: "(@-4) ++p(2) "
 ; Expression stack:    "(@-4) ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokAdd]- l-4 r4  value(2) size (2)
tadd r2, l-4, r4
tadc r3, l-3, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; }
L134:
 ; }
L130:
 ; }
 ; Unconditional jump to L124
ldd X, $L124
jmp
L125:
L122:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb test_func : () void
.section text
test_func:
.export test_func
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end


.section rodata
L139:
.byte 0x74 ; (t)
.byte 0x68 ; (h)
.byte 0x69 ; (i)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x69 ; (i)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x61 ; (a)
.byte 0x20 ; ( )
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x20 ; ( )
.byte 0x66 ; (f)
.byte 0x75 ; (u)
.byte 0x6e ; (n)
.byte 0x63 ; (c)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L139 puts ) "
 ; Expanded expression: " L139  puts ()2 "
 ; Expression stack:    "( L139 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "251" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "251" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(251) size (2)
ld r0, $(l)L139
ld r1, $(h)L139
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



L137:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb test_func_2 : () void
.section text
test_func_2:
.export test_func_2
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end


.section rodata
L142:
.byte 0x61 ; (a)
.byte 0x6e ; (n)
.byte 0x6f ; (o)
.byte 0x74 ; (t)
.byte 0x68 ; (h)
.byte 0x65 ; (e)
.byte 0x72 ; (r)
.byte 0x20 ; ( )
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x20 ; ( )
.byte 0x66 ; (f)
.byte 0x75 ; (u)
.byte 0x6e ; (n)
.byte 0x63 ; (c)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L142 puts ) "
 ; Expanded expression: " L142  puts ()2 "
 ; Expression stack:    "( L142 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "264" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "264" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(264) size (2)
ld r0, $(l)L142
ld r1, $(h)L142
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



L140:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb funcs : [0u] * () void
.section data
funcs:
.export funcs
 ; =
 ; RPN'ized expression: "test_func "
 ; Expanded expression: "test_func "
 ; GenAddrData
.word $test_func
 ; RPN'ized expression: "test_func_2 "
 ; Expanded expression: "test_func_2 "
 ; GenAddrData
.word $test_func_2
 ; RPN'ized expression: "test_func_2 "
 ; Expanded expression: "test_func_2 "
 ; GenAddrData
.word $test_func_2
 ; RPN'ized expression: "test_func_2 "
 ; Expanded expression: "test_func_2 "
 ; GenAddrData
.word $test_func_2

 ; glb cmds : [0u] * char
.section data
cmds:
.export cmds
 ; =

.section rodata
L143:
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section data
 ; RPN'ized expression: "L143 "
 ; Expanded expression: "L143 "
 ; GenAddrData
.word $L143

.section rodata
L144:
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section data
 ; RPN'ized expression: "L144 "
 ; Expanded expression: "L144 "
 ; GenAddrData
.word $L144

.section rodata
L145:
.byte 0x61 ; (a)
.byte 0x6e ; (n)
.byte 0x6f ; (o)
.byte 0x74 ; (t)
.byte 0x68 ; (h)
.byte 0x65 ; (e)
.byte 0x72 ; (r)
.byte 0x5f ; (_)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x67 ; (g)
.byte 0x00 ; (NUL)
.skip 1

.section data
 ; RPN'ized expression: "L145 "
 ; Expanded expression: "L145 "
 ; GenAddrData
.word $L145

.section rodata
L146:
.byte 0x66 ; (f)
.byte 0x6f ; (o)
.byte 0x75 ; (u)
.byte 0x72 ; (r)
.byte 0x74 ; (t)
.byte 0x68 ; (h)
.byte 0x5f ; (_)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x00 ; (NUL)
.skip 1

.section data
 ; RPN'ized expression: "L146 "
 ; Expanded expression: "L146 "
 ; GenAddrData
.word $L146

.section rodata
L147:
.byte 0x66 ; (f)
.byte 0x69 ; (i)
.byte 0x66 ; (f)
.byte 0x74 ; (t)
.byte 0x68 ; (h)
.byte 0x00 ; (NUL)
.skip 1

.section data
 ; RPN'ized expression: "L147 "
 ; Expanded expression: "L147 "
 ; GenAddrData
.word $L147

 ; glb get_cmd_idx : (
 ; prm     s : * char
 ;     ) int
.section text
get_cmd_idx:
.export get_cmd_idx
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     s : (@4) : * char
 ; loc     i : (@-2) : int
 ; RPN'ized expression: "i 0 = "
 ; Expanded expression: "(@-2) 0 =(2) "
 ; Expression stack:    "(@-2) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; for
 ; RPN'ized expression: "i 0 = "
 ; Expanded expression: "(@-2) 0 =(2) "
 ; Expression stack:    "(@-2) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



L150:
 ; RPN'ized expression: "i 5 < "
 ; Expanded expression: "(@-2) *(2) 5 < "
 ; Expression stack:    "(@-2) *(2) 5 < IF![153] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "153" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "5" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "153" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "5" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(5) size (2)
 ; possible optimization - pass size
ld r4, 5
ld r5, 0
 ; r0 <-[tokLess]- l-2 r4  value(0) size (2)
ldd X, $L154
tsub r0, l-2, r4
tsbc r1, l-1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L154:
 ; r0 <-[tokIfNot]- r0  value(153) size (2)
 ; Jump if zero to L153
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L153
jz



 ; RPN'ized expression: "i ++p "
 ; Expanded expression: "(@-2) ++p(2) "
 ; {

.section rodata
L155:
.byte 0x63 ; (c)
.byte 0x6f ; (o)
.byte 0x6d ; (m)
.byte 0x70 ; (p)
.byte 0x61 ; (a)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x67 ; (g)
.byte 0x20 ; ( )
.byte 0x77 ; (w)
.byte 0x69 ; (i)
.byte 0x74 ; (t)
.byte 0x68 ; (h)
.byte 0x20 ; ( )
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L155 puts ) "
 ; Expanded expression: " L155  puts ()2 "
 ; Expression stack:    "( L155 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "290" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "290" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(290) size (2)
ld r0, $(l)L155
ld r1, $(h)L155
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; RPN'ized expression: "( cmds i + *u puts ) "
 ; Expanded expression: " cmds (@-2) *(2) 2 * + *(2)  puts ()2 "
 ; Expression stack:    "( cmds (@-2) *(2) 2 * + *(2) , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 016<tokIdent> "266" size(0) REG: z0  *
 ;  -  -  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  -  - 001<tokNumInt> "2" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: r0  
 ;  -  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  -  - 016<tokIdent> "266" size(2) REG: r0  *
 ;  -  -  - 004<tokLShift> "0" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "1" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(266) size (2)
ld r0, $(l)cmds
ld r1, $(h)cmds
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLShift]- l-2 r4  value(0) size (2)
tshl r2, l-2, r0
tshlc r3, l-1, r0
 ; r0 <-[tokAdd]- r0 r2  value(0) size (2)
tadd r0, r0, r2
tadc r1, r1, r3
 ; r0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r0
mov A, [X]
mov r0, A
 ; emit_inc_x()
X++
mov A, [X]
mov r1, A
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L156:
.byte 0x20 ; ( )
.byte 0x3a ; (:)
.byte 0x20 ; ( )
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L156 puts ) "
 ; Expanded expression: " L156  puts ()2 "
 ; Expression stack:    "( L156 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "295" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "295" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(295) size (2)
ld r0, $(l)L156
ld r1, $(h)L156
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; if
 ; RPN'ized expression: "( s , cmds i + *u strcmp ) 0 == "
 ; Expanded expression: " (@4) *(2)  cmds (@-2) *(2) 2 * + *(2)  strcmp ()4 0 == "
 ; Expression stack:    "( (@4) *(2) , cmds (@-2) *(2) 2 * + *(2) , strcmp )4 0 == IF![157] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "157" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  -  - 016<tokIdent> "266" size(0) REG: z0  *
 ;  -  -  -  -  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  -  -  -  - 001<tokNumInt> "2" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "41" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "157" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 041<tokCall> "4" size(2) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: r4  
 ;  -  -  -  - 043<tokAdd> "0" size(2) REG: r4  
 ;  -  -  -  -  - 016<tokIdent> "266" size(2) REG: r4  *
 ;  -  -  -  -  - 004<tokLShift> "0" size(2) REG: r6  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r6 SUPPRESSED *
 ;  -  -  -  -  -  - 001<tokNumInt> "1" size(2) REG: r8 SUPPRESSED *
 ;  -  -  - 016<tokIdent> "41" size(2) REG: r6 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(266) size (2)
ld r4, $(l)cmds
ld r5, $(h)cmds
 ; r6 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r6  value(2) size (2)
 ; !!! emit suppressed
 ; r8 <-[tokNumInt]-  value(1) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokLShift]- l-2 r8  value(0) size (2)
tshl r6, l-2, r0
tshlc r7, l-1, r0
 ; r4 <-[tokAdd]- r4 r6  value(0) size (2)
tadd r4, r4, r6
tadc r5, r5, r7
 ; r4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r4
mov A, [X]
mov r4, A
 ; emit_inc_x()
X++
mov A, [X]
mov r5, A
 ; r6 <-[tokIdent]-  value(41) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- a0 r4 r6  value(4) size (2)
pushw a0
pushw r4
 ; pushed 2 args
ldd X, $strcmp
jmp
popw r2
SP+=2
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- r2 r4  value(0) size (2)
ldd X, $L159
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L159:
 ; r0 <-[tokIfNot]- r0  value(157) size (2)
 ; Jump if zero to L157
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L157
jz



 ; {

.section rodata
L160:
.byte 0x73 ; (s)
.byte 0x75 ; (u)
.byte 0x63 ; (c)
.byte 0x63 ; (c)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x73 ; (s)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L160 puts ) "
 ; Expanded expression: " L160  puts ()2 "
 ; Expression stack:    "( L160 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L160
ld r1, $(h)L160
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; return
 ; RPN'ized expression: "i "
 ; Expanded expression: "(@-2) *(2) "
 ; Expression stack:    "(@-2) *(2) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokReturn]- l-2  value(0) size (2)
mov r0, l-2
mov r1, l-1
 ; tokReturn



 ; Unconditional jump to L148
ldd X, $L148
jmp
 ; }
 ; Unconditional jump to L158
ldd X, $L158
jmp
L157:
 ; else
 ; {

.section rodata
L161:
.byte 0x66 ; (f)
.byte 0x61 ; (a)
.byte 0x69 ; (i)
.byte 0x6c ; (l)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L161 puts ) "
 ; Expanded expression: " L161  puts ()2 "
 ; Expression stack:    "( L161 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L161
ld r1, $(h)L161
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L158:
 ; }
L151:
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



 ; Unconditional jump to L150
ldd X, $L150
jmp
L153:
 ; return
 ; RPN'ized expression: "1 -u "
 ; Expanded expression: "-1 "
 ; Expression value: -1
 ; Expression stack:    "-1 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 001<tokNumInt> "-1" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 001<tokNumInt> "-1" size(2) REG: r0  *

 ; r0 <-[tokNumInt]-  value(-1) size (2)
 ; possible optimization - pass size
ld r0, 255
ld r1, 255
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L148:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb tests : () void
.section text
tests:
.export tests
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end

 ; loc     k : (@-2) : char
 ; RPN'ized expression: "k 1 = "
 ; Expanded expression: "(@-2) 1 =(-1) "
 ; Expression stack:    "(@-2) 1 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "1" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "k 0 == "
 ; Expanded expression: "(@-2) *(-1) 0 == "
 ; Expression stack:    "(@-2) *(-1) 0 == IF![164] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "164" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "164" size(-1) REG: r0  
 ;  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r4, 0
 ; r0 <-[tokEQ]- l-2 r4  value(0) size (-1)
ldd X, $L166
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L166:
 ; r0 <-[tokIfNot]- r0  value(164) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L164
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L164
jz



 ; {

.section rodata
L167:
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x46 ; (F)
.byte 0x61 ; (a)
.byte 0x69 ; (i)
.byte 0x6c ; (l)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L167 puts ) "
 ; Expanded expression: " L167  puts ()2 "
 ; Expression stack:    "( L167 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L167
ld r1, $(h)L167
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
 ; Unconditional jump to L165
ldd X, $L165
jmp
L164:
 ; else
 ; {

.section rodata
L168:
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x50 ; (P)
.byte 0x61 ; (a)
.byte 0x73 ; (s)
.byte 0x73 ; (s)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L168 puts ) "
 ; Expanded expression: " L168  puts ()2 "
 ; Expression stack:    "( L168 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L168
ld r1, $(h)L168
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L165:
 ; RPN'ized expression: "k 0 = "
 ; Expanded expression: "(@-2) 0 =(-1) "
 ; Expression stack:    "(@-2) 0 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r2, 0
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-2, r2
 ; load to retval
mov r0, A



 ; if
 ; RPN'ized expression: "k 0 == "
 ; Expanded expression: "(@-2) *(-1) 0 == "
 ; Expression stack:    "(@-2) *(-1) 0 == IF![169] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "169" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "169" size(-1) REG: r0  
 ;  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (-1)
 ; possible optimization - pass size
ld r4, 0
 ; r0 <-[tokEQ]- l-2 r4  value(0) size (-1)
ldd X, $L171
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L171:
 ; r0 <-[tokIfNot]- r0  value(169) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L169
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L169
jz



 ; {

.section rodata
L172:
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x31 ; (1)
.byte 0x2e ; (.)
.byte 0x50 ; (P)
.byte 0x61 ; (a)
.byte 0x73 ; (s)
.byte 0x73 ; (s)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L172 puts ) "
 ; Expanded expression: " L172  puts ()2 "
 ; Expression stack:    "( L172 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L172
ld r1, $(h)L172
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
 ; Unconditional jump to L170
ldd X, $L170
jmp
L169:
 ; else
 ; {

.section rodata
L173:
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x31 ; (1)
.byte 0x2e ; (.)
.byte 0x46 ; (F)
.byte 0x61 ; (a)
.byte 0x69 ; (i)
.byte 0x6c ; (l)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L173 puts ) "
 ; Expanded expression: " L173  puts ()2 "
 ; Expression stack:    "( L173 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L173
ld r1, $(h)L173
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L170:
 ; loc     l : (@-4) : int
 ; RPN'ized expression: "l 4096 = "
 ; Expanded expression: "(@-4) 4096 =(2) "
 ; Expression stack:    "(@-4) 4096 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "4096" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "4096" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(4096) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 16
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "l 0 == "
 ; Expanded expression: "(@-4) *(2) 0 == "
 ; Expression stack:    "(@-4) *(2) 0 == IF![174] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "174" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "174" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- l-4 r4  value(0) size (2)
ldd X, $L176
tsub r0, l-4, r4
tsbc r1, l-3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L176:
 ; r0 <-[tokIfNot]- r0  value(174) size (2)
 ; Jump if zero to L174
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L174
jz



 ; {

.section rodata
L177:
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x32 ; (2)
.byte 0x2e ; (.)
.byte 0x46 ; (F)
.byte 0x61 ; (a)
.byte 0x69 ; (i)
.byte 0x6c ; (l)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L177 puts ) "
 ; Expanded expression: " L177  puts ()2 "
 ; Expression stack:    "( L177 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L177
ld r1, $(h)L177
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
 ; Unconditional jump to L175
ldd X, $L175
jmp
L174:
 ; else
 ; {

.section rodata
L178:
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x32 ; (2)
.byte 0x2e ; (.)
.byte 0x50 ; (P)
.byte 0x61 ; (a)
.byte 0x73 ; (s)
.byte 0x73 ; (s)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L178 puts ) "
 ; Expanded expression: " L178  puts ()2 "
 ; Expression stack:    "( L178 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L178
ld r1, $(h)L178
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L175:
 ; RPN'ized expression: "l 0 = "
 ; Expanded expression: "(@-4) 0 =(2) "
 ; Expression stack:    "(@-4) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "l 0 == "
 ; Expanded expression: "(@-4) *(2) 0 == "
 ; Expression stack:    "(@-4) *(2) 0 == IF![179] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "179" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "179" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- l-4 r4  value(0) size (2)
ldd X, $L181
tsub r0, l-4, r4
tsbc r1, l-3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L181:
 ; r0 <-[tokIfNot]- r0  value(179) size (2)
 ; Jump if zero to L179
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L179
jz



 ; {

.section rodata
L182:
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x33 ; (3)
.byte 0x2e ; (.)
.byte 0x50 ; (P)
.byte 0x61 ; (a)
.byte 0x73 ; (s)
.byte 0x73 ; (s)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L182 puts ) "
 ; Expanded expression: " L182  puts ()2 "
 ; Expression stack:    "( L182 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L182
ld r1, $(h)L182
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
 ; Unconditional jump to L180
ldd X, $L180
jmp
L179:
 ; else
 ; {

.section rodata
L183:
.byte 0x30 ; (0)
.byte 0x2e ; (.)
.byte 0x33 ; (3)
.byte 0x2e ; (.)
.byte 0x46 ; (F)
.byte 0x61 ; (a)
.byte 0x69 ; (i)
.byte 0x6c ; (l)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L183 puts ) "
 ; Expanded expression: " L183  puts ()2 "
 ; Expression stack:    "( L183 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L183
ld r1, $(h)L183
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L180:

.section rodata
L184:
.byte 0x53 ; (S)
.byte 0x68 ; (h)
.byte 0x6f ; (o)
.byte 0x75 ; (u)
.byte 0x6c ; (l)
.byte 0x64 ; (d)
.byte 0x20 ; ( )
.byte 0x70 ; (p)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x74 ; (t)
.byte 0x20 ; ( )
.byte 0x35 ; (5)
.byte 0x41 ; (A)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x6e ; (n)
.byte 0x61 ; (a)
.byte 0x64 ; (d)
.byte 0x20 ; ( )
.byte 0x35 ; (5)
.byte 0x42 ; (B)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x74 ; (t)
.byte 0x77 ; (w)
.byte 0x69 ; (i)
.byte 0x63 ; (c)
.byte 0x65 ; (e)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L184 puts ) "
 ; Expanded expression: " L184  puts ()2 "
 ; Expression stack:    "( L184 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "300" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "300" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(300) size (2)
ld r0, $(l)L184
ld r1, $(h)L184
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; for
 ; loc     i : (@-6) : char
 ; RPN'ized expression: "i 0 = "
 ; Expanded expression: "(@-6) 0 =(-1) "
 ; Expression stack:    "(@-6) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



L185:
 ; RPN'ized expression: "i 10 < "
 ; Expanded expression: "(@-6) *(-1) 10 < "
 ; Expression stack:    "(@-6) *(-1) 10 < IF![188] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "188" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "188" size(-1) REG: r0  
 ;  - 060<tokLess> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "10" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (-1)
 ; possible optimization - pass size
ld r4, 10
 ; r0 <-[tokLess]- l-6 r4  value(0) size (-1)
ldd X, $L189
tsub r0, l-6, r4
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L189:
 ; r0 <-[tokIfNot]- r0  value(188) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L188
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L188
jz



 ; RPN'ized expression: "i ++p "
 ; Expanded expression: "(@-6) ++p(-1) "
 ; {
 ; if
 ; RPN'ized expression: "i 5 < "
 ; Expanded expression: "(@-6) *(-1) 5 < "
 ; Expression stack:    "(@-6) *(-1) 5 < IF![190] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "190" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "5" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "190" size(-1) REG: r0  
 ;  - 060<tokLess> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "5" size(-1) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(5) size (-1)
 ; possible optimization - pass size
ld r4, 5
 ; r0 <-[tokLess]- l-6 r4  value(0) size (-1)
ldd X, $L192
tsub r0, l-6, r4
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L192:
 ; r0 <-[tokIfNot]- r0  value(190) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L190
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L190
jz



 ; {
 ; RPN'ized expression: "( 65 putc ) "
 ; Expanded expression: " 65  putc ()2 "
 ; Expression stack:    "( 65 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "65" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "65" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(65) size (2)
 ; possible optimization - pass size
ld r0, 65
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0



 ; }
 ; Unconditional jump to L191
ldd X, $L191
jmp
L190:
 ; else
 ; {
 ; RPN'ized expression: "( 66 putc ) "
 ; Expanded expression: " 66  putc ()2 "
 ; Expression stack:    "( 66 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "66" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "66" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(66) size (2)
 ; possible optimization - pass size
ld r0, 66
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0



 ; }
L191:
 ; }
L186:
 ; Expression stack:    "(@-6) ++p(-1) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "-1" size(-1) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "-1" size(-1) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(-1) REG: z0  *
 ;  - 043<tokAdd> "-1" size(-1) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(-1) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(-1) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(-1) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "-1" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(-1) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(-1) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (-1)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-6) size (-1)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (-1)
 ; possible optimization - pass size
ld r4, 1
 ; r2 <-[tokAdd]- l-6 r4  value(-1) size (-1)
tadd r2, l-6, r4
 ; r0 <-[tokAssign]- r0 r2  value(-1) size (-1)
mov l-6, r2
 ; load to retval
mov r0, A



 ; Unconditional jump to L185
ldd X, $L185
jmp
L188:
 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0



 ; for
 ; loc     i : (@-6) : int
 ; RPN'ized expression: "i 0 = "
 ; Expanded expression: "(@-6) 0 =(2) "
 ; Expression stack:    "(@-6) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



L193:
 ; RPN'ized expression: "i 10 < "
 ; Expanded expression: "(@-6) *(2) 10 < "
 ; Expression stack:    "(@-6) *(2) 10 < IF![196] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "196" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "196" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "10" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r0 <-[tokLess]- l-6 r4  value(0) size (2)
ldd X, $L197
tsub r0, l-6, r4
tsbc r1, l-5, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L197:
 ; r0 <-[tokIfNot]- r0  value(196) size (2)
 ; Jump if zero to L196
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L196
jz



 ; RPN'ized expression: "i ++p "
 ; Expanded expression: "(@-6) ++p(2) "
 ; {
 ; if
 ; RPN'ized expression: "i 5 < "
 ; Expanded expression: "(@-6) *(2) 5 < "
 ; Expression stack:    "(@-6) *(2) 5 < IF![198] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "198" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "5" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "198" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "5" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(5) size (2)
 ; possible optimization - pass size
ld r4, 5
ld r5, 0
 ; r0 <-[tokLess]- l-6 r4  value(0) size (2)
ldd X, $L200
tsub r0, l-6, r4
tsbc r1, l-5, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L200:
 ; r0 <-[tokIfNot]- r0  value(198) size (2)
 ; Jump if zero to L198
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L198
jz



 ; {
 ; RPN'ized expression: "( 65 putc ) "
 ; Expanded expression: " 65  putc ()2 "
 ; Expression stack:    "( 65 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "65" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "65" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(65) size (2)
 ; possible optimization - pass size
ld r0, 65
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0



 ; }
 ; Unconditional jump to L199
ldd X, $L199
jmp
L198:
 ; else
 ; {
 ; RPN'ized expression: "( 66 putc ) "
 ; Expanded expression: " 66  putc ()2 "
 ; Expression stack:    "( 66 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "66" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "66" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(66) size (2)
 ; possible optimization - pass size
ld r0, 66
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0



 ; }
L199:
 ; }
L194:
 ; Expression stack:    "(@-6) ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "2" size(2) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: z0  *
 ;  - 043<tokAdd> "2" size(2) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(2) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; r2 <-[tokAdd]- l-6 r4  value(2) size (2)
tadd r2, l-6, r4
tadc r3, l-5, r5
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



 ; Unconditional jump to L193
ldd X, $L193
jmp
L196:
 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0




.section rodata
L201:
.byte 0x50 ; (P)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x74 ; (t)
.byte 0x20 ; ( )
.byte 0x30 ; (0)
.byte 0x78 ; (x)
.byte 0x31 ; (1)
.byte 0x32 ; (2)
.byte 0x33 ; (3)
.byte 0x34 ; (4)
.byte 0x3a ; (:)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L201 puts ) "
 ; Expanded expression: " L201  puts ()2 "
 ; Expression stack:    "( L201 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "305" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "305" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(305) size (2)
ld r0, $(l)L201
ld r1, $(h)L201
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; RPN'ized expression: "( 4660 printhex ) "
 ; Expanded expression: " 4660  printhex ()2 "
 ; Expression stack:    "( 4660 , printhex )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "4660" size(0) REG: z0  *
 ;  - 016<tokIdent> "205" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "4660" size(2) REG: r0  *
 ;  - 016<tokIdent> "205" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(4660) size (2)
 ; possible optimization - pass size
ld r0, 52
ld r1, 18
 ; r2 <-[tokIdent]-  value(205) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $printhex
jmp
popw r0



 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0




.section rodata
L202:
.byte 0x43 ; (C)
.byte 0x6f ; (o)
.byte 0x6d ; (m)
.byte 0x70 ; (p)
.byte 0x61 ; (a)
.byte 0x72 ; (r)
.byte 0x65 ; (e)
.byte 0x20 ; ( )
.byte 0x27 ; (')
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x27 ; (')
.byte 0x20 ; ( )
.byte 0x61 ; (a)
.byte 0x6e ; (n)
.byte 0x64 ; (d)
.byte 0x20 ; ( )
.byte 0x27 ; (')
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x32 ; (2)
.byte 0x27 ; (')
.byte 0x2c ; (,)
.byte 0x20 ; ( )
.byte 0x73 ; (s)
.byte 0x68 ; (h)
.byte 0x6f ; (o)
.byte 0x75 ; (u)
.byte 0x6c ; (l)
.byte 0x64 ; (d)
.byte 0x20 ; ( )
.byte 0x70 ; (p)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x74 ; (t)
.byte 0x20 ; ( )
.byte 0x6e ; (n)
.byte 0x6f ; (o)
.byte 0x74 ; (t)
.byte 0x2d ; (-)
.byte 0x7a ; (z)
.byte 0x65 ; (e)
.byte 0x72 ; (r)
.byte 0x6f ; (o)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L202 puts ) "
 ; Expanded expression: " L202  puts ()2 "
 ; Expression stack:    "( L202 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "310" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "310" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(310) size (2)
ld r0, $(l)L202
ld r1, $(h)L202
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L203:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section text

.section rodata
L204:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( ( L204 , L203 strcmp ) printhex ) "
 ; Expanded expression: "  L204  L203  strcmp ()4  printhex ()2 "
 ; Expression stack:    "( ( L204 , L203 , strcmp )4 , printhex )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  - 016<tokIdent> "320" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "315" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "41" size(0) REG: z0  *
 ;  - 016<tokIdent> "205" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 041<tokCall> "4" size(2) REG: r0  
 ;  -  - 016<tokIdent> "320" size(2) REG: r0  *
 ;  -  - 016<tokIdent> "315" size(2) REG: r2  *
 ;  -  - 016<tokIdent> "41" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "205" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(320) size (2)
ld r0, $(l)L204
ld r1, $(h)L204
 ; r2 <-[tokIdent]-  value(315) size (2)
ld r2, $(l)L203
ld r3, $(h)L203
 ; r4 <-[tokIdent]-  value(41) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2 r4  value(4) size (2)
pushw r0
pushw r2
 ; pushed 2 args
ldd X, $strcmp
jmp
popw r0
SP+=2
 ; r2 <-[tokIdent]-  value(205) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $printhex
jmp
popw r0



 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0




.section rodata
L205:
.byte 0x43 ; (C)
.byte 0x6f ; (o)
.byte 0x6d ; (m)
.byte 0x70 ; (p)
.byte 0x61 ; (a)
.byte 0x72 ; (r)
.byte 0x65 ; (e)
.byte 0x20 ; ( )
.byte 0x27 ; (')
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x33 ; (3)
.byte 0x27 ; (')
.byte 0x20 ; ( )
.byte 0x61 ; (a)
.byte 0x6e ; (n)
.byte 0x64 ; (d)
.byte 0x20 ; ( )
.byte 0x27 ; (')
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x33 ; (3)
.byte 0x27 ; (')
.byte 0x2c ; (,)
.byte 0x20 ; ( )
.byte 0x73 ; (s)
.byte 0x68 ; (h)
.byte 0x6f ; (o)
.byte 0x75 ; (u)
.byte 0x6c ; (l)
.byte 0x64 ; (d)
.byte 0x20 ; ( )
.byte 0x70 ; (p)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x74 ; (t)
.byte 0x20 ; ( )
.byte 0x7a ; (z)
.byte 0x65 ; (e)
.byte 0x72 ; (r)
.byte 0x6f ; (o)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L205 puts ) "
 ; Expanded expression: " L205  puts ()2 "
 ; Expression stack:    "( L205 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "325" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "325" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(325) size (2)
ld r0, $(l)L205
ld r1, $(h)L205
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L206:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x33 ; (3)
.byte 0x00 ; (NUL)
.skip 1

.section text

.section rodata
L207:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x33 ; (3)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( ( L207 , L206 strcmp ) printhex ) "
 ; Expanded expression: "  L207  L206  strcmp ()4  printhex ()2 "
 ; Expression stack:    "( ( L207 , L206 , strcmp )4 , printhex )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  - 016<tokIdent> "335" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "330" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "41" size(0) REG: z0  *
 ;  - 016<tokIdent> "205" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 041<tokCall> "4" size(2) REG: r0  
 ;  -  - 016<tokIdent> "335" size(2) REG: r0  *
 ;  -  - 016<tokIdent> "330" size(2) REG: r2  *
 ;  -  - 016<tokIdent> "41" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "205" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(335) size (2)
ld r0, $(l)L207
ld r1, $(h)L207
 ; r2 <-[tokIdent]-  value(330) size (2)
ld r2, $(l)L206
ld r3, $(h)L206
 ; r4 <-[tokIdent]-  value(41) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2 r4  value(4) size (2)
pushw r0
pushw r2
 ; pushed 2 args
ldd X, $strcmp
jmp
popw r0
SP+=2
 ; r2 <-[tokIdent]-  value(205) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $printhex
jmp
popw r0



 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $putc
jmp
popw r0



 ; if

.section rodata
L210:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section text

.section rodata
L211:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L211 , L210 strcmp ) 0 == "
 ; Expanded expression: " L211  L210  strcmp ()4 0 == "
 ; Expression stack:    "( L211 , L210 , strcmp )4 0 == IF![208] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "208" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  -  - 016<tokIdent> "345" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "340" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "41" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "208" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 041<tokCall> "4" size(2) REG: r2  
 ;  -  -  - 016<tokIdent> "345" size(2) REG: r2  *
 ;  -  -  - 016<tokIdent> "340" size(2) REG: r4  *
 ;  -  -  - 016<tokIdent> "41" size(2) REG: r6 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokIdent]-  value(345) size (2)
ld r2, $(l)L211
ld r3, $(h)L211
 ; r4 <-[tokIdent]-  value(340) size (2)
ld r4, $(l)L210
ld r5, $(h)L210
 ; r6 <-[tokIdent]-  value(41) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- r2 r4 r6  value(4) size (2)
pushw r2
pushw r4
 ; pushed 2 args
ldd X, $strcmp
jmp
popw r2
SP+=2
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- r2 r4  value(0) size (2)
ldd X, $L212
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L212:
 ; r0 <-[tokIfNot]- r0  value(208) size (2)
 ; Jump if zero to L208
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L208
jz



 ; {

.section rodata
L213:
.byte 0x54 ; (T)
.byte 0x68 ; (h)
.byte 0x69 ; (i)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x6c ; (l)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x65 ; (e)
.byte 0x20 ; ( )
.byte 0x73 ; (s)
.byte 0x68 ; (h)
.byte 0x6f ; (o)
.byte 0x75 ; (u)
.byte 0x6c ; (l)
.byte 0x64 ; (d)
.byte 0x20 ; ( )
.byte 0x4e ; (N)
.byte 0x4f ; (O)
.byte 0x54 ; (T)
.byte 0x20 ; ( )
.byte 0x62 ; (b)
.byte 0x65 ; (e)
.byte 0x20 ; ( )
.byte 0x70 ; (p)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x64 ; (d)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L213 puts ) "
 ; Expanded expression: " L213  puts ()2 "
 ; Expression stack:    "( L213 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "350" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "350" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(350) size (2)
ld r0, $(l)L213
ld r1, $(h)L213
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L208:
 ; if

.section rodata
L216:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section text

.section rodata
L217:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L217 , L216 strcmp ) "
 ; Expanded expression: " L217  L216  strcmp ()4 "
 ; Expression stack:    "( L217 , L216 , strcmp )4 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  - 016<tokIdent> "355" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "350" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "41" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "4" size(2) REG: r0  
 ;  -  - 016<tokIdent> "355" size(2) REG: r0  *
 ;  -  - 016<tokIdent> "350" size(2) REG: r2  *
 ;  -  - 016<tokIdent> "41" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(355) size (2)
ld r0, $(l)L217
ld r1, $(h)L217
 ; r2 <-[tokIdent]-  value(350) size (2)
ld r2, $(l)L216
ld r3, $(h)L216
 ; r4 <-[tokIdent]-  value(41) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2 r4  value(4) size (2)
pushw r0
pushw r2
 ; pushed 2 args
ldd X, $strcmp
jmp
popw r0
SP+=2
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L214
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L214
jz
 ; {

.section rodata
L218:
.byte 0x54 ; (T)
.byte 0x68 ; (h)
.byte 0x69 ; (i)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x6c ; (l)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x65 ; (e)
.byte 0x20 ; ( )
.byte 0x53 ; (S)
.byte 0x48 ; (H)
.byte 0x4f ; (O)
.byte 0x55 ; (U)
.byte 0x4c ; (L)
.byte 0x44 ; (D)
.byte 0x20 ; ( )
.byte 0x62 ; (b)
.byte 0x65 ; (e)
.byte 0x20 ; ( )
.byte 0x70 ; (p)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x64 ; (d)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L218 puts ) "
 ; Expanded expression: " L218  puts ()2 "
 ; Expression stack:    "( L218 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "360" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "360" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(360) size (2)
ld r0, $(l)L218
ld r1, $(h)L218
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L214:
 ; loc     count : (@-6) : int
 ; RPN'ized expression: "count 10 = "
 ; Expanded expression: "(@-6) 10 =(2) "
 ; Expression stack:    "(@-6) 10 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "10" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r2, 10
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "count 50 < "
 ; Expanded expression: "(@-6) *(2) 50 < "
 ; Expression stack:    "(@-6) *(2) 50 < IF![219] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "219" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "50" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "219" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "50" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(50) size (2)
 ; possible optimization - pass size
ld r4, 50
ld r5, 0
 ; r0 <-[tokLess]- l-6 r4  value(0) size (2)
ldd X, $L221
tsub r0, l-6, r4
tsbc r1, l-5, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L221:
 ; r0 <-[tokIfNot]- r0  value(219) size (2)
 ; Jump if zero to L219
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L219
jz



 ; {

.section rodata
L222:
.byte 0x31 ; (1)
.byte 0x2e ; (.)
.byte 0x50 ; (P)
.byte 0x61 ; (a)
.byte 0x73 ; (s)
.byte 0x73 ; (s)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L222 puts ) "
 ; Expanded expression: " L222  puts ()2 "
 ; Expression stack:    "( L222 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "367" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "367" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(367) size (2)
ld r0, $(l)L222
ld r1, $(h)L222
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
 ; Unconditional jump to L220
ldd X, $L220
jmp
L219:
 ; else
 ; {

.section rodata
L223:
.byte 0x31 ; (1)
.byte 0x2e ; (.)
.byte 0x46 ; (F)
.byte 0x61 ; (a)
.byte 0x69 ; (i)
.byte 0x6c ; (l)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L223 puts ) "
 ; Expanded expression: " L223  puts ()2 "
 ; Expression stack:    "( L223 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "367" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "367" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(367) size (2)
ld r0, $(l)L223
ld r1, $(h)L223
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L220:
 ; RPN'ized expression: "count 100 = "
 ; Expanded expression: "(@-6) 100 =(2) "
 ; Expression stack:    "(@-6) 100 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "100" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "100" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(100) size (2)
 ; possible optimization - pass size
ld r2, 100
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "count 50 < "
 ; Expanded expression: "(@-6) *(2) 50 < "
 ; Expression stack:    "(@-6) *(2) 50 < IF![224] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "224" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "50" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "224" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "50" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(50) size (2)
 ; possible optimization - pass size
ld r4, 50
ld r5, 0
 ; r0 <-[tokLess]- l-6 r4  value(0) size (2)
ldd X, $L226
tsub r0, l-6, r4
tsbc r1, l-5, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L226:
 ; r0 <-[tokIfNot]- r0  value(224) size (2)
 ; Jump if zero to L224
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L224
jz



 ; {

.section rodata
L227:
.byte 0x32 ; (2)
.byte 0x2e ; (.)
.byte 0x46 ; (F)
.byte 0x61 ; (a)
.byte 0x69 ; (i)
.byte 0x6c ; (l)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L227 puts ) "
 ; Expanded expression: " L227  puts ()2 "
 ; Expression stack:    "( L227 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "367" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "367" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(367) size (2)
ld r0, $(l)L227
ld r1, $(h)L227
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
 ; Unconditional jump to L225
ldd X, $L225
jmp
L224:
 ; else
 ; {

.section rodata
L228:
.byte 0x32 ; (2)
.byte 0x2e ; (.)
.byte 0x50 ; (P)
.byte 0x61 ; (a)
.byte 0x73 ; (s)
.byte 0x73 ; (s)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L228 puts ) "
 ; Expanded expression: " L228  puts ()2 "
 ; Expression stack:    "( L228 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "367" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "367" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(367) size (2)
ld r0, $(l)L228
ld r1, $(h)L228
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L225:
 ; RPN'ized expression: "count 1 -u = "
 ; Expanded expression: "(@-6) -1 =(2) "
 ; Expression stack:    "(@-6) -1 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "-1" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "-1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(-1) size (2)
 ; possible optimization - pass size
ld r2, 255
ld r3, 255
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "count 0 < "
 ; Expanded expression: "(@-6) *(2) 0 < "
 ; Expression stack:    "(@-6) *(2) 0 < IF![229] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "229" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "229" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-6 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokLess]- l-6 r4  value(0) size (2)
ldd X, $L231
tsub r0, l-6, r4
tsbc r1, l-5, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L231:
 ; r0 <-[tokIfNot]- r0  value(229) size (2)
 ; Jump if zero to L229
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L229
jz



 ; {

.section rodata
L232:
.byte 0x33 ; (3)
.byte 0x2e ; (.)
.byte 0x50 ; (P)
.byte 0x61 ; (a)
.byte 0x73 ; (s)
.byte 0x73 ; (s)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L232 puts ) "
 ; Expanded expression: " L232  puts ()2 "
 ; Expression stack:    "( L232 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "367" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "367" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(367) size (2)
ld r0, $(l)L232
ld r1, $(h)L232
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
 ; Unconditional jump to L230
ldd X, $L230
jmp
L229:
 ; else
 ; {

.section rodata
L233:
.byte 0x33 ; (3)
.byte 0x2e ; (.)
.byte 0x46 ; (F)
.byte 0x61 ; (a)
.byte 0x69 ; (i)
.byte 0x6c ; (l)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L233 puts ) "
 ; Expanded expression: " L233  puts ()2 "
 ; Expression stack:    "( L233 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "367" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "367" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(367) size (2)
ld r0, $(l)L233
ld r1, $(h)L233
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L230:
L162:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb main : () void
.section text
main:
.export main
 ; prolog
push XM
movms
SP-=8
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
 ; prolog end


.section rodata
L236:
.byte 0x48 ; (H)
.byte 0x65 ; (e)
.byte 0x6c ; (l)
.byte 0x6c ; (l)
.byte 0x6f ; (o)
.byte 0x20 ; ( )
.byte 0x77 ; (w)
.byte 0x6f ; (o)
.byte 0x72 ; (r)
.byte 0x6c ; (l)
.byte 0x64 ; (d)
.byte 0x21 ; (!)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L236 puts ) "
 ; Expanded expression: " L236  puts ()2 "
 ; Expression stack:    "( L236 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "303" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "303" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(303) size (2)
ld r0, $(l)L236
ld r1, $(h)L236
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L237:
.byte 0x54 ; (T)
.byte 0x68 ; (h)
.byte 0x69 ; (i)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x69 ; (i)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x61 ; (a)
.byte 0x20 ; ( )
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x20 ; ( )
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x67 ; (g)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L237 puts ) "
 ; Expanded expression: " L237  puts ()2 "
 ; Expression stack:    "( L237 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "308" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "308" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(308) size (2)
ld r0, $(l)L237
ld r1, $(h)L237
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; for
 ; loc     i : (@-2) : int
 ; RPN'ized expression: "i 0 = "
 ; Expanded expression: "(@-2) 0 =(2) "
 ; Expression stack:    "(@-2) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



L238:
 ; RPN'ized expression: "i 5 < "
 ; Expanded expression: "(@-2) *(2) 5 < "
 ; Expression stack:    "(@-2) *(2) 5 < IF![241] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "241" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "5" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "241" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "5" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(5) size (2)
 ; possible optimization - pass size
ld r4, 5
ld r5, 0
 ; r0 <-[tokLess]- l-2 r4  value(0) size (2)
ldd X, $L242
tsub r0, l-2, r4
tsbc r1, l-1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L242:
 ; r0 <-[tokIfNot]- r0  value(241) size (2)
 ; Jump if zero to L241
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L241
jz



 ; RPN'ized expression: "i ++ "
 ; Expanded expression: "(@-2) ++(2) "
 ; {
 ; RPN'ized expression: "( i printhex ) "
 ; Expanded expression: " (@-2) *(2)  printhex ()2 "
 ; Expression stack:    "( (@-2) *(2) , printhex )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 016<tokIdent> "205" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "205" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(205) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- l-2 r2  value(2) size (2)
pushw l-2
 ; pushed 1 args
ldd X, $printhex
jmp
popw r0




.section rodata
L243:
.byte 0x3a ; (:)
.byte 0x20 ; ( )
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L243 puts ) "
 ; Expanded expression: " L243  puts ()2 "
 ; Expression stack:    "( L243 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "313" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "313" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(313) size (2)
ld r0, $(l)L243
ld r1, $(h)L243
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



; checkme

 ; RPN'ized expression: "( cmds i + *u puts ) "
 ; Expanded expression: " cmds (@-2) *(2) 2 * + *(2)  puts ()2 "
 ; Expression stack:    "( cmds (@-2) *(2) 2 * + *(2) , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 016<tokIdent> "266" size(0) REG: z0  *
 ;  -  -  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  -  - 001<tokNumInt> "2" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: r0  
 ;  -  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  -  - 016<tokIdent> "266" size(2) REG: r0  *
 ;  -  -  - 004<tokLShift> "0" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "1" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(266) size (2)
ld r0, $(l)cmds
ld r1, $(h)cmds
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLShift]- l-2 r4  value(0) size (2)
tshl r2, l-2, r0
tshlc r3, l-1, r0
 ; r0 <-[tokAdd]- r0 r2  value(0) size (2)
tadd r0, r0, r2
tadc r1, r1, r3
 ; r0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r0
mov A, [X]
mov r0, A
 ; emit_inc_x()
X++
mov A, [X]
mov r1, A
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L244:
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L244 puts ) "
 ; Expanded expression: " L244  puts ()2 "
 ; Expression stack:    "( L244 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "318" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "318" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(318) size (2)
ld r0, $(l)L244
ld r1, $(h)L244
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
L239:
 ; Expression stack:    "(@-2) ++(2) "
 ; Expr tree before optim: 
 ; 012<tokInc> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 012<tokInc> "2" size(2) REG: z0  
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



 ; Unconditional jump to L238
ldd X, $L238
jmp
L241:
hlt


.section rodata
L245:
.byte 0x54 ; (T)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x20 ; ( )
.byte 0x67 ; (g)
.byte 0x65 ; (e)
.byte 0x74 ; (t)
.byte 0x5f ; (_)
.byte 0x63 ; (c)
.byte 0x6d ; (m)
.byte 0x64 ; (d)
.byte 0x5f ; (_)
.byte 0x69 ; (i)
.byte 0x64 ; (d)
.byte 0x78 ; (x)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L245 puts ) "
 ; Expanded expression: " L245  puts ()2 "
 ; Expression stack:    "( L245 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "313" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "313" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(313) size (2)
ld r0, $(l)L245
ld r1, $(h)L245
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L246:
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x3a ; (:)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L246 puts ) "
 ; Expanded expression: " L246  puts ()2 "
 ; Expression stack:    "( L246 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "318" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "318" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(318) size (2)
ld r0, $(l)L246
ld r1, $(h)L246
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L247:
.byte 0x69 ; (i)
.byte 0x6e ; (n)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L247 get_cmd_idx ) "
 ; Expanded expression: " L247  get_cmd_idx ()2 "
 ; Expression stack:    "( L247 , get_cmd_idx )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "323" size(0) REG: z0  *
 ;  - 016<tokIdent> "272" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "323" size(2) REG: r0  *
 ;  - 016<tokIdent> "272" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(323) size (2)
ld r0, $(l)L247
ld r1, $(h)L247
 ; r2 <-[tokIdent]-  value(272) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $get_cmd_idx
jmp
popw r0




.section rodata
L248:
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x31 ; (1)
.byte 0x3a ; (:)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L248 puts ) "
 ; Expanded expression: " L248  puts ()2 "
 ; Expression stack:    "( L248 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "328" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "328" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(328) size (2)
ld r0, $(l)L248
ld r1, $(h)L248
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L249:
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L249 get_cmd_idx ) "
 ; Expanded expression: " L249  get_cmd_idx ()2 "
 ; Expression stack:    "( L249 , get_cmd_idx )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "333" size(0) REG: z0  *
 ;  - 016<tokIdent> "272" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "333" size(2) REG: r0  *
 ;  - 016<tokIdent> "272" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(333) size (2)
ld r0, $(l)L249
ld r1, $(h)L249
 ; r2 <-[tokIdent]-  value(272) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $get_cmd_idx
jmp
popw r0




.section rodata
L250:
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x32 ; (2)
.byte 0x3a ; (:)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L250 puts ) "
 ; Expanded expression: " L250  puts ()2 "
 ; Expression stack:    "( L250 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "338" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "338" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(338) size (2)
ld r0, $(l)L250
ld r1, $(h)L250
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L251:
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L251 get_cmd_idx ) "
 ; Expanded expression: " L251  get_cmd_idx ()2 "
 ; Expression stack:    "( L251 , get_cmd_idx )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "343" size(0) REG: z0  *
 ;  - 016<tokIdent> "272" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "343" size(2) REG: r0  *
 ;  - 016<tokIdent> "272" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(343) size (2)
ld r0, $(l)L251
ld r1, $(h)L251
 ; r2 <-[tokIdent]-  value(272) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $get_cmd_idx
jmp
popw r0




.section rodata
L252:
.byte 0x54 ; (T)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x73 ; (s)
.byte 0x20 ; ( )
.byte 0x64 ; (d)
.byte 0x6f ; (o)
.byte 0x6e ; (n)
.byte 0x65 ; (e)
.byte 0x2e ; (.)
.byte 0x20 ; ( )
.byte 0x48 ; (H)
.byte 0x61 ; (a)
.byte 0x6c ; (l)
.byte 0x74 ; (t)
.byte 0x2e ; (.)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L252 puts ) "
 ; Expanded expression: " L252  puts ()2 "
 ; Expression stack:    "( L252 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "348" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "348" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(348) size (2)
ld r0, $(l)L252
ld r1, $(h)L252
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; loc     cmd_idx : (@-2) : int
 ; while
 ; RPN'ized expression: "1 "
 ; Expanded expression: "1 "
 ; Expression value: 1
L253:
 ; {

.section rodata
L255:
.byte 0x3e ; (>)
.byte 0x20 ; ( )
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L255 puts ) "
 ; Expanded expression: " L255  puts ()2 "
 ; Expression stack:    "( L255 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "362" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "362" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(362) size (2)
ld r0, $(l)L255
ld r1, $(h)L255
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; RPN'ized expression: "( getline ) "
 ; Expanded expression: " getline ()0 "
 ; Expression stack:    "( getline )0 "
 ; Expr tree before optim: 
 ; 041<tokCall> "0" size(0) REG: z0  
 ;  - 016<tokIdent> "226" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "0" size(2) REG: r0  
 ;  - 016<tokIdent> "226" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(226) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0  value(0) size (2)
 ; pushed 0 args
 ; no args, reserve 2 bytes for retval
SP-=2
ldd X, $getline
jmp
popw r0




.section rodata
L256:
.byte 0x0a ; (.)
.byte 0x63 ; (c)
.byte 0x6d ; (m)
.byte 0x64 ; (d)
.byte 0x3a ; (:)
.byte 0x20 ; ( )
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L256 puts ) "
 ; Expanded expression: " L256  puts ()2 "
 ; Expression stack:    "( L256 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "367" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "367" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(367) size (2)
ld r0, $(l)L256
ld r1, $(h)L256
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; RPN'ized expression: "( in_str puts ) "
 ; Expanded expression: " in_str  puts ()2 "
 ; Expression stack:    "( in_str , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "218" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "218" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(218) size (2)
ld r0, $(l)in_str
ld r1, $(h)in_str
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0




.section rodata
L257:
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L257 puts ) "
 ; Expanded expression: " L257  puts ()2 "
 ; Expression stack:    "( L257 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "372" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "372" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(372) size (2)
ld r0, $(l)L257
ld r1, $(h)L257
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; RPN'ized expression: "cmd_idx ( in_str get_cmd_idx ) = "
 ; Expanded expression: "(@-2)  in_str  get_cmd_idx ()2 =(2) "
 ; Expression stack:    "(@-2) ( in_str , get_cmd_idx )2 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 041<tokCall> "2" size(0) REG: z0  
 ;  -  - 016<tokIdent> "218" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "272" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 041<tokCall> "2" size(2) REG: r2  
 ;  -  - 016<tokIdent> "218" size(2) REG: r2  *
 ;  -  - 016<tokIdent> "272" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(218) size (2)
ld r2, $(l)in_str
ld r3, $(h)in_str
 ; r4 <-[tokIdent]-  value(272) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- r2 r4  value(2) size (2)
pushw r2
 ; pushed 1 args
ldd X, $get_cmd_idx
jmp
popw r2
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-2, r2
 ; load to retval
mov r0, A
mov l-1, r3
 ; load to retval
mov r1, A



 ; if
 ; RPN'ized expression: "cmd_idx 0 < "
 ; Expanded expression: "(@-2) *(2) 0 < "
 ; Expression stack:    "(@-2) *(2) 0 < IF![258] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "258" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "258" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokLess]- l-2 r4  value(0) size (2)
ldd X, $L260
tsub r0, l-2, r4
tsbc r1, l-1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L260:
 ; r0 <-[tokIfNot]- r0  value(258) size (2)
 ; Jump if zero to L258
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L258
jz



 ; {

.section rodata
L261:
.byte 0x75 ; (u)
.byte 0x6e ; (n)
.byte 0x6b ; (k)
.byte 0x6e ; (n)
.byte 0x6f ; (o)
.byte 0x77 ; (w)
.byte 0x6e ; (n)
.byte 0x20 ; ( )
.byte 0x63 ; (c)
.byte 0x6f ; (o)
.byte 0x6d ; (m)
.byte 0x6d ; (m)
.byte 0x61 ; (a)
.byte 0x6e ; (n)
.byte 0x64 ; (d)
.byte 0x0a ; (.)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L261 puts ) "
 ; Expanded expression: " L261  puts ()2 "
 ; Expression stack:    "( L261 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "377" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "377" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(377) size (2)
ld r0, $(l)L261
ld r1, $(h)L261
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



 ; }
 ; Unconditional jump to L259
ldd X, $L259
jmp
L258:
 ; else
 ; {
 ; RPN'ized expression: "( funcs cmd_idx + *u ) "
 ; Expanded expression: " funcs (@-2) *(2) 2 * + *(2) ()0 "
 ; Expression stack:    "( funcs (@-2) *(2) 2 * + *(2) )0 "
 ; Expr tree before optim: 
 ; 041<tokCall> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 016<tokIdent> "259" size(0) REG: z0  *
 ;  -  -  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  -  - 001<tokNumInt> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "0" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: r0  
 ;  -  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  -  - 016<tokIdent> "259" size(2) REG: r0  *
 ;  -  -  - 004<tokLShift> "0" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "1" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(259) size (2)
ld r0, $(l)funcs
ld r1, $(h)funcs
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLShift]- l-2 r4  value(0) size (2)
tshl r2, l-2, r0
tshlc r3, l-1, r0
 ; r0 <-[tokAdd]- r0 r2  value(0) size (2)
tadd r0, r0, r2
tadc r1, r1, r3
 ; r0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; deref from non-ident non-local tok : tokAdd suppress 0
movw X, r0
mov A, [X]
mov r0, A
 ; emit_inc_x()
X++
mov A, [X]
mov r1, A
 ; r0 <-[tokCall]- r0  value(0) size (2)
 ; pushed 0 args
 ; no args, reserve 2 bytes for retval
SP-=2
 ; Call not by tokIdent - load address
movw X, r0
jmp
popw r0



 ; }
L259:
 ; }
 ; Unconditional jump to L253
ldd X, $L253
jmp
L254:
hlt

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



L234:
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
 ; Bytes used: 1040/15360


 ; Macro table:
 ; Macro __SMALLER_C__ = `0x0100`
 ; Macro __SMALLER_C_16__ = ``
 ; Macro __SMALLER_C_SCHAR__ = ``
 ; Macro __SMALLER_C_UWCHAR__ = ``
 ; Macro __SMALLER_C_WCHAR16__ = ``
 ; Macro MAX_LENGTH = `127`
 ; Macro N_CMDS = `5`
 ; Bytes used: 136/5120


 ; Identifier table:
 ; Ident 
 ; Ident puts
 ; Ident s
 ; Ident putc
 ; Ident c
 ; Ident getc
 ; Ident isdigit
 ; Ident atoi
 ; Ident strcmp
 ; Ident s1
 ; Ident s2
 ; Ident strcpy
 ; Ident dst
 ; Ident src
 ; Ident strlen
 ; Ident reverse
 ; Ident itoa
 ; Ident n
 ; Ident strncpy
 ; Ident d
 ; Ident l
 ; Ident memset
 ; Ident dest
 ; Ident val
 ; Ident memcpy
 ; Ident memcpy_r
 ; Ident memcmp
 ; Ident mem1
 ; Ident mem2
 ; Ident len
 ; Ident printnum_buffer
 ; Ident printnum
 ; Ident printhex
 ; Ident i
 ; Ident in_str
 ; Ident getline
 ; Ident test_func
 ; Ident test_func_2
 ; Ident funcs
 ; Ident cmds
 ; Ident get_cmd_idx
 ; Ident tests
 ; Ident main
 ; Bytes used: 298/5632

 ; Next label number: 262
 ; Compilation succeeded.
