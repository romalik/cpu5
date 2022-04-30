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

    ;ptr = fb;

a   <- dlit $fb
ml  <- dlit $ptr
mem <- a
ml  <- dlit $ptr+1
mem <- b


loop:

    ;*ptr = val;

ml  <- dlit $val
a   <- mem
st  <- a

ml  <- dlit $ptr
a   <- mem
ml  <- dlit $ptr+1
mh  <- mem
ml  <- a

a   <- st
mem <- a

    ;ptr++;

ml  <- dlit $ptr
a   <- mem
op  <- lit inc
mem <- alu
ml  <- dlit $ptr+1
a   <- mem
b   <- lit 0
op  <- lit adc
mem <- alu


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
ptr: .word 0
fb: .byte 0
