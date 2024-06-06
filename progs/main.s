
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

 ; glb fxnMul : () int
.section text
fxnMul:
.export fxnMul
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

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



L20:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb fxnMod : () int
.section text
fxnMod:
.export fxnMod
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

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



L22:
 ; epilog
mov a0,r0

mov a1,r1

movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb fxnDiv : () int
.section text
fxnDiv:
.export fxnDiv
 ; prolog
push XM
movms
SP-=8
SP-=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
 ; prolog end

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



L24:
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
L28:
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



 ; Jump if zero to L29
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L29
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
 ;  -  - 016<tokIdent> "35" size(0) REG: r6 SUPPRESSED *

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
 ; r6 <-[tokIdent]-  value(35) size (0)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- l-2 r4 r6  value(0) size (2)
pushw l-2
pushw r4
 ; pushed 2 args
ldd X, $fxnMul
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
 ; Unconditional jump to L28
ldd X, $L28
jmp
L29:
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



L26:
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
 ; RPN'ized expression: "c1 s1 (something32) = "
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
 ; RPN'ized expression: "c2 s2 (something33) = "
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
L34:
 ; {
 ; loc         <something> : int
 ; loc         <something> : int
 ; RPN'ized expression: "d ch c1 ++p *u = (something36) c2 ++p *u (something37) - = "
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
 ; Expanded expression: "(@-8) *(2) _Bool [sh||->40] (@-6) *(1) 0 == ||[40] "
 ; Expression stack:    "(@-8) *(2) _Bool [sh||->40] (@-6) *(1) 0 == ||[40] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 007<tokLogOr> "40" size(0) REG: z0  
 ;  -  - 090<tokShortCirc> "-40" size(0) REG: z0  
 ;  -  -  - 120<tok_Bool> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-8" size(0) REG: z0  *
 ;  -  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 007<tokLogOr> "40" size(2) REG: r0  
 ;  -  - 090<tokShortCirc> "-40" size(2) REG: r0  
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
;;;;;; ; r0 <-[tokShortCirc]- r0  value(-40) size (2)
 ; tokShortCirc
 ; Jump if not zero to L40
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L40
jnz
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(1) size (1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (1)
 ; possible optimization - pass size
ld r4, 0
 ; r0 <-[tokEQ]- l-6 r4  value(0) size (1)
ldd X, $L41
tsub r0, l-6, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L41:
 ; r0 <-[tokInt]- r0  value(0) size (2)
ld A, 0x00
mov r1, A
 ; r0 <-[tokLogOr]- r0 r0  value(40) size (2)
 ; tokLogAndOr
L40:
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L38
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L38
jz
 ; break
 ; Unconditional jump to L35
ldd X, $L35
jmp
L38:
 ; }
 ; Unconditional jump to L34
ldd X, $L34
jmp
L35:
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



L30:
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
L44:
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
L45:
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



 ; Jump if not zero to L44
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L44
jnz
L46:
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



L42:
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
 ; RPN'ized expression: "p s (something49) = "
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
L50:
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



 ; Jump if zero to L51
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L51
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
 ; Unconditional jump to L50
ldd X, $L50
jmp
L51:
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



L47:
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
 ;  -  -  -  - 016<tokIdent> "99" size(0) REG: z0  *
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
 ;  -  -  -  - 016<tokIdent> "99" size(2) REG: r4 SUPPRESSED *
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
 ; r4 <-[tokIdent]-  value(99) size (2)
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



L54:
 ; RPN'ized expression: "i j < "
 ; Expanded expression: "(@-2) *(2) (@-4) *(2) < "
 ; Expression stack:    "(@-2) *(2) (@-4) *(2) < IF![57] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "57" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "57" size(2) REG: r0  
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
ldd X, $L58
tsub r0, l-2, l-4
tsbc r1, l-1, l-3
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L58:
 ; r0 <-[tokIfNot]- r0  value(57) size (2)
 ; Jump if zero to L57
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L57
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
L55:
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



 ; Unconditional jump to L54
ldd X, $L54
jmp
L57:
L52:
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
 ; Expression stack:    "(@4) *(2) 0 < IF![61] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "61" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "61" size(2) REG: r0  
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
ldd X, $L63
tsub r0, a0, r4
tsbc r1, a1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L63:
 ; r0 <-[tokIfNot]- r0  value(61) size (2)
 ; Jump if zero to L61
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L61
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
 ;  - 016<tokIdent> "116" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "4" size(2) REG: r0  
 ;  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r2  *
 ;  - 080<tokUnaryMinus> "0" size(2) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  - 016<tokIdent> "116" size(2) REG: r4 SUPPRESSED *

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
 ; r4 <-[tokIdent]-  value(116) size (2)
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
 ; Unconditional jump to L59
ldd X, $L59
jmp
 ; }
