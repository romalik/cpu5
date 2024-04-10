.section text


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

main:
.export main




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

ei

ldd x, $hello
jmp

ldd x, $main_loop
jmp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ISR 0
isr_0:
mov a, f
push a

ldd x,$led_counter
mov a, [x]
inc
mov b,a
mov [x], a

ldd x,OUT_7
mov a,b
mov [x],a

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
mov a,r2
push a
mov a,r3
push a
mov a,r4
push a
mov a,r5
push a

; r2, r3 - serial_buffer_wr_ptr


ldd x, $serial_buffer_wr_ptr
mov a,[x]
mov r2,a
x++
mov a,[x]
mov r3,a

; r4, r5 - serial_buffer

ld a,$(l)serial_buffer
mov r4,a
ld a,$(h)serial_buffer
mov r5,a

; if serial_buffer_wr_ptr - serial_buffer > 0xff

tsub r0, r2, r4
tsbc r1, r3, r5
ldd x,$isr_3_L1
jz 

; serial_buffer_wr_ptr = serial_buffer

mov a,r4
mov r2,a
mov a,r5
mov r3,a

isr_3_L1:


; write new byte
ldd x, SERIAL
mov a,[x]
mov b,a

mov a,r2
mov xl,a
mov a,r3
mov xh,a


mov a,b
mov [x],a


; increment serial_buffer_wr_ptr
tinc r2,r2,r2
ld a,0
mov r4,a
tadc r3,r3,r4 ;inc by 1 if carry


; save wr_ptr
ldd x,$serial_buffer_wr_ptr
mov a,r2
mov [x],a
x++
mov a,r3
mov [x],a


; inc size

ld a,0xff
mov b,a
ldd x, $serial_buffer_size
mov a,[x]
sub
ldd x,$isr_3_L3
jz
; no overflow, increment and store

ldd x, $serial_buffer_size
mov a,[x]
inc
mov [x],a
ldd x,$isr_3_L3
jmp

isr_3_L2:
; overflow, do not increment, rd_ptr = wr_ptr
ldd x,$serial_buffer_rd_ptr
mov a,r2
mov [x],a
x++
mov a,r3
mov [x],a


isr_3_L3:

pop a
mov r5, a

pop a
mov r4, a

pop a
mov r3, a

pop a
mov r2, a

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

ldd x, $serial_buffer_rd_ptr
ld a,$(l)serial_buffer
mov [x],a
x++
ld a,$(h)serial_buffer
mov [x],a

ldd x, $serial_buffer_wr_ptr
ld a,$(l)serial_buffer
mov [x],a
x++
ld a,$(h)serial_buffer
mov [x],a

ldd x, $serial_buffer_size
ld a,0
mov [x],a


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
.export read_serial
;frame
push xm
movms

mov a,r2
push a
mov a,r3
push a
mov a,r4
push a
mov a,r5
push a

ld a,0
mov r0,a
mov r1,a

; check size
ldd x, $serial_buffer_size
mov a,[x]
mov b,a
ldd x, $read_serial_end
mov a,b
test
jz

; r2, r3 - serial_buffer_rd_ptr


ldd x, $serial_buffer_rd_ptr
mov a,[x]
mov r2,a
x++
mov a,[x]
mov r3,a

; r4, r5 - serial_buffer

ld a, $(l)serial_buffer
mov r4,a
ld a, $(h)serial_buffer
mov r5,a

; if serial_buffer_rd_ptr - serial_buffer > 0xff

tsub r0, r2, r4
tsbc r1, r3, r5
ldd x,$read_serial_L1
jz 

; serial_buffer_rd_ptr = serial_buffer

mov a,r4
mov r2,a
mov a,r5
mov r3,a

read_serial_L1:


; read new byte

mov a,r2
mov xl,a
mov a,r3
mov xh,a

mov a,[x]
mov r0,a

; increment serial_buffer_rd_ptr
tinc r2,r2,r2
ld a,0
mov r4,a
tadc r3,r3,r4 ;inc by 1 if carry


; save rd_ptr
ldd x,$serial_buffer_rd_ptr
mov a,r2
mov [x],a
x++
mov a,r3
mov [x],a


; dec size
ld a,1
mov b,a
ldd x, $serial_buffer_size
mov a,[x]
sub
mov [x],a


read_serial_end:
; return

mov a,r0
mov [m+5],a
mov a,r1
mov [m+6],a

pop a
mov r5, a

pop a
mov r4, a

pop a
mov r3, a

pop a
mov r2, a

pop mx
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
mov a, r2
mov xl, a
mov a, r3
mov xh, a

mov a,[x]
mov b,a


mov a, r0
mov xl, a
mov a, r1
mov xh, a

mov a,b

mov [x],a

;===============

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

;================


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


main_loop:


ei



loop:

ei







ldd x, $read_serial
jmp


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
mov a, r0
mov [m], a



skip_send:

ldd x, $loop
jmp


.section data

isr_0_jmp:
.byte 0xe6 ; mov a, xl
.byte 0xd9 ; push a
.byte 0xe7 ; mov a, xh
.byte 0xd9 ; push a
.byte 0xde ; ldd x, $isr_0 ;;low, high
.word $isr_0
.byte 0xaf ; jmp

isr_3_jmp:
.byte 0xe6 ; mov a, xl
.byte 0xd9 ; push a
.byte 0xe7 ; mov a, xh
.byte 0xd9 ; push a
.byte 0xde ; ldd x, $isr_0 ;;low, high
.word $isr_3
.byte 0xaf ; jmp


.section bss
.align 0xff
serial_buffer:
.skip 0x100
serial_buffer_rd_ptr:
.skip 2
serial_buffer_wr_ptr:
.skip 2
serial_buffer_size:
.skip 1
led_counter:
.skip 1