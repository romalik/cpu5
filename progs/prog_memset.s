.section text
__entry:
.export __entry

;void memset() {
;    i = 0;
;    val = 0;
;loop:
;    *(fb+i) = val;
;    val++;
;    if(i < 20) goto loop;
;end:
;    goto end;
;}

sl  <- dlit 0x40f0


ml  <- dlit $i
a   <- lit 0
mem <- a

ml  <- dlit $val
a   <- lit 0
mem <- a


loop:

    ;*(fb + i) = val;

ml  <- dlit $i
a   <- dlit $fb
b   <- mem
op  <- lit add
st  <- alu
a   <- dlit $fb
a   <- lit 0
op  <- lit adc
st  <- alu

ml  <- dlit $val
a   <- mem

mh  <- st
ml  <- st
mem <- a


    ;val++;

ml  <- dlit $val
a   <- mem
op  <- lit inc
mem <- alu

    ;i++;

ml  <- dlit $i
a   <- mem
op  <- lit inc
mem <- alu


    ; if(i<8) goto loop;
ml  <- dlit $i
a   <- mem
b   <- lit 0xf0
op  <- lit le
a   <- alu
a   <- dlit $loop
j_c

end:
a   <- dlit $end
j


.section data
i: .byte 0
val: .byte 0
fb: .byte 0