L61:
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
L64:
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
 ;  -  -  -  - 016<tokIdent> "43" size(0) REG: r6 SUPPRESSED *
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
 ; r6 <-[tokIdent]-  value(43) size (0)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- a0 r4 r6  value(0) size (2)
pushw a0
pushw r4
 ; pushed 2 args
ldd X, $fxnMod
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
L65:
 ; Expression stack:    "(@4) 10 /=(2) 0 > IF[64] "
 ; Expr tree before optim: 
 ; 022<tokIf> "64" size(0) REG: z0  
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
 ; 022<tokIf> "64" size(2) REG: r0  
 ;  - 062<tokMore> "0" size(2) REG: r0  
 ;  -  - 061<tokAssign> "2" size(2) REG: r2  
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 041<tokCall> "2" size(2) REG: r4  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r4 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "10" size(2) REG: r6  *
 ;  -  -  -  - 016<tokIdent> "51" size(0) REG: r8 SUPPRESSED *
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
 ; r8 <-[tokIdent]-  value(51) size (0)
 ; !!! emit suppressed
 ; r4 <-[tokCall]- a0 r6 r8  value(2) size (2)
pushw a0
pushw r6
 ; pushed 2 args
ldd X, $fxnDiv
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
ldd X, $L67
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L67:
 ; r0 <-[tokIf]- r0  value(64) size (2)
 ; Jump if not zero to L64
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L64
jnz



L66:
 ; if
 ; RPN'ized expression: "sign 1 == "
 ; Expanded expression: "(@-4) *(2) 1 == "
 ; Expression stack:    "(@-4) *(2) 1 == IF![68] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "68" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "68" size(2) REG: r0  
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
ldd X, $L70
tsub r0, l-4, r4
tsbc r1, l-3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L70:
 ; r0 <-[tokIfNot]- r0  value(68) size (2)
 ; Jump if zero to L68
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L68
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
L68:
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
 ;  - 016<tokIdent> "107" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "107" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(107) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- a2 r2  value(2) size (2)
pushw a2
 ; pushed 1 args
ldd X, $reverse
jmp
popw r0



L59:
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
L73:
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



 ; Jump if zero to L74
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L74
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
 ; Expression stack:    "(@-2) ++p(2) (@-4) ++p(2) *(-1) =(-1) 0 == IF![75] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "75" size(0) REG: z0  
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
 ;  - 076<tokIfNot> "75" size(-1) REG: r0  
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
ldd X, $L77
tsub r0, r2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L77:
 ; r0 <-[tokIfNot]- r0  value(75) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L75
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L75
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
 ; Unconditional jump to L74
ldd X, $L74
jmp
L75:
 ; }
 ; Unconditional jump to L73
ldd X, $L73
jmp
L74:
 ; while
 ; RPN'ized expression: "l --p 0 != "
 ; Expanded expression: "(@8) --p(2) 0 != "
L78:
 ; Expression stack:    "(@8) --p(2) 0 != IF![79] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "79" size(0) REG: z0  
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
 ;  - 076<tokIfNot> "79" size(2) REG: r0  
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
ldd X, $L80
tsub r0, a4, r4
tsbc r1, a5, r5
ld r1, 0
ld r0, 0
jz
ld r0, 1
; --- end of comparison:
L80:
 ; r0 <-[tokIfNot]- r0  value(79) size (2)
 ; Jump if zero to L79
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L79
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



 ; Unconditional jump to L78
ldd X, $L78
jmp
L79:
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



L71:
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
L83:
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



 ; Jump if zero to L84
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L84
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
 ; Unconditional jump to L83
ldd X, $L83
jmp
L84:
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



L81:
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
L87:
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



 ; Jump if zero to L88
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L88
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
 ; Unconditional jump to L87
ldd X, $L87
jmp
L88:
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



L85:
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
L91:
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



 ; Jump if zero to L92
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L92
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
 ; Unconditional jump to L91
ldd X, $L91
jmp
L92:
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



L89:
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
 ; Expression stack:    "(@8) *(2) 0 == IF![95] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "95" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "8" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "95" size(2) REG: r0  
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
ldd X, $L97
tsub r0, a4, r4
tsbc r1, a5, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L97:
 ; r0 <-[tokIfNot]- r0  value(95) size (2)
 ; Jump if zero to L95
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L95
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



 ; Unconditional jump to L93
