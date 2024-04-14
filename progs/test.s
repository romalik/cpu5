.section text
main:
.export main

ldd S, 0x80ff
movms
ld r0, 0xaa
hlt

