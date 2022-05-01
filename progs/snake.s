.section text
__entry:
.export __entry

sl <- dlit 0x20fc

a  <- dlit $main
j


    ;void check_control() {

check_control:
st  <- b
st  <- a

    ;    t = mygetch();
ml  <- dlit 0x8000
a   <- mem
ml  <- dlit $t
mem <- a


    ;    if(t == 'd') cur_dir = 0;
ml  <- dlit $t
a   <- mem
b   <- lit 1
op  <- lit ne
a   <- alu
a   <- dlit $ctl_1
j_c
ml  <- dlit $cur_dir
a   <- lit 0
mem <- a
a   <- dlit $ctl_end
j

ctl_1:

    ;    if(t == 'w') cur_dir = 1;

ml  <- dlit $t
a   <- mem
b   <- lit 2
op  <- lit ne
a   <- alu
a   <- dlit $ctl_2
j_c
ml  <- dlit $cur_dir
a   <- lit 1
mem <- a
a   <- dlit $ctl_end
j

ctl_2:

    ;    if(t == 'a') cur_dir = 2;

ml  <- dlit $t
a   <- mem
b   <- lit 4
op  <- lit ne
a   <- alu
a   <- dlit $ctl_3
j_c
ml  <- dlit $cur_dir
a   <- lit 2
mem <- a
a   <- dlit $ctl_end
j

ctl_3:

    ;    if(t == 's') cur_dir = 3;

ml  <- dlit $t
a   <- mem
b   <- lit 8
op  <- lit ne
a   <- alu
a   <- dlit $ctl_end
j_c
ml  <- dlit $cur_dir
a   <- lit 3
mem <- a


    ;}

