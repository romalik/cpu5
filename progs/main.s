
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
 ;  - 089<tokLocalOfs> "-2" size(2) REG: r0  *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a0 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "4" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-2) size (2)
 ; localOfs: -2, fix for [m+off] to -17
ld A, 17
mov B,A
mov A,ML
sub
mov r0,A
ld A, 0
mov B,A
mov A,MH
sbc
mov r1,A
 ; r2 <-[tokLocalOfs]-  value(4) size (2)
 ; !!! emit suppressed
 ; a0 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a0  value(2) size (2)
 ; assign to non-ident non-local lvalue
mov A, r0
mov XL, A
mov A, r1
mov XH, A
mov A, a0
mov [X], A
 ; load to retval
mov r0, A
 ; emit_inc_x()
X++
mov A, a1
mov [X], A
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
 ;  - 089<tokLocalOfs> "-4" size(2) REG: r0  *
 ;  - 078<tokUnaryStar> "2" size(2) REG: a2 SUPPRESSED 
 ;  -  - 089<tokLocalOfs> "6" size(2) REG: r2 SUPPRESSED *

 ; r0 <-[tokLocalOfs]-  value(-4) size (2)
 ; localOfs: -4, fix for [m+off] to -19
ld A, 19
mov B,A
mov A,ML
sub
mov r0,A
ld A, 0
mov B,A
mov A,MH
sbc
mov r1,A
 ; r2 <-[tokLocalOfs]-  value(6) size (2)
 ; !!! emit suppressed
 ; a2 <-[tokUnaryStar]- r2  value(2) size (2)
 ; !!! emit suppressed
 ; r0 <-[tokAssign]- r0 a2  value(2) size (2)
 ; assign to non-ident non-local lvalue
mov A, r0
mov XL, A
mov A, r1
mov XH, A
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
 ; 001<tokNumInt> "0" size(2) REG: l-7  *

 ; l-7 <-[tokNumInt]-  value(0) size (2)
 ; possible optimization - pass size
ld l-7, 0
ld l-6, 0



 ; while
 ; RPN'ized expression: "1 "
 ; Expanded expression: "1 "
 ; Expression value: 1
L13:
 ; {
 ; loc         <something> : int
 ; 