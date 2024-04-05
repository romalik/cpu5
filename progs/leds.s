.section text
__entry:
.export __entry

.const OUT_0 0x4000
.const OUT_1 0x4001
.const OUT_2 0x4002
.const OUT_3 0x4003
.const OUT_4 0x4004
.const OUT_5 0x4005
.const OUT_6 0x4006
.const OUT_7 0x4007

.const IN_0 0x4400
.const IN_1 0x4401
.const IN_2 0x4402

.const SERIAL 0x4803

.const INT_VEC_0 0xFF00
.const INT_VEC_1 0xFF10
.const INT_VEC_2 0xFF20
.const INT_VEC_3 0xFF30



.const SERIAL_BUFFER_LEN 0xff





ld a, 0
mov off, a

ldd s, 0xfeff


ld a, 0x00
mov r0,a
ld a, 0xFF
mov r1,a
ld a, $(l)isr_0_jmp
mov r2,a
ld a, $(h)isr_0_jmp
mov r3,a
ld a, 8
mov r4,a
ld a, 0
mov r5,a

ldd x, $memcpy
jmp



ld a, 0x30
mov r0,a
ld a, 0xFF
mov r1,a
ld a, $(l)isr_3_jmp
mov r2,a
ld a, $(h)isr_3_jmp
mov r3,a
ld a, 8
mov r4,a
ld a, 0
mov r5,a

ldd x, $memcpy
jmp

ldd x, $init_serial_buffer
jmp

ldd x, $main
jmp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ISR 0
isr_0:
mov a, f
push a

mov a, r8
inc
mov r8, a

pop a
mov f, a


pop a
mov xh, a
pop a
mov xl, a

iret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ISR 3
isr_3:
mov a, ml
push a
mov a, mh
push a
mov a, f
push a


ldd m, $serial_buffer
ldd x, $serial_buffer_wr_ptr
mov a,[x]
mov ml,a

ldd x, SERIAL
cpy


ldd x, $serial_buffer_size
mov a,[x]
inc
mov [x],a

ldd x, $serial_buffer_wr_ptr
mov a,[x]
inc
mov [x],a

pop a
mov f, a

pop a
mov mh, a
pop a
mov ml, a

pop a
mov xh, a
pop a
mov xl, a
iret

init_serial_buffer:
;frame
mov a, xl
push a
mov a, xh
push a

ldd m, $serial_buffer_rd_ptr
ld a,0
mov [m],a
ldd m, $serial_buffer_wr_ptr
ld a,0
mov [m],a
ldd m, $serial_buffer_size
ld a,0
mov [m],a


; return
pop a
mov xh, a
pop a
mov xl, a
jmp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; read_serial()
;;;; return
; available: r0
; data: r1
read_serial:
;frame
mov a, xl
push a
mov a, xh
push a


; set available = 0
ld a,0
mov r0,a
mov b,a
; check buf size
ldd m, $serial_buffer_size
mov a,[m]


sub
ldd x, $read_serial_end
jz



; set available = 1
ld a,1
mov r0,a

; decrement size
mov b,a
mov a,[m]
sub
mov [m],a

; load value from buf
ldd m, $serial_buffer
ldd x, $serial_buffer_rd_ptr
mov a,[x]
mov ml,a
mov a,[m]
mov r1,a

; increment rd_ptr
mov a,[x]
inc
mov [x],a



read_serial_end:
; return
pop a
mov xh, a
pop a
mov xl, a
jmp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; memcpy(dst, src, n)
; dst_l: r0
; dst_h: r1
; src_l: r2
; src_h: r3
; n_l:   r4
; n_h:   r5
;;;; local
; i_l:   r6
; i_h:   r7
memcpy:

;frame
mov a, xl
push a
mov a, xh
push a

; i = 0
ld a, 0x00
mov r6,a
mov r7,a

memcpy_loop:
;compare i_l == n_l && i_h == n_h
mov a, r5
mov b, a
mov a, r7
sub
ldd x, $memcpy_do_copy
jnz 

mov a, r4
mov b, a
mov a, r6
sub
ldd x, $memcpy_end
jz 



memcpy_do_copy:
mov a, r0
mov ml, a
mov a, r1
mov mh, a

mov a, r2
mov xl, a
mov a, r3
mov xh, a

cpy

; increment dest
mov a, r0
inc
mov r0, a
ldd x, $memcpy_L1
jnc
mov a, r1
inc
mov r1, a
memcpy_L1:

; increment src
mov a, r2
inc
mov r2, a
ldd x, $memcpy_L2
jnc
mov a, r3
inc
mov r3, a
memcpy_L2:

; increment i
mov a, r6
inc
mov r6, a
ldd x, $memcpy_L3
jnc
mov a, r7
inc
mov r7, a
memcpy_L3:

ldd x, $memcpy_loop
jmp

memcpy_end:
; return
pop a
mov xh, a
pop a
mov xl, a
jmp

;;;;;;;;;;;;;;; memcpy end ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


main:


ei

ld a, 0

mov r8, a


ld a, 'a'
mov r5, a



loop:

ei


ldd m, IN_1
mov a, [m]
mov r0, a

ldd m, IN_2
mov a, [m]
mov r1, a




; ISR counter

ldd m, OUT_6
mov a, r8
mov [m], a


; counter

mov a, r5
mov b, a
ld a, 1

add

mov b, a
mov r5, a




mov a, r5
mov b, a
ld a, 'z'
sub
ldd x, $no_reset
jnc
ld a, 'a'
mov r5, a

no_reset:



;ldd m, SERIAL
;mov a, r5
;mov [m], a



;ldd m, SERIAL
;mov a, [m]
;mov b, a
;ld a, 0xff
;sub
;ldd x, $skip_send
;jz 


ldd x, $read_serial
jmp

;ld a,0
;mov r0,a

ldd m, OUT_0
mov a, r0
mov [m], a


mov a,r0
mov b,a
ld a, 0
add
ldd x, $skip_send
jz

ldd m, SERIAL
mov a, r1
mov [m], a



skip_send:

ldd x, $loop
jmp


.section data

isr_0_jmp:
.byte 0x46 ; mov a, xl
.byte 0x29 ; push a
.byte 0x47 ; mov a, xh
.byte 0x29 ; push a
.byte 0xe2 ; ldd x, $isr_0 ;;low, high
.word $isr_0
.byte 0xaf ; jmp

isr_3_jmp:
.byte 0x46 ; mov a, xl
.byte 0x29 ; push a
.byte 0x47 ; mov a, xh
.byte 0x29 ; push a
.byte 0xe2 ; ldd x, $isr_0 ;;low, high
.word $isr_3
.byte 0xaf ; jmp


.section bss
.align 0xff
serial_buffer:
.skip 0x100
serial_buffer_rd_ptr:
.skip 1
serial_buffer_wr_ptr:
.skip 1
serial_buffer_size:
.skip 1
