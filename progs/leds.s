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

mov r5, a



ld a, 0x00
mov off, a

loop:

ldd m, IN_1
mov a, [m]
mov r0, a

ldd m, IN_2
mov a, [m]
mov r1, a


; add
mov a, r1
mov b, a
mov a, r0

add

mov b, a

ldd m, OUT_0
mov a, b
mov [m], a


; sub
mov a, r1
mov b, a
mov a, r0

sub

mov b, a

ldd m, OUT_1
mov a, b
mov [m], a

; neg
mov a, r1
mov b, a
mov a, r0

neg

mov b, a

ldd m, OUT_2
mov a, b
mov [m], a


; shl
mov a, r1
mov b, a
mov a, r0

shl

mov b, a

ldd m, OUT_3
mov a, b
mov [m], a


; inc
mov a, r1
mov b, a
mov a, r0

inc

mov b, a

ldd m, OUT_4
mov a, b
mov [m], a


; and
mov a, r1
mov b, a
mov a, r0

and

mov b, a

ldd m, OUT_5
mov a, b
mov [m], a

; xor
mov a, r1
mov b, a
mov a, r0

xor

mov b, a

ldd m, OUT_6
mov a, b
mov [m], a


; zero
mov a, r1
mov b, a
mov a, r0

zero

mov b, a

ldd m, OUT_7
mov a, b
mov [m], a






ldd x, $loop
jmp


.section data


    ;unsigned char fb[8];
fb: 
.byte 0x51
.byte 0xa2
.byte 0x53
.byte 0xa4
.byte 0x55
.byte 0xa6
.byte 0x57
.byte 0xa8

