.section text

__entry:
.export __entry

ml <- dlit 0x8000
a <- mem
ml <- dlit 0xc000
mem <- a
a <- dlit 0x0000
j