ldd X, $L93
jmp
L95:
 ; while
 ; RPN'ized expression: "len -- p1 *u p2 *u == && "
 ; Expanded expression: "(@8) --(2) _Bool [sh&&->100] (@-2) *(2) *(-1) (@-4) *(2) *(-1) == &&[100] "
L98:
 ; Expression stack:    "(@8) --(2) _Bool [sh&&->100] (@-2) *(2) *(-1) (@-4) *(2) *(-1) == &&[100] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 006<tokLogAnd> "100" size(0) REG: z0  
 ;  -  - 090<tokShortCirc> "100" size(0) REG: z0  
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
 ;  - 006<tokLogAnd> "100" size(2) REG: r0  
 ;  -  - 090<tokShortCirc> "100" size(2) REG: r0  
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
;;;;;; ; r0 <-[tokShortCirc]- r0  value(100) size (2)
 ; tokShortCirc
 ; Jump if zero to L100
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L100
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
ldd X, $L101
tsub r0, r2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L101:
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokLogAnd]- r0 r0  value(100) size (2)
 ; tokLogAndOr
L100:
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L99
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L99
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
 ; Unconditional jump to L98
ldd X, $L98
jmp
L99:
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



L93:
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
 ;  -  - 016<tokIdent> "202" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "7" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(2) REG: r2  
 ;  -  - 016<tokIdent> "202" size(2) REG: r2  *
 ;  -  - 001<tokNumInt> "7" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(202) size (2)
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
 ; Expression stack:    "(@4) *(2) 0 == IF![104] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "104" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "104" size(2) REG: r0  
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
ldd X, $L106
tsub r0, a0, r4
tsbc r1, a1, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L106:
 ; r0 <-[tokIfNot]- r0  value(104) size (2)
 ; Jump if zero to L104
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L104
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
L104:
 ; if
 ; RPN'ized expression: "n 0 < "
 ; Expanded expression: "(@4) *(2) 0 < "
 ; Expression stack:    "(@4) *(2) 0 < IF![107] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "107" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "107" size(2) REG: r0  
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
ldd X, $L109
tsub r0, a0, r4
tsbc r1, a1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L109:
 ; r0 <-[tokIfNot]- r0  value(107) size (2)
 ; Jump if zero to L107
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L107
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
L107:
 ; while
 ; RPN'ized expression: "n "
 ; Expanded expression: "(@4) *(2) "
L110:
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



 ; Jump if zero to L111
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L111
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
 ;  -  - 016<tokIdent> "43" size(0) REG: r6 SUPPRESSED *

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
 ; r6 <-[tokIdent]-  value(43) size (0)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- a0 r4 r6  value(0) size (2)
pushw a0
pushw r4
 ; pushed 2 args
ldd X, $fxnMod
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
 ;  -  - 016<tokIdent> "51" size(0) REG: r6 SUPPRESSED *

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
 ; r6 <-[tokIdent]-  value(51) size (0)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- a0 r4 r6  value(0) size (2)
pushw a0
pushw r4
 ; pushed 2 args
ldd X, $fxnDiv
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
 ; Unconditional jump to L110
ldd X, $L110
jmp
L111:
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



 ; Jump if zero to L112
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L112
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
L112:
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



L102:
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
 ; Expression stack:    "(@-14) *(-1) 9 > IF![122] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "122" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "9" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "122" size(-1) REG: r0  
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
ldd X, $L124
tsub r0, l-14, r4
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L124:
 ; r0 <-[tokIfNot]- r0  value(122) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L122
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L122
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
 ; Unconditional jump to L123
ldd X, $L123
jmp
L122:
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
L123:
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
 ; Expression stack:    "(@-14) *(-1) 9 > IF![125] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "125" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "9" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "125" size(-1) REG: r0  
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
ldd X, $L127
tsub r0, l-14, r4
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L127:
 ; r0 <-[tokIfNot]- r0  value(125) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L125
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L125
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
 ; Unconditional jump to L126
ldd X, $L126
jmp
L125:
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
L126:
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



L114:
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
 ;  - 016<tokIdent> "242" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "242" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(242) size (2)
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
L130:
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
 ; Expression stack:    "(@-2) *(-1) 0 == IF![132] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "132" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "132" size(-1) REG: r0  
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
ldd X, $L134
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L134:
 ; r0 <-[tokIfNot]- r0  value(132) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L132
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L132
jz



 ; continue
 ; Unconditional jump to L130