ctl_end:
a   <- dst
j




    ;void move() {
move:
st  <- b
st  <- a



    ;    t = cur_len;

ml  <- dlit $cur_len
a   <- mem
ml  <- dlit $t
mem <- a

    ;    t2 = cur_len - 1;
b   <- lit 1
op  <- lit sub
a   <- alu
ml  <- dlit $t2
mem <- a


    ;move_loop:
move_loop:


    ;    c_x[t] = c_x[t2];
zl  <- dlit $c_x
ml  <- dlit $t2
off <- mem
a   <- zm
ml  <- dlit $t
off <- mem
zm  <- a



    ;    c_y[t] = c_y[t2];
zl  <- dlit $c_y
ml  <- dlit $t2
off <- mem
a   <- zm
ml  <- dlit $t
off <- mem
zm  <- a

    ;    t--;
ml  <- dlit $t
a   <- mem
b   <- lit 1
op  <- lit sub
mem <- alu


    ;    t2--;
ml  <- dlit $t2
a   <- mem
b   <- lit 1
op  <- lit sub
mem <- alu



    ;    if(t > 0) goto move_loop;
ml  <- dlit $t
a   <- mem
b   <- lit 0
op  <- lit gt
a   <- alu
a   <- dlit $move_loop
j_c

    ;    x = c_x[0];
ml  <- dlit $c_x
a   <- mem
ml  <- dlit $x
mem <- a

    ;    y = c_y[0];
ml  <- dlit $c_y
a   <- mem
ml  <- dlit $y
mem <- a



    ;    if(cur_dir == 0) x++;
ml  <- dlit $cur_dir
a   <- mem
b   <- lit 0
op  <- lit ne
a   <- alu
a   <- dlit $move_2
j_c
ml  <- dlit $x
a   <- mem
op  <- lit inc
mem <- alu
a   <- dlit $end_step

move_2:

;    if(cur_dir == 1) y--;

ml  <- dlit $cur_dir
a   <- mem
b   <- lit 1
op  <- lit ne
a   <- alu
a   <- dlit $move_3
j_c
ml  <- dlit $y
a   <- mem
b   <- lit 1
op  <- lit sub
mem <- alu
a   <- dlit $end_step

move_3:


;    if(cur_dir == 2) x--;

ml  <- dlit $cur_dir
a   <- mem
b   <- lit 2
op  <- lit ne
a   <- alu
a   <- dlit $move_4
j_c
ml  <- dlit $x
a   <- mem
b   <- lit 1
op  <- lit sub
mem <- alu
a   <- dlit $end_step

move_4:


;    if(cur_dir == 3) y++;

ml  <- dlit $cur_dir
a   <- mem
b   <- lit 3
op  <- lit ne
a   <- alu
a   <- dlit $end_step
j_c
ml  <- dlit $y
a   <- mem
op  <- lit inc
mem <- alu
a   <- dlit $end_step


end_step:



    ;    x = x & 0x07;
ml  <- dlit $x
a   <- mem
b   <- lit 0x07
op  <- lit and
mem <- alu

    ;    y = y & 0x07;
ml  <- dlit $y
a   <- mem
b   <- lit 0x07
op  <- lit and
mem <- alu




    ;    c_x[0] = x;
ml  <- dlit $x
a   <- mem
ml  <- dlit $c_x
mem <- a


    ;    c_y[0] = y;
ml  <- dlit $y
a   <- mem
ml  <- dlit $c_y
mem <- a


    ;    if(f_x != x) goto end_food;
ml  <- dlit $f_x
a   <- mem
ml  <- dlit $x
b   <- mem
op  <- lit ne
a   <- alu
a   <- dlit $end_food
j_c

    ;    if(f_y != y) goto end_food;   
ml  <- dlit $f_y
a   <- mem
ml  <- dlit $y
b   <- mem
op  <- lit ne
a   <- alu
a   <- dlit $end_food
j_c

    ;    cur_len++;
ml  <- dlit $cur_len
a   <- mem
op  <- lit inc
mem <- alu



    ;    f_x = f_x | 0xf0;
ml  <- dlit $f_x
a   <- mem
b   <- lit 0xf0
op  <- lit or
mem <- alu


    ;    f_y = f_y | 0xf0;
ml  <- dlit $f_y
a   <- mem
b   <- lit 0xf0
op  <- lit or
mem <- alu




    ;end_food:
end_food:


    ;    t = fb[y];
zl  <- dlit $fb
ml  <- dlit $y
off <- mem
ml  <- dlit $t
a   <- mem
zm  <- a


    ;    t2 = shifts[x];
zl  <- dlit $shifts
ml  <- dlit $x
off <- mem
ml  <- dlit $t2
a   <- mem
zm  <- a



    ;    if((t & t2) != 0) {
ml  <- dlit $t
a   <- mem
ml  <- dlit $t2
b   <- mem
op  <- lit and
a   <- alu
b   <- lit 0
op  <- lit ne
a   <- alu
a   <- dlit 0x0000
j_c
    ;        exit(1);
    ;    } 



    ;    if((f_x & 0x10) == 0) goto end_move;
ml  <- dlit $f_x
a   <- mem
b   <- lit 0x10
op  <- lit eq
a   <- alu
a   <- dlit $end_move
j_c



    ;    f_x += 10;
    ;    f_x = f_x & 0x07;
ml  <- dlit $f_x
a   <- mem

b   <- lit 10
op  <- lit add
a   <- alu

b   <- lit 0x07
op  <- lit add
mem <- alu



    ;    f_y += 14;
    ;    f_y = f_y & 0x07;
ml  <- dlit $f_y
a   <- mem

b   <- lit 14
op  <- lit add
a   <- alu

b   <- lit 0x07
op  <- lit add
mem <- alu

    ;end_move:
end_move:
a   <- dst
j

    ;}




    ;void update_fb() {
update_fb:
st  <- b
st  <- a


    ;    i = 0;
ml  <- dlit $i
a   <- lit 0
mem <- a

    ;loop_fb_clear:

loop_fb_clear:

    ;    *(fb + i) = 0;
zl  <- dlit $fb
ml  <- dlit $i
off <- mem
a   <- lit 0
zm  <- a


    ;    i++;
ml  <- dlit $i
a   <- mem
op  <- lit inc
mem <- alu

    ;    if(i<8) goto loop_fb_clear;
ml  <- dlit $i
a   <- mem
b   <- lit 8
op  <- lit lt
a   <- alu
a   <- dlit $loop_fb_clear
j_c

    ;    i = 0;
ml  <- dlit $i
a   <- lit 0
mem <- a

    ;loop_fb_snake:
loop_fb_snake:

    ;    x = *(c_x + i);
zl  <- dlit $c_x
ml  <- dlit $i
off <- mem
ml  <- dlit $x
a   <- zm
mem <- a


    ;    y = *(c_y + i);
zl  <- dlit $c_y
ml  <- dlit $i
off <- mem
ml  <- dlit $y
a   <- zm
mem <- a


    ;    t = *(shifts + x);
zl  <- dlit $shifts
ml  <- dlit $x
off <- mem
ml  <- dlit $t
a   <- zm
mem <- a



    ;    t2 = *(fb + y);
zl  <- dlit $fb
ml  <- dlit $y
off <- mem
ml  <- dlit $t2
a   <- zm
mem <- a


    ;    t2 = t2 | t;
ml  <- dlit $t
b   <- mem
ml  <- dlit $t2
a   <- mem
op  <- lit or
mem <- alu


    ;    *(fb + y) = t2;
zl  <- dlit $fb
ml  <- dlit $y
off <- mem
ml  <- dlit $t2
a   <- mem
zm <- a

    ;    i++;
ml  <- dlit $i
a   <- mem
op  <- lit inc
mem <- alu


    ;    if(i<cur_len) goto loop_fb_snake;
ml  <- dlit $i
a   <- mem
ml  <- dlit $cur_len
b   <- mem
op  <- lit lt
a   <- alu
a   <- dlit $loop_fb_snake
j_c

a   <- dst
j

    ;}




