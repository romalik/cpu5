
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
; adjust by 0, skip
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
 ; prolog end

 ; loc     c : (@4) : char
 ; loc     <something> : * unsigned char
 ; RPN'ized expression: "18435 (something3) *u c = "
 ; Expanded expression: "18435 (@4) *(-1) =(1) "
 ; Expression stack:    "18435 (@4) *(-1) =(1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "1" size(0) REG: z0  
 ;  - 001<tokNumInt> "18435" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "1" size(1) REG: r0  
 ;  - 001<tokNumInt> "18435" size(2) REG: r0  *
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(18435) size (2)
 ; possible optimization - pass size
ld r0, 3
ld r1, 72
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a0  value(1) size (1)
 ; assign to non-ident non-local lvalue
mov A, r0
mov XL, A
mov A, r1
mov XH, A
mov A, a0
mov [X], A
 ; load to retval
mov r0, A



L1:
 ; epilog
mov A,r0
mov a0,A
mov A,r1
mov a1,A
; adjust by 0, skip
movsm
pop MX
jmp
 ; epilog end

 ; end of function 

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
; adjust by 0, skip
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
 ; prolog end

 ; loc     s : (@4) : * char
 ; while
 ; RPN'ized expression: "s *u "
 ; Expanded expression: "(@4) *(2) *(-1) "
L6:
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
mov A, a0
mov XL, A
mov A, a1
mov XH, A
mov A, [X]
mov r0, A
 ; r0 <-[tokInt]- r0  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L7
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L7
jz
 ; {
 ; loc         <something> : * unsigned char
 ; RPN'ized expression: "18435 (something8) *u s *u = "
 ; Expanded expression: "18435 (@4) *(2) *(-1) =(1) "
 ; Expression stack:    "18435 (@4) *(2) *(-1) =(1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "1" size(0) REG: z0  
 ;  - 001<tokNumInt> "18435" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "1" size(1) REG: r0  
 ;  - 001<tokNumInt> "18435" size(2) REG: r0  *
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(18435) size (2)
 ; possible optimization - pass size
ld r0, 3
ld r1, 72
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryStar]- a0  value(-1) size (-1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
mov A, a0
mov XL, A
mov A, a1
mov XH, A
mov A, [X]
mov r2, A
 ; r0 <-[tokAssign]- r0 r2  value(1) size (1)
 ; assign to non-ident non-local lvalue
mov A, r0
mov XL, A
mov A, r1
mov XH, A
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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 043<tokAdd> "2" size(2) REG: a0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; a0 <-[tokAdd]- a0 r2  value(2) size (2)
tadd a0, a0, r2
tadc a1, a1, r3



 ; }
 ; Unconditional jump to L6
ldd X, $L6
jmp
L7:
L4:
 ; epilog
mov A,r0
mov a0,A
mov A,r1
mov a1,A
; adjust by 0, skip
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
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 8
ld A, 8
mov B,A
mov A,SL
sub
mov SL,A
ld A, 0
mov B,A
mov A,SH
sbc
mov SH,A
SP+=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
 ; prolog end

 ; loc     s1 : (@4) : * char
 ; loc     s2 : (@6) : * char
 ; loc     c1 : (@-2) : * unsigned char
 ; loc     <something> : * unsigned char
 ; RPN'ized expression: "c1 s1 (something11) = "
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
mov A, a0
mov l-2, A
 ; load to retval
mov r0, A
mov A, a1
mov l-1, A
 ; load to retval
mov r1, A



 ; loc     c2 : (@-4) : * unsigned char
 ; loc     <something> : * unsigned char
 ; RPN'ized expression: "c2 s2 (something12) = "
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
mov A, a2
mov l-4, A
 ; load to retval
mov r0, A
mov A, a3
mov l-3, A
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
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 001<tokNumInt> "0" size(2) REG: l-8  *

 ; l-8 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld l-8, 0
ld l-7, 0



 ; while
 ; RPN'ized expression: "1 "
 ; Expanded expression: "1 "
 ; Expression value: 1
L13:
 ; {
 ; loc         <something> : int
 ; loc         <something> : int
 ; RPN'ized expression: "d ch c1 ++p *u = (something15) c2 ++p *u (something16) - = "
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
 ; replace assign with kid->next with correct regs
 ; replace assign with kid->next with correct regs
 ; replace assign with kid->next with correct regs
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 254<tokSequential> "0" size(0) REG: r0  
 ;  - 045<tokSub> "0" size(1) REG: l-8  
 ;  -  - 078<tokUnaryStar> "1" size(1) REG: l-6  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  -  - 078<tokUnaryStar> "1" size(1) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r2 SUPPRESSED *
 ;  - 043<tokAdd> "2" size(2) REG: l-2  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r4  *
 ;  - 043<tokAdd> "2" size(2) REG: l-4  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-4 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-4" size(2) REG: r4 SUPPRESSED *
 ;  -  - 001<tokNumInt> "1" size(2) REG: r6  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- l-2  value(1) size (1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
mov A, l-2
mov XL, A
mov A, l-1
mov XH, A
mov A, [X]
mov l-6, A
 ; r2 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokUnaryStar]- l-4  value(1) size (1)
 ; deref from non-ident non-local tok : tokUnaryStar suppress 1
mov A, l-4
mov XL, A
mov A, l-3
mov XH, A
mov A, [X]
mov r2, A
 ; l-8 <-[tokSub]- l-6 r2  value(0) size (1)
tsub l-8, l-6, r2
 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r4, 1
ld r5, 0
 ; l-2 <-[tokAdd]- l-2 r4  value(2) size (2)
tadd l-2, l-2, r4
tadc l-1, l-1, r5
 ; r4 <-[tokLocalOfs]-  value(-4) size (2)
 ; !!! emit suppressed
 ; l-4 <-[tokUnaryStar]- r4  value(2) size (2)
 ; !!! emit suppressed
 ; r6 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r6, 1
ld r7, 0
 ; l-4 <-[tokAdd]- l-4 r6  value(2) size (2)
tadd l-4, l-4, r6
tadc l-3, l-3, r7
 ; r0 <-[tokSequential]- l-8 l-2 l-4  value(0) size (0)
 ; XXX Remove this if no return need
mov A,l-8
mov r0,A
mov A,l-7
mov r1,A
 ; tokSequential



 ; if
 ; RPN'ized expression: "d ch 0 == || "
 ; Expanded expression: "(@-8) *(2) _Bool [sh||->19] (@-6) *(1) 0 == ||[19] "
 ; Expression stack:    "(@-8) *(2) _Bool [sh||->19] (@-6) *(1) 0 == ||[19] return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 007<tokLogOr> "19" size(0) REG: z0  
 ;  -  - 090<tokShortCirc> "-19" size(0) REG: z0  
 ;  -  -  - 120<tok_Bool> "0" size(0) REG: z0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  -  -  - 089<tokLocalOfs> "-8" size(0) REG: z0  *
 ;  -  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-6" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 007<tokLogOr> "19" size(2) REG: r0  
 ;  -  - 090<tokShortCirc> "-19" size(2) REG: r0  
 ;  -  -  - 120<tok_Bool> "0" size(2) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "2" size(2) REG: l-8 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-8" size(2) REG: r0 SUPPRESSED *
 ;  -  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  -  - 008<tokEQ> "0" size(1) REG: r0  
 ;  -  -  -  - 078<tokUnaryStar> "1" size(1) REG: l-6 SUPPRESSED 
 ;  -  -  -  -  - 089<tokLocalOfs> "-6" size(2) REG: r2 SUPPRESSED *
 ;  -  -  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-8) size (2)
 ; !!! emit suppressed
 ; l-8 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tok_Bool]- l-8  value(0) size (2)