ldd X, $L130
jmp
L132:
 ; if
 ; RPN'ized expression: "c 10 == c 13 == || "
 ; Expanded expression: "(@-2) *(-1) 10 == [sh||->137] (@-2) *(-1) 13 == ||[137] "
 ; Expression stack:    "(@-2) *(-1) 10 == [sh||->137] (@-2) *(-1) 13 == ||[137] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 007<tokLogOr> "137" size(0) REG: z0  
 ;  -  - 090<tokShortCirc> "-137" size(0) REG: z0  
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
 ;  -  - 007<tokLogOr> "137" size(-1) REG: r0  
 ;  -  -  - 090<tokShortCirc> "-137" size(-1) REG: r0  
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
ldd X, $L138
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L138:
 ; r0 <-[tokShortCirc]- r0  value(-137) size (-1)
 ; tokShortCirc
 ; Jump if not zero to L137
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L137
jnz
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(13) size (-1)
 ; possible optimization - pass size
ld r4, 13
 ; r0 <-[tokEQ]- l-2 r4  value(0) size (-1)
ldd X, $L139
tsub r0, l-2, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L139:
 ; r0 <-[tokLogOr]- r0 r0  value(137) size (-1)
 ; tokLogAndOr
L137:
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L135
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L135
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
 ; Unconditional jump to L128
ldd X, $L128
jmp
 ; }
 ; Unconditional jump to L136
ldd X, $L136
jmp
L135:
 ; else
 ; {
 ; if
 ; RPN'ized expression: "count 127 1 - < "
 ; Expanded expression: "(@-4) *(2) 126 < "
 ; Expression stack:    "(@-4) *(2) 126 < IF![140] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "140" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "126" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "140" size(2) REG: r0  
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
ldd X, $L142
tsub r0, l-4, r4
tsbc r1, l-3, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L142:
 ; r0 <-[tokIfNot]- r0  value(140) size (2)
 ; Jump if zero to L140
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L140
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
L140:
 ; }
L136:
 ; }
 ; Unconditional jump to L130
ldd X, $L130
jmp
L131:
L128:
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
L145:
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
 ; RPN'ized expression: "( L145 puts ) "
 ; Expanded expression: " L145  puts ()2 "
 ; Expression stack:    "( L145 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "275" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "275" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(275) size (2)
ld r0, $(l)L145
ld r1, $(h)L145
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



L143:
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
L148:
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
 ; RPN'ized expression: "( L148 puts ) "
 ; Expanded expression: " L148  puts ()2 "
 ; Expression stack:    "( L148 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "288" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "288" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(288) size (2)
ld r0, $(l)L148
ld r1, $(h)L148
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
pushw r0
 ; pushed 1 args
ldd X, $puts
jmp
popw r0



L146:
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
L149:
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section data
 ; RPN'ized expression: "L149 "
 ; Expanded expression: "L149 "
 ; GenAddrData
.word $L149

.section rodata
L150:
.byte 0x74 ; (t)
.byte 0x65 ; (e)
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section data
 ; RPN'ized expression: "L150 "
 ; Expanded expression: "L150 "
 ; GenAddrData
.word $L150

.section rodata
L151:
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
 ; RPN'ized expression: "L151 "
 ; Expanded expression: "L151 "
 ; GenAddrData
.word $L151

.section rodata
L152:
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
 ; RPN'ized expression: "L152 "
 ; Expanded expression: "L152 "
 ; GenAddrData
.word $L152

.section rodata
L153:
.byte 0x66 ; (f)
.byte 0x69 ; (i)
.byte 0x66 ; (f)
.byte 0x74 ; (t)
.byte 0x68 ; (h)
.byte 0x00 ; (NUL)
.skip 1

.section data
 ; RPN'ized expression: "L153 "
 ; Expanded expression: "L153 "
 ; GenAddrData
.word $L153

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



L156:
 ; RPN'ized expression: "i 5 < "
 ; Expanded expression: "(@-2) *(2) 5 < "
 ; Expression stack:    "(@-2) *(2) 5 < IF![159] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "159" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "5" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "159" size(2) REG: r0  
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
ldd X, $L160
tsub r0, l-2, r4
tsbc r1, l-1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L160:
 ; r0 <-[tokIfNot]- r0  value(159) size (2)
 ; Jump if zero to L159
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L159
jz



 ; RPN'ized expression: "i ++p "
 ; Expanded expression: "(@-2) ++p(2) "
 ; {

.section rodata
L161:
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
 ; RPN'ized expression: "( L161 puts ) "
 ; Expanded expression: " L161  puts ()2 "
 ; Expression stack:    "( L161 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "314" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "314" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(314) size (2)
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



 ; RPN'ized expression: "( cmds i + *u puts ) "
 ; Expanded expression: " cmds (@-2) *(2) 2 * + *(2)  puts ()2 "
 ; Expression stack:    "( cmds (@-2) *(2) 2 * + *(2) , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 016<tokIdent> "290" size(0) REG: z0  *
 ;  -  -  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  -  - 001<tokNumInt> "2" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: r0  
 ;  -  - 043<tokAdd> "0" size(2) REG: r0  
 ;  -  -  - 016<tokIdent> "290" size(2) REG: r0  *
 ;  -  -  - 004<tokLShift> "0" size(2) REG: r2  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "1" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(290) size (2)
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
L162:
.byte 0x20 ; ( )
.byte 0x3a ; (:)
.byte 0x20 ; ( )
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L162 puts ) "
 ; Expanded expression: " L162  puts ()2 "
 ; Expression stack:    "( L162 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "319" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "319" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(319) size (2)