;
;void draw_food() {
;    t = *(fb + f_y);
;    t2 = *(shifts + f_x);
;
;    t = t | t2;
;
;    *(fb + f_y) = t;
;
;}
;
;void undraw_food() {
;    t = *(fb + f_y);
;    t2 = *(shifts + f_x);
;
;    t2 = ~t2;
;
;    t = t & t2;
;
;    *(fb + f_y) = t;
;}
;
;
;void draw() {
;    unsigned char c = 0;
;    unsigned char r = 0;
;    printf("%c[1J%c[H", 0x1b, 0x1b);
;    printf("\n.________.\n");
;    for(r = 0; r < 8; r++) {
;    	printf("|");
;        for(c = 0; c < 8; c++) {
;            printf("%s", (fb[r] & (1<<c))?"*":" ");
;        }
;        printf("|\n");
;    }
;    printf("^^^^^^^^^^\n");
;
;}


draw:


st  <- b
st  <- a

    ;i = 0
ml  <- dlit $i
a   <- lit 0
mem <- a

    ;draw_loop:
draw_loop:

    ;*(0xc000 + i) = *(fb + i);
zl  <- dlit $fb
ml  <- dlit $i
a   <- mem
off <- a
a   <- zm

zl  <- dlit 0xc000
zm  <- a

    ;i++;
ml  <- dlit $i
a   <- mem
op  <- lit inc
mem <- alu


    ;if(i != 8) goto draw_loop; 
ml  <- dlit $i
a   <- mem
b   <- lit 8
op  <- lit ne
a   <- alu
a   <- dlit $draw_loop
j_c

a   <- dst
j



;
;void delay() {
;    usleep(200*1000);
;}
;
;
    ;int main() {
main:

ml  <- dlit $c_x
a   <- lit 4
mem <- a
ml  <- dlit $c_x+1
a   <- lit 4
mem <- a
ml  <- dlit $c_x+2
a   <- lit 4
mem <- a

ml  <- dlit $c_y
a   <- lit 4
mem <- a
ml  <- dlit $c_y+1
a   <- lit 5
mem <- a
ml  <- dlit $c_y+2
a   <- lit 6
mem <- a






;    c_x[0] = 4;
;    c_y[0] = 4;
;
;    c_x[1] = 3;
;    c_y[1] = 4;
;
;    c_x[2] = 2;
;    c_y[2] = 4;
;
;    f_x = 1;
;    f_y = 1;
; inited in data section

    ;    while(1) {
main_loop:

    ;        check_control();
;a   <- dlit $check_control
;j


    ;        move();
;a   <- dlit $move
;j

    ;        update_fb();
a   <- dlit $update_fb
j
    ;        draw_food();

;a   <- dlit $draw_food
;j

    ;        draw();
a   <- dlit $draw
j


;;;;;;;;;;;;;;;;;;;;;;
a   <- dlit $move
j
;;;;;;;;;;;;;;;;;;;;;;

    ;        delay();
    ;
    ;        undraw_food();
;a   <- dlit $undraw_food
;j
    ;        draw();
;a   <- dlit $draw
;j

    ;        delay();
a   <- dlit $main_loop
j
    ;    }
;
;    return 0;
;}
;


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


    ;unsigned char c_x[40];
c_x:
.skip 40


    ;unsigned char c_y[40];
c_y:
.skip 40


    ;unsigned char cur_len = 3;
cur_len: .byte 3


    ;unsigned char cur_dir = 0; //right up left down
cur_dir: .byte 1

    ;unsigned char f_x = 2;
f_x: .byte 2

    ;unsigned char f_y = 2;
f_y: .byte 2


.word 0xaa55
.word 0xaa55

    ;unsigned char x,y;
x: .byte 0
y: .byte 0

.word 0xaa55
.word 0xaa55

    ;unsigned char t;
t: .byte 0

    ;unsigned char t2;
t2: .byte 0

    ;unsigned char i;
i: .byte 0;

    ;unsigned char shifts[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};
shifts:
.byte 0x01
.byte 0x02
.byte 0x04
.byte 0x08
.byte 0x10
.byte 0x20
.byte 0x40
.byte 0x80

