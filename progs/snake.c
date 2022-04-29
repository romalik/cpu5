.section text_entry
__entry:
.export __entry

a   <- dlit $main
j





.section text_main
main:
.export main



.section data
self:
.byte 0x04
.byte 0x04
.byte 0x03
.byte 0x04
.byte 0x02
.byte 0x04
.skip 122
current_direction: .byte 0x04
current_length:    .byte 0x06
fb:
.byte 0x00
.byte 0x00
.byte 0x00
.byte 0x00
.byte 0x00
.byte 0x00
.byte 0x00
.byte 0x00