; maybe omit it all? Why convert to bool?
; XXX Optimize size!
tor r0, l-8, l-7
ld r1, 0
;;;;;; ; r0 <-[tokShortCirc]- r0  value(-19) size (2)
 ; tokShortCirc
 ; Jump if not zero to L19
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L19
jnz
 ; r2 <-[tokLocalOfs]-  value(-6) size (2)
 ; !!! emit suppressed
 ; l-6 <-[tokUnaryStar]- r2  value(1) size (1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- l-6 r4  value(0) size (1)
ldd X, $L20
tsub r0, l-6, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L20:
 ; r0 <-[tokInt]- r0  value(0) size (2)
ld A, 0x00
mov r1, A
 ; r0 <-[tokLogOr]- r0 r0  value(19) size (2)
 ; tokLogAndOr
L19:
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L17
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L17
jz
 ; break
 ; Unconditional jump to L14
ldd X, $L14
jmp
L17:
 ; }
 ; Unconditional jump to L13
ldd X, $L13
jmp
L14:
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
mov A,l-8
mov r0,A
mov A,l-7
mov r1,A
 ; tokReturn



L9:
 ; epilog
mov A,r0
mov a0,A
mov A,r1
mov a1,A
SP-=8
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 8
ld A, 8
mov B,A
mov A,SL
add
mov SL,A
ld A, 0
mov B,A
mov A,SH
adc
mov SH,A
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
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 14
ld A, 14
mov B,A
mov A,SL
sub
mov SL,A
ld A, 0
mov B,A
mov A,SH
sbc
mov SH,A
SP+=8
SP+=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 089<tokLocalOfs> "-1" size(2) REG: l-10  *

 ; l-10 <-[tokLocalOfs]-  value(-1) size (2)
 ; localOfs: -1, fix for [m+off] to -16
ld A, 16
mov B,A
mov A,ML
sub
mov l-10,A
ld A, 0
mov B,A
mov A,MH
sbc
mov l-9,A



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
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "0" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r2, 0
ld r3, 0
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 045<tokSub> "2" size(2) REG: l-10  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; l-10 <-[tokSub]- l-10 r2  value(2) size (2)
tsub l-10, l-10, r2
tsbc l-9, l-9, r3



 ; RPN'ized expression: "n i = "
 ; Expanded expression: "(@-14) (@4) *(2) =(-1) "
 ; Expression stack:    "(@-14) (@4) *(2) =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a0  value(-1) size (-1)
mov A, a0
mov l-14, A
 ; load to retval
mov r0, A



 ; if
 ; RPN'ized expression: "n 0 == "
 ; Expanded expression: "(@-14) *(-1) 0 == "
 ; Expression stack:    "(@-14) *(-1) 0 == IF![23] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "23" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "23" size(-1) REG: r0  
 ;  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- l-14 r4  value(0) size (-1)
ldd X, $L25
tsub r0, l-14, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L25:
 ; r0 <-[tokIfNot]- r0  value(23) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L23
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L23
jz



 ; {
 ; RPN'ized expression: "s *u 48 = "
 ; Expanded expression: "(@-10) *(2) 48 =(-1) "
 ; Expression stack:    "(@-10) *(2) 48 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "48" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(48) size (2)
 ; possible optimization - pass size
ld r2, 48
ld r3, 0
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 045<tokSub> "2" size(2) REG: l-10  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; l-10 <-[tokSub]- l-10 r2  value(2) size (2)
tsub l-10, l-10, r2
tsbc l-9, l-9, r3



 ; }
L23:
 ; while
 ; RPN'ized expression: "n "
 ; Expanded expression: "(@-14) *(-1) "
