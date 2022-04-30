.section text
__entry:
.export __entry

a <- lit 0xff
b <- lit 0x01
op <- lit add
ml <- dlit 0x0020
mem <- alu
a <- lit 0
ml <- dlit 0x0021
op <- lit adc
mem <- alu

end:
a <- dlit $end
j
