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

.const INT_VEC_0 0xFF00

ei

ld a, 0
mov off, a
mov r8, a

;ldd m, INT_VEC_0
;ld a, 0x1f ; IRET
;ld a, 0x03 ; HLT
;mov [m], a 


ldd m, 0xff00
ld a, 0x88 ; mov a, r8
mov [m], a 

ldd m, 0xff01
ld a, 0xC5 ; inc
mov [m], a 

ldd m, 0xff02
ld a, 0x68 ; mov r8, a
mov [m], a 

ldd m, 0xff03
ld a, 0x1f ; iret
mov [m], a 

ld a, 0
mov r5, a



loop:

ei


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

; r8

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