L26:
 ; Expression stack:    "(@-14) *(-1) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokInt]- l-14  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L27
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L27
jz
 ; {
 ; RPN'ized expression: "n_rem n 15 & = "
 ; Expanded expression: "(@-12) (@-14) *(-1) 15 & =(-1) "
 ; Expression stack:    "(@-12) (@-14) *(-1) 15 & =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-12" size(0) REG: z0  *
 ;  - 038<tokAnd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "15" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 038<tokAnd> "0" size(-1) REG: l-12  
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "15" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(15) size (2)
 ; possible optimization - pass size
ld r2, 15
ld r3, 0
 ; l-12 <-[tokAnd]- l-14 r2  value(0) size (-1)
tand l-12, l-14, r2



 ; if
 ; RPN'ized expression: "n_rem 9 > "
 ; Expanded expression: "(@-12) *(-1) 9 > "
 ; Expression stack:    "(@-12) *(-1) 9 > IF![28] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "28" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-12" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "9" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "28" size(-1) REG: r0  
 ;  - 062<tokMore> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-12 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-12" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "9" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-12) size (2)
 ; !!! emit suppressed
 ; l-12 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(9) size (2)
 ; possible optimization - pass size
ld r4, 9
ld r5, 0
 ; r0 <-[tokMore]- l-12 r4  value(0) size (-1)
ldd X, $L30
tsub r0, l-12, r4
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L30:
 ; r0 <-[tokIfNot]- r0  value(28) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L28
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L28
jz



 ; {
 ; RPN'ized expression: "s *u n_rem 65 + 10 - = "
 ; Expanded expression: "(@-10) *(2) (@-12) *(-1) 65 + 10 - =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-12) *(-1) 65 + 10 - =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-12" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "65" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "0" size(-1) REG: r2  
 ;  -  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-12 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-12" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "65" size(2) REG: r4  *
 ;  -  - 001<tokNumInt> "10" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-12) size (2)
 ; !!! emit suppressed
 ; l-12 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(65) size (2)
 ; possible optimization - pass size
ld r4, 65
ld r5, 0
 ; r2 <-[tokAdd]- l-12 r4  value(0) size (-1)
tadd r2, l-12, r4
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r2 <-[tokSub]- r2 r4  value(0) size (-1)
tsub r2, r2, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
 ; Unconditional jump to L29
ldd X, $L29
jmp
L28:
 ; else
 ; {
 ; RPN'ized expression: "s *u n_rem 48 + = "
 ; Expanded expression: "(@-10) *(2) (@-12) *(-1) 48 + =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-12) *(-1) 48 + =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-12" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-12 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-12" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "48" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-12) size (2)
 ; !!! emit suppressed
 ; l-12 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(48) size (2)
 ; possible optimization - pass size
ld r4, 48
ld r5, 0
 ; r2 <-[tokAdd]- l-12 r4  value(0) size (-1)
tadd r2, l-12, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
L29:
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
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 005<tokRShift> "0" size(-1) REG: l-14  
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "4" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(4) size (2)
 ; possible optimization - pass size
ld r2, 4
ld r3, 0
 ; l-14 <-[tokRShift]- l-14 r2  value(0) size (-1)
tshr l-14, l-14,  1153140728
tshr l-14, l-14,  1153140728
tshr l-14, l-14,  1153140728
tshr l-14, l-14,  1153140728



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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 045<tokSub> "2" size(2) REG: l-10  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; l-10 <-[tokSub]- l-10 r2  value(2) size (2)
tsub l-10, l-10, r2
tsbc l-9, l-9, r3



 ; }
 ; Unconditional jump to L26
ldd X, $L26
jmp
L27:
 ; RPN'ized expression: "n i 8 >> = "
 ; Expanded expression: "(@-14) (@4) *(2) 8 >> =(-1) "
 ; Expression stack:    "(@-14) (@4) *(2) 8 >> =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  - 005<tokRShift> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "4" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "8" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 005<tokRShift> "0" size(2) REG: l-14  
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "8" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(8) size (2)
 ; possible optimization - pass size
ld r2, 8
ld r3, 0
 ; l-14 <-[tokRShift]- a0 r2  value(0) size (2)
mov A, a1
mov l-14, A
ld A,0
mov l-13, A



 ; if
 ; RPN'ized expression: "n 0 == "
 ; Expanded expression: "(@-14) *(-1) 0 == "
 ; Expression stack:    "(@-14) *(-1) 0 == IF![31] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "31" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "31" size(-1) REG: r0  
 ;  - 008<tokEQ> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- l-14 r4  value(0) size (-1)
ldd X, $L33
tsub r0, l-14, r4
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L33:
 ; r0 <-[tokIfNot]- r0  value(31) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L31
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L31
jz



 ; {
 ; RPN'ized expression: "s *u 48 = "
 ; Expanded expression: "(@-10) *(2) 48 =(-1) "
 ; Expression stack:    "(@-10) *(2) 48 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "48" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(48) size (2)
 ; possible optimization - pass size
ld r2, 48
ld r3, 0
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 045<tokSub> "2" size(2) REG: l-10  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; l-10 <-[tokSub]- l-10 r2  value(2) size (2)
tsub l-10, l-10, r2
tsbc l-9, l-9, r3



 ; }
L31:
 ; while
 ; RPN'ized expression: "n "
 ; Expanded expression: "(@-14) *(-1) "
L34:
 ; Expression stack:    "(@-14) *(-1) return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 019<tokInt> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r0 <-[tokInt]- l-14  value(0) size (2)
 ; XXX DO PROPER SIGN EXTEND HERE
ld A, 0x00
mov r1, A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L35
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L35
jz
 ; {
 ; RPN'ized expression: "n_rem n 15 & = "
 ; Expanded expression: "(@-12) (@-14) *(-1) 15 & =(-1) "
 ; Expression stack:    "(@-12) (@-14) *(-1) 15 & =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-12" size(0) REG: z0  *
 ;  - 038<tokAnd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-14" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "15" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 038<tokAnd> "0" size(-1) REG: l-12  
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "15" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(15) size (2)
 ; possible optimization - pass size
ld r2, 15
ld r3, 0
 ; l-12 <-[tokAnd]- l-14 r2  value(0) size (-1)
tand l-12, l-14, r2



 ; if
 ; RPN'ized expression: "n_rem 9 > "
 ; Expanded expression: "(@-12) *(-1) 9 > "
 ; Expression stack:    "(@-12) *(-1) 9 > IF![36] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "36" size(0) REG: z0  
 ;  - 062<tokMore> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-12" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "9" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "36" size(-1) REG: r0  
 ;  - 062<tokMore> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-12 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-12" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "9" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-12) size (2)
 ; !!! emit suppressed
 ; l-12 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(9) size (2)
 ; possible optimization - pass size
ld r4, 9
ld r5, 0
 ; r0 <-[tokMore]- l-12 r4  value(0) size (-1)
ldd X, $L38
tsub r0, l-12, r4
ld r0, 0
jle
ld r0, 1
; --- end of comparison:
L38:
 ; r0 <-[tokIfNot]- r0  value(36) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L36
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L36
jz



 ; {
 ; RPN'ized expression: "s *u n_rem 65 + 10 - = "
 ; Expanded expression: "(@-10) *(2) (@-12) *(-1) 65 + 10 - =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-12) *(-1) 65 + 10 - =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 045<tokSub> "0" size(0) REG: z0  
 ;  -  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  -  - 089<tokLocalOfs> "-12" size(0) REG: z0  *
 ;  -  -  - 001<tokNumInt> "65" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 045<tokSub> "0" size(-1) REG: r2  
 ;  -  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-12 SUPPRESSED 
 ;  -  -  -  - 089<tokLocalOfs> "-12" size(2) REG: r2 SUPPRESSED *
 ;  -  -  - 001<tokNumInt> "65" size(2) REG: r4  *
 ;  -  - 001<tokNumInt> "10" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-12) size (2)
 ; !!! emit suppressed
 ; l-12 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(65) size (2)
 ; possible optimization - pass size
ld r4, 65
ld r5, 0
 ; r2 <-[tokAdd]- l-12 r4  value(0) size (-1)
tadd r2, l-12, r4
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r2 <-[tokSub]- r2 r4  value(0) size (-1)
tsub r2, r2, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
 ; Unconditional jump to L37
ldd X, $L37
jmp
L36:
 ; else
 ; {
 ; RPN'ized expression: "s *u n_rem 48 + = "
 ; Expanded expression: "(@-10) *(2) (@-12) *(-1) 48 + =(-1) "
 ; Expression stack:    "(@-10) *(2) (@-12) *(-1) 48 + =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 043<tokAdd> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-12" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 043<tokAdd> "0" size(-1) REG: r2  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-12 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-12" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "48" size(2) REG: r4  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokLocalOfs]-  value(-12) size (2)
 ; !!! emit suppressed
 ; l-12 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(48) size (2)
 ; possible optimization - pass size
ld r4, 48
ld r5, 0
 ; r2 <-[tokAdd]- l-12 r4  value(0) size (-1)
tadd r2, l-12, r4
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
mov A, r2
mov [X], A
 ; load to retval
mov r0, A



 ; }
L37:
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
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 005<tokRShift> "0" size(-1) REG: l-14  
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: l-14 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-14" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "4" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-14) size (2)
 ; !!! emit suppressed
 ; l-14 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(4) size (2)
 ; possible optimization - pass size
ld r2, 4
ld r3, 0
 ; l-14 <-[tokRShift]- l-14 r2  value(0) size (-1)
tshr l-14, l-14,  1153140728
tshr l-14, l-14,  1153140728
tshr l-14, l-14,  1153140728
tshr l-14, l-14,  1153140728



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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 045<tokSub> "2" size(2) REG: l-10  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; l-10 <-[tokSub]- l-10 r2  value(2) size (2)
tsub l-10, l-10, r2
tsbc l-9, l-9, r3



 ; }
 ; Unconditional jump to L34
ldd X, $L34
jmp
L35:
 ; RPN'ized expression: "s *u 120 = "
 ; Expanded expression: "(@-10) *(2) 120 =(-1) "
 ; Expression stack:    "(@-10) *(2) 120 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 001<tokNumInt> "120" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "120" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(120) size (2)
 ; possible optimization - pass size
ld r2, 120
ld r3, 0
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 045<tokSub> "2" size(2) REG: l-10  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; l-10 <-[tokSub]- l-10 r2  value(2) size (2)
tsub l-10, l-10, r2
tsbc l-9, l-9, r3



 ; RPN'ized expression: "s *u 48 = "
 ; Expanded expression: "(@-10) *(2) 48 =(-1) "
 ; Expression stack:    "(@-10) *(2) 48 =(-1) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "-1" size(0) REG: z0  
 ;  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  - 089<tokLocalOfs> "-10" size(0) REG: z0  *
 ;  - 001<tokNumInt> "48" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 061<tokAssign> "-1" size(-1) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "48" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(48) size (2)
 ; possible optimization - pass size
ld r2, 48
ld r3, 0
 ; r0 <-[tokAssign]- l-10 r2  value(-1) size (-1)
 ; assign to non-ident non-local lvalue
mov A, l-10
mov XL, A
mov A, l-9
mov XH, A
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
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-10 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-10" size(2) REG: r0 SUPPRESSED *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-10) size (2)
 ; !!! emit suppressed
 ; l-10 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- l-10 r2  value(2) size (2)
mov A, l-9
push A
mov A, l-10
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



L21:
 ; epilog
mov A,r0
mov a0,A
mov A,r1
mov a1,A
SP-=8
SP-=8
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 14
ld A, 14
mov B,A
mov A,SL
add
mov SL,A
ld A, 0
mov B,A
mov A,SH
adc
mov SH,A
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
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 2
ld A, 2
mov B,A
mov A,SL
sub
mov SL,A
ld A, 0
mov B,A
mov A,SH
sbc
mov SH,A
SP+=8
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
 ; prolog end


.section rodata
L41:
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
 ; RPN'ized expression: "( L41 puts ) "
 ; Expanded expression: " L41  puts ()2 "
 ; Expression stack:    "( L41 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "60" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "60" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(60) size (2)
ldd X, $L41
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; for
 ; loc     i : (@-2) : char
 ; RPN'ized expression: "i 0 = "
 ; Expanded expression: "(@-2) 0 =(-1) "
 ; Expression stack:    "(@-2) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 001<tokNumInt> "0" size(2) REG: l-2  *

 ; l-2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld l-2, 0
ld l-1, 0



L42:
 ; RPN'ized expression: "i 10 < "
 ; Expanded expression: "(@-2) *(-1) 10 < "
 ; Expression stack:    "(@-2) *(-1) 10 < IF![45] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "45" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "45" size(-1) REG: r0  
 ;  - 060<tokLess> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "10" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r0 <-[tokLess]- l-2 r4  value(0) size (-1)
ldd X, $L46
tsub r0, l-2, r4
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L46:
 ; r0 <-[tokIfNot]- r0  value(45) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L45
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L45
jz



 ; RPN'ized expression: "i ++p "
 ; Expanded expression: "(@-2) ++p(-1) "
 ; {
 ; if
 ; RPN'ized expression: "i 5 < "
 ; Expanded expression: "(@-2) *(-1) 5 < "
 ; Expression stack:    "(@-2) *(-1) 5 < IF![47] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "47" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "5" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "47" size(-1) REG: r0  
 ;  - 060<tokLess> "0" size(-1) REG: r0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "5" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(-1) size (-1)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(5) size (2)
 ; possible optimization - pass size
ld r4, 5
ld r5, 0
 ; r0 <-[tokLess]- l-2 r4  value(0) size (-1)
ldd X, $L49
tsub r0, l-2, r4
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L49:
 ; r0 <-[tokIfNot]- r0  value(47) size (-1)
 ; !!!!! XXX QUICK HACK
ld A,0
mov r1,A
 ; Jump if zero to L47
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L47
jz



 ; {
 ; RPN'ized expression: "( 65 putc ) "
 ; Expanded expression: " 65  putc ()2 "
 ; Expression stack:    "( 65 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "65" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "65" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(65) size (2)
 ; possible optimization - pass size
ld r0, 65
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
 ; Unconditional jump to L48
ldd X, $L48
jmp
L47:
 ; else
 ; {
 ; RPN'ized expression: "( 66 putc ) "
 ; Expanded expression: " 66  putc ()2 "
 ; Expression stack:    "( 66 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "66" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "66" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(66) size (2)
 ; possible optimization - pass size
ld r0, 66
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
L48:
 ; }
L43:
 ; Expression stack:    "(@-2) ++p(-1) "
 ; Expr tree before optim: 
 ; 081<tokPostInc> "-1" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ; Found tokPostInc/Dec/Add/Sub
 ; 081<tokPostInc> "-1" size(-1) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(2) REG: z0  *
 ; After replace
 ; 061<tokAssign> "-1" size(-1) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(-1) REG: z0  *
 ;  - 043<tokAdd> "-1" size(-1) REG: z0  
 ;  -  - 078<tokUnaryStar> "-1" size(-1) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(-1) REG: z0  *
 ;  -  - 001<tokNumInt> "1" size(-1) REG: z0  *
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 043<tokAdd> "-1" size(-1) REG: l-2  
 ;  - 078<tokUnaryStar> "-1" size(-1) REG: l-2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-2" size(-1) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(-1) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (-1)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(-1) size (-1)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (-1)
 ; possible optimization - pass size
ld r2, 1
 ; l-2 <-[tokAdd]- l-2 r2  value(-1) size (-1)
tadd l-2, l-2, r2



 ; Unconditional jump to L42
ldd X, $L42
jmp
L45:
 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; for
 ; loc     i : (@-2) : int
 ; RPN'ized expression: "i 0 = "
 ; Expanded expression: "(@-2) 0 =(2) "
 ; Expression stack:    "(@-2) 0 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 001<tokNumInt> "0" size(2) REG: l-2  *

 ; l-2 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld l-2, 0
ld l-1, 0



L50:
 ; RPN'ized expression: "i 10 < "
 ; Expanded expression: "(@-2) *(2) 10 < "
 ; Expression stack:    "(@-2) *(2) 10 < IF![53] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "53" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "53" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "10" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r4, 10
ld r5, 0
 ; r0 <-[tokLess]- l-2 r4  value(0) size (2)
ldd X, $L54
tsub r0, l-2, r4
tsbc r1, l-1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L54:
 ; r0 <-[tokIfNot]- r0  value(53) size (2)
 ; Jump if zero to L53
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L53
jz



 ; RPN'ized expression: "i ++p "
 ; Expanded expression: "(@-2) ++p(2) "
 ; {
 ; if
 ; RPN'ized expression: "i 5 < "
 ; Expanded expression: "(@-2) *(2) 5 < "
 ; Expression stack:    "(@-2) *(2) 5 < IF![55] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "55" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "5" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "55" size(2) REG: r0  
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
ldd X, $L57
tsub r0, l-2, r4
tsbc r1, l-1, r5
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
 ; RPN'ized expression: "( 65 putc ) "
 ; Expanded expression: " 65  putc ()2 "
 ; Expression stack:    "( 65 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "65" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "65" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(65) size (2)
 ; possible optimization - pass size
ld r0, 65
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
 ; Unconditional jump to L56
ldd X, $L56
jmp
L55:
 ; else
 ; {
 ; RPN'ized expression: "( 66 putc ) "
 ; Expanded expression: " 66  putc ()2 "
 ; Expression stack:    "( 66 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "66" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "66" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(66) size (2)
 ; possible optimization - pass size
ld r0, 66
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
L56:
 ; }
L51:
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
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 043<tokAdd> "2" size(2) REG: l-2  
 ;  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "-2" size(2) REG: r0 SUPPRESSED *
 ;  - 001<tokNumInt> "1" size(2) REG: r2  *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r0  value(2) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokNumInt]-  value(1) size (2)
 ; possible optimization - pass size
ld r2, 1
ld r3, 0
 ; l-2 <-[tokAdd]- l-2 r2  value(2) size (2)
tadd l-2, l-2, r2
tadc l-1, l-1, r3



 ; Unconditional jump to L50
ldd X, $L50
jmp
L53:
 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip




.section rodata
L58:
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
 ; RPN'ized expression: "( L58 puts ) "
 ; Expanded expression: " L58  puts ()2 "
 ; Expression stack:    "( L58 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "64" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "64" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(64) size (2)
ldd X, $L58
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; RPN'ized expression: "( 4660 printhex ) "
 ; Expanded expression: " 4660  printhex ()2 "
 ; Expression stack:    "( 4660 , printhex )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "4660" size(0) REG: z0  *
 ;  - 016<tokIdent> "36" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "4660" size(2) REG: r0  *
 ;  - 016<tokIdent> "36" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(4660) size (2)
 ; possible optimization - pass size
ld r0, 52
ld r1, 18
 ; r2 <-[tokIdent]-  value(36) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $printhex
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip




.section rodata
L59:
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
 ; RPN'ized expression: "( L59 puts ) "
 ; Expanded expression: " L59  puts ()2 "
 ; Expression stack:    "( L59 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "68" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "68" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(68) size (2)
ldd X, $L59
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip




.section rodata
L60:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section text

.section rodata
L61:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( ( L61 , L60 strcmp ) printhex ) "
 ; Expanded expression: "  L61  L60  strcmp ()4  printhex ()2 "
 ; Expression stack:    "( ( L61 , L60 , strcmp )4 , printhex )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  - 016<tokIdent> "76" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "72" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "20" size(0) REG: z0  *
 ;  - 016<tokIdent> "36" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 041<tokCall> "4" size(2) REG: r0  
 ;  -  - 016<tokIdent> "76" size(2) REG: r0  *
 ;  -  - 016<tokIdent> "72" size(2) REG: r2  *
 ;  -  - 016<tokIdent> "20" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "36" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(76) size (2)
ldd X, $L61
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(72) size (2)
ldd X, $L60
mov A, XL
mov r2, A
mov A, XH
mov r3, A
 ; r4 <-[tokIdent]-  value(20) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2 r4  value(4) size (2)
mov A, r1
push A
mov A, r0
push A
mov A, r3
push A
mov A, r2
push A
 ; pushed 2 args
ldd X, $strcmp
jmp
pop A
mov r0,A
pop A
mov r1,A
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 2
ld A, 2
mov B,A
mov A,SL
add
mov SL,A
ld A, 0
mov B,A
mov A,SH
adc
mov SH,A
 ; r2 <-[tokIdent]-  value(36) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $printhex
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip




.section rodata
L62:
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
 ; RPN'ized expression: "( L62 puts ) "
 ; Expanded expression: " L62  puts ()2 "
 ; Expression stack:    "( L62 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "80" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "80" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(80) size (2)
ldd X, $L62
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip




.section rodata
L63:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x33 ; (3)
.byte 0x00 ; (NUL)
.skip 1

.section text

.section rodata
L64:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x33 ; (3)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( ( L64 , L63 strcmp ) printhex ) "
 ; Expanded expression: "  L64  L63  strcmp ()4  printhex ()2 "
 ; Expression stack:    "( ( L64 , L63 , strcmp )4 , printhex )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  - 016<tokIdent> "88" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "84" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "20" size(0) REG: z0  *
 ;  - 016<tokIdent> "36" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 041<tokCall> "4" size(2) REG: r0  
 ;  -  - 016<tokIdent> "88" size(2) REG: r0  *
 ;  -  - 016<tokIdent> "84" size(2) REG: r2  *
 ;  -  - 016<tokIdent> "20" size(2) REG: r4 SUPPRESSED *
 ;  - 016<tokIdent> "36" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(88) size (2)
ldd X, $L64
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(84) size (2)
ldd X, $L63
mov A, XL
mov r2, A
mov A, XH
mov r3, A
 ; r4 <-[tokIdent]-  value(20) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2 r4  value(4) size (2)
mov A, r1
push A
mov A, r0
push A
mov A, r3
push A
mov A, r2
push A
 ; pushed 2 args
ldd X, $strcmp
jmp
pop A
mov r0,A
pop A
mov r1,A
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 2
ld A, 2
mov B,A
mov A,SL
add
mov SL,A
ld A, 0
mov B,A
mov A,SH
adc
mov SH,A
 ; r2 <-[tokIdent]-  value(36) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $printhex
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; RPN'ized expression: "( 10 putc ) "
 ; Expanded expression: " 10  putc ()2 "
 ; Expression stack:    "( 10 , putc )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ;  - 016<tokIdent> "2" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 001<tokNumInt> "10" size(2) REG: r0  *
 ;  - 016<tokIdent> "2" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld r0, 10
ld r1, 0
 ; r2 <-[tokIdent]-  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $putc
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; if

.section rodata
L67:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section text

.section rodata
L68:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L68 , L67 strcmp ) 0 == "
 ; Expanded expression: " L68  L67  strcmp ()4 0 == "
 ; Expression stack:    "( L68 , L67 , strcmp )4 0 == IF![65] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "65" size(0) REG: z0  
 ;  - 008<tokEQ> "0" size(0) REG: z0  
 ;  -  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  -  - 016<tokIdent> "96" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "92" size(0) REG: z0  *
 ;  -  -  - 016<tokIdent> "20" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "65" size(2) REG: r0  
 ;  - 008<tokEQ> "0" size(2) REG: r0  
 ;  -  - 041<tokCall> "4" size(2) REG: r2  
 ;  -  -  - 016<tokIdent> "96" size(2) REG: r2  *
 ;  -  -  - 016<tokIdent> "92" size(2) REG: r4  *
 ;  -  -  - 016<tokIdent> "20" size(2) REG: r6 SUPPRESSED *
 ;  -  - 001<tokNumInt> "0" size(2) REG: r4  *

 ; r2 <-[tokIdent]-  value(96) size (2)
ldd X, $L68
mov A, XL
mov r2, A
mov A, XH
mov r3, A
 ; r4 <-[tokIdent]-  value(92) size (2)
ldd X, $L67
mov A, XL
mov r4, A
mov A, XH
mov r5, A
 ; r6 <-[tokIdent]-  value(20) size (2)
 ; !!! emit suppressed
 ; r2 <-[tokCall]- r2 r4 r6  value(4) size (2)
mov A, r3
push A
mov A, r2
push A
mov A, r5
push A
mov A, r4
push A
 ; pushed 2 args
ldd X, $strcmp
jmp
pop A
mov r2,A
pop A
mov r3,A
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 2
ld A, 2
mov B,A
mov A,SL
add
mov SL,A
ld A, 0
mov B,A
mov A,SH
adc
mov SH,A
 ; r4 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r4, 0
ld r5, 0
 ; r0 <-[tokEQ]- r2 r4  value(0) size (2)
ldd X, $L69
tsub r0, r2, r4
tsbc r1, r3, r5
ld r1, 0
ld r0, 0
jnz
ld r0, 1
; --- end of comparison:
L69:
 ; r0 <-[tokIfNot]- r0  value(65) size (2)
 ; Jump if zero to L65
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L65
jz



 ; {

.section rodata
L70:
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
 ; RPN'ized expression: "( L70 puts ) "
 ; Expanded expression: " L70  puts ()2 "
 ; Expression stack:    "( L70 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "100" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "100" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(100) size (2)
ldd X, $L70
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
L65:
 ; if

.section rodata
L73:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x31 ; (1)
.byte 0x00 ; (NUL)
.skip 1

.section text

.section rodata
L74:
.byte 0x73 ; (s)
.byte 0x74 ; (t)
.byte 0x72 ; (r)
.byte 0x32 ; (2)
.byte 0x00 ; (NUL)
.skip 1

.section text
 ; RPN'ized expression: "( L74 , L73 strcmp ) "
 ; Expanded expression: " L74  L73  strcmp ()4 "
 ; Expression stack:    "( L74 , L73 , strcmp )4 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 041<tokCall> "4" size(0) REG: z0  
 ;  -  - 016<tokIdent> "104" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "100" size(0) REG: z0  *
 ;  -  - 016<tokIdent> "20" size(0) REG: z0  *
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 041<tokCall> "4" size(2) REG: r0  
 ;  -  - 016<tokIdent> "104" size(2) REG: r0  *
 ;  -  - 016<tokIdent> "100" size(2) REG: r2  *
 ;  -  - 016<tokIdent> "20" size(2) REG: r4 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(104) size (2)
ldd X, $L74
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(100) size (2)
ldd X, $L73
mov A, XL
mov r2, A
mov A, XH
mov r3, A
 ; r4 <-[tokIdent]-  value(20) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2 r4  value(4) size (2)
mov A, r1
push A
mov A, r0
push A
mov A, r3
push A
mov A, r2
push A
 ; pushed 2 args
ldd X, $strcmp
jmp
pop A
mov r0,A
pop A
mov r1,A
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 2
ld A, 2
mov B,A
mov A,SL
add
mov SL,A
ld A, 0
mov B,A
mov A,SH
adc
mov SH,A
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



 ; Jump if zero to L71
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L71
jz
 ; {

.section rodata
L75:
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
 ; RPN'ized expression: "( L75 puts ) "
 ; Expanded expression: " L75  puts ()2 "
 ; Expression stack:    "( L75 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "108" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "108" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(108) size (2)
ldd X, $L75
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
L71:
 ; loc     count : (@-2) : int
 ; RPN'ized expression: "count 10 = "
 ; Expanded expression: "(@-2) 10 =(2) "
 ; Expression stack:    "(@-2) 10 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "10" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 001<tokNumInt> "10" size(2) REG: l-2  *

 ; l-2 <-[tokNumInt]-  value(10) size (2)
 ; possible optimization - pass size
ld l-2, 10
ld l-1, 0



 ; if
 ; RPN'ized expression: "count 50 < "
 ; Expanded expression: "(@-2) *(2) 50 < "
 ; Expression stack:    "(@-2) *(2) 50 < IF![76] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "76" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "50" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "76" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "50" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(50) size (2)
 ; possible optimization - pass size
ld r4, 50
ld r5, 0
 ; r0 <-[tokLess]- l-2 r4  value(0) size (2)
ldd X, $L78
tsub r0, l-2, r4
tsbc r1, l-1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L78:
 ; r0 <-[tokIfNot]- r0  value(76) size (2)
 ; Jump if zero to L76
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L76
jz



 ; {

.section rodata
L79:
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
 ; RPN'ized expression: "( L79 puts ) "
 ; Expanded expression: " L79  puts ()2 "
 ; Expression stack:    "( L79 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "115" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "115" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(115) size (2)
ldd X, $L79
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
 ; Unconditional jump to L77
ldd X, $L77
jmp
L76:
 ; else
 ; {

.section rodata
L80:
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
 ; RPN'ized expression: "( L80 puts ) "
 ; Expanded expression: " L80  puts ()2 "
 ; Expression stack:    "( L80 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "115" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "115" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(115) size (2)
ldd X, $L80
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
L77:
 ; RPN'ized expression: "count 100 = "
 ; Expanded expression: "(@-2) 100 =(2) "
 ; Expression stack:    "(@-2) 100 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "100" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 001<tokNumInt> "100" size(2) REG: l-2  *

 ; l-2 <-[tokNumInt]-  value(100) size (2)
 ; possible optimization - pass size
ld l-2, 100
ld l-1, 0



 ; if
 ; RPN'ized expression: "count 50 < "
 ; Expanded expression: "(@-2) *(2) 50 < "
 ; Expression stack:    "(@-2) *(2) 50 < IF![81] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "81" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "50" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "81" size(2) REG: r0  
 ;  - 060<tokLess> "0" size(2) REG: r0  
 ;  -  - 078<tokUnaryStar> "2" size(2) REG: l-2 SUPPRESSED 
 ;  -  -  - 089<tokLocalOfs> "-2" size(2) REG: r2 SUPPRESSED *
 ;  -  - 001<tokNumInt> "50" size(2) REG: r4  *

 ; r2 <-[tokLocalOfs]-  value(-2) size (2)
 ; !!! emit suppressed
 ; l-2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r4 <-[tokNumInt]-  value(50) size (2)
 ; possible optimization - pass size
ld r4, 50
ld r5, 0
 ; r0 <-[tokLess]- l-2 r4  value(0) size (2)
ldd X, $L83
tsub r0, l-2, r4
tsbc r1, l-1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L83:
 ; r0 <-[tokIfNot]- r0  value(81) size (2)
 ; Jump if zero to L81
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L81
jz



 ; {

.section rodata
L84:
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
 ; RPN'ized expression: "( L84 puts ) "
 ; Expanded expression: " L84  puts ()2 "
 ; Expression stack:    "( L84 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "115" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "115" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(115) size (2)
ldd X, $L84
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
 ; Unconditional jump to L82
ldd X, $L82
jmp
L81:
 ; else
 ; {

.section rodata
L85:
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
 ; RPN'ized expression: "( L85 puts ) "
 ; Expanded expression: " L85  puts ()2 "
 ; Expression stack:    "( L85 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "115" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "115" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(115) size (2)
ldd X, $L85
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
L82:
 ; RPN'ized expression: "count 1 -u = "
 ; Expanded expression: "(@-2) -1 =(2) "
 ; Expression stack:    "(@-2) -1 =(2) "
 ; Expr tree before optim: 
 ; 061<tokAssign> "2" size(0) REG: z0  
 ;  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  - 001<tokNumInt> "-1" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; replace assign with kid->next with correct regs
 ; Expr tree: 
 ; 001<tokNumInt> "-1" size(2) REG: l-2  *

 ; l-2 <-[tokNumInt]-  value(-1) size (2)
 ; possible optimization - pass size
ld l-2, 255
ld l-1, 255



 ; if
 ; RPN'ized expression: "count 0 < "
 ; Expanded expression: "(@-2) *(2) 0 < "
 ; Expression stack:    "(@-2) *(2) 0 < IF![86] "
 ; Expr tree before optim: 
 ; 076<tokIfNot> "86" size(0) REG: z0  
 ;  - 060<tokLess> "0" size(0) REG: z0  
 ;  -  - 078<tokUnaryStar> "2" size(0) REG: z0  
 ;  -  -  - 089<tokLocalOfs> "-2" size(0) REG: z0  *
 ;  -  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 076<tokIfNot> "86" size(2) REG: r0  
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
ldd X, $L88
tsub r0, l-2, r4
tsbc r1, l-1, r5
ld r1, 0
ld r0, 0
jge
ld r0, 1
; --- end of comparison:
L88:
 ; r0 <-[tokIfNot]- r0  value(86) size (2)
 ; Jump if zero to L86
 ; 16 bit for now, optimize
tor r0,r0,r1
ldd X, $L86
jz



 ; {

.section rodata
L89:
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
 ; RPN'ized expression: "( L89 puts ) "
 ; Expanded expression: " L89  puts ()2 "
 ; Expression stack:    "( L89 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "115" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "115" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(115) size (2)
ldd X, $L89
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
 ; Unconditional jump to L87
ldd X, $L87
jmp
L86:
 ; else
 ; {

.section rodata
L90:
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
 ; RPN'ized expression: "( L90 puts ) "
 ; Expanded expression: " L90  puts ()2 "
 ; Expression stack:    "( L90 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "115" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "115" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(115) size (2)
ldd X, $L90
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; }
L87:
L39:
 ; epilog
mov A,r0
mov a0,A
mov A,r1
mov a1,A
SP-=8
; XXX adjust can be optimized inlining pop's and push's
 ; adjust sp by 2
ld A, 2
mov B,A
mov A,SL
add
mov SL,A
ld A, 0
mov B,A
mov A,SH
adc
mov SH,A
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
; adjust by 0, skip
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
 ; prolog end


.section rodata
L93:
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
 ; RPN'ized expression: "( L93 puts ) "
 ; Expanded expression: " L93  puts ()2 "
 ; Expression stack:    "( L93 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "66" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "66" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(66) size (2)
ldd X, $L93
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip




.section rodata
L94:
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
 ; RPN'ized expression: "( L94 puts ) "
 ; Expanded expression: " L94  puts ()2 "
 ; Expression stack:    "( L94 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "70" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "70" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(70) size (2)
ldd X, $L94
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



 ; RPN'ized expression: "( tests ) "
 ; Expanded expression: " tests ()0 "
 ; Expression stack:    "( tests )0 "
 ; Expr tree before optim: 
 ; 041<tokCall> "0" size(0) REG: z0  
 ;  - 016<tokIdent> "49" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "0" size(2) REG: r0  
 ;  - 016<tokIdent> "49" size(2) REG: r0 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(49) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0  value(0) size (2)
 ; pushed 0 args
 ; no args, reserve 2 bytes for retval
push A
push A
ldd X, $tests
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip




.section rodata
L95:
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
 ; RPN'ized expression: "( L95 puts ) "
 ; Expanded expression: " L95  puts ()2 "
 ; Expression stack:    "( L95 , puts )2 "
 ; Expr tree before optim: 
 ; 041<tokCall> "2" size(0) REG: z0  
 ;  - 016<tokIdent> "74" size(0) REG: z0  *
 ;  - 016<tokIdent> "11" size(0) REG: z0  *
 ; Expr tree: 
 ; 041<tokCall> "2" size(2) REG: r0  
 ;  - 016<tokIdent> "74" size(2) REG: r0  *
 ;  - 016<tokIdent> "11" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokIdent]-  value(74) size (2)
ldd X, $L95
mov A, XL
mov r0, A
mov A, XH
mov r1, A
 ; r2 <-[tokIdent]-  value(11) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokCall]- r0 r2  value(2) size (2)
mov A, r1
push A
mov A, r0
push A
 ; pushed 1 args
ldd X, $puts
jmp
pop A
mov r0,A
pop A
mov r1,A
; adjust by 0, skip



hlt

 ; Expression stack:    "0 return "
 ; Expr tree before optim: 
 ; 020<tokReturn> "0" size(0) REG: z0  
 ;  - 001<tokNumInt> "0" size(0) REG: z0  *
 ; !! Optimize NumInt/NumUint size!
 ; Expr tree: 
 ; 020<tokReturn> "0" size(2) REG: r0  
 ;  - 001<tokNumInt> "0" size(2) REG: r0  *

 ; r0 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld r0, 0
ld r1, 0
 ; r0 <-[tokReturn]- r0  value(0) size (2)
 ; tokReturn



L91:
 ; epilog
mov A,r0
mov a0,A
mov A,r1
mov a1,A
; adjust by 0, skip
movsm
pop MX
jmp
 ; epilog end

 ; end of function 


 ; Syntax/declaration table/stack:
 ; Bytes used: 240/15360


 ; Macro table:
 ; Macro __SMALLER_C__ = `0x0100`
 ; Macro __SMALLER_C_16__ = ``
 ; Macro __SMALLER_C_SCHAR__ = ``
 ; Macro __SMALLER_C_UWCHAR__ = ``
 ; Macro __SMALLER_C_WCHAR16__ = ``
 ; Bytes used: 110/5120


 ; Identifier table:
 ; Ident 
 ; Ident putc
 ; Ident c
 ; Ident puts
 ; Ident s
 ; Ident strcmp
 ; Ident s1
 ; Ident s2
 ; Ident printhex
 ; Ident i
 ; Ident tests
 ; Ident main
 ; Bytes used: 62/5632

 ; Next label number: 96
 ; Compilation succeeded.