ld r0, $(l)L162
ld r1, $(h)L162
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
 ; Expression stack:    "( (@4) *(2) , cmds (@-2) *(2) 2 * + *(2) , strcmp )4 0 == IF![163] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "163" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  -  -  - 016<tokIdent> "290" size(0) REG: z0  *
 ;  -  -  -  -  - 042<tokMul> "0" size(0) REG: z0  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  -  -  -  -  - 001<tokNumInt> "2" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "65" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; Expr tree: 
 ; 076<tokIfNot> "163" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 041<tokCall> "4" size(2) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: r4  
 ;  -  -  -  - 043<tokAdd> "0" size(2) REG: r4  
 ;  -  -  -  -  - 016<tokIdent> "290" size(2) REG: r4  *
 ;  -  -  -  -  - 004<tokLShift> "0" size(2) REG: r6  
 ;  -  -  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r6 SUPPRESSED *
 ;  -  -  -  -  -  - 001<tokNumInt> "1" size(2) REG: r8 SUPPRESSED *
 ;  -  -  - 016<tokIdent> "65" size(2) REG: r6 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokIdent]-  value(290) size (2)
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
 ; r6 <-[tokIdent]-  value(65) size (2)
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
ldd X, $L165
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L165:
 ; r0 <-[tokIfNot]- r0  value(163) size (2)
 ; Jump if zero to L163
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L163
jz



 ; {

.section rodata
L166:
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
 ; RPN'ized expression: "( L166 puts ) "
 ; Expanded expression: " L166  puts ()2 "
 ; Expression stack:    "( L166 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "324" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "324" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(324) size (2)
ld r0, $(l)L166
ld r1, $(h)L166
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



 ; Unconditional jump to L154
ldd X, $L154
jmp
 ; }
 ; Unconditional jump to L164
ldd X, $L164
jmp
L163:
 ; else
 ; {

.section rodata
L167:
.byte 0x66 ; (f)
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
 ;  - 016<tokIdent> "324" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "324" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(324) size (2)
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
L164:
 ; }
L157:
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



 ; Unconditional jump to L156
ldd X, $L156
jmp
L159:
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



L154:
 ; epilog
mov a0,r0

mov a1,r1

SP+=8
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

 ; glb TestStruct_t : struct TestStruct
 ; glb s2 : struct TestStruct
.section bss
s2:
.export s2
.skip 4

 ; glb tests : () void
.section text
tests:
.export tests
 ; prolog
push XM
movms
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



 ; loc     s : (@-6) : struct TestStruct
 ; RPN'ized expression: "s &u field -> *u 4522 = "
 ; Expanded expression: "(@-6) 4522 =(2) "
 ; Expression stack:    "(@-6) 4522 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  - 001<tokNumInt> "4522" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-6" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "4522" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(4522) size (2)
 ; possible optimization - pass size
ld r2, 170
ld r3, 17
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-6, r2
 ; load to retval
mov r0, A
mov l-5, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "s &u field2 -> *u 8891 = "
 ; Expanded expression: "(@-4) 8891 =(2) "
 ; Expression stack:    "(@-4) 8891 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-4" size(0) REG: z0  *
 ;  - 001<tokNumInt> "8891" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "2" size(2) REG: r0  
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "8891" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(8891) size (2)
 ; possible optimization - pass size
ld r2, 187
ld r3, 34
 ; r0 <-[tokAssign]- r0 r2  value(2) size (2)
mov l-4, r2
 ; load to retval
mov r0, A
mov l-3, r3
 ; load to retval
mov r1, A



 ; RPN'ized expression: "s &u field -> *u ++p "
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



;checkme!

 ; RPN'ized expression: "s2 &u field -> *u ++p "
 ; Expanded expression: "s2 0 + ++p(2) "
 ; Expression stack:    "s2 0 + ++p(2) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "2" size(0) REG: z0  
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 016<tokIdent> "77" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
