.section text
__entry:
.export __entry

start:

sl  <- dlit 0x00fe
ml  <- dlit 0x0030
a   <- lit 0xf2
mem <- a


loop:
a   <- dlit $fn
j 
ml  <- dlit 0x0030
a   <- mem
b   <- lit 0
op  <- lit ne
a   <- alu ;discard
a   <- dlit $loop
j_c 
a   <- dlit 0
j 


fn:
st  <- b 
st  <- a 
ml  <- dlit 0x0030
a   <- mem
b   <- lit 1
op  <- lit sub
mem <- alu
ml  <- dlit 0xc000
mem <- alu


a   <- dst
j


