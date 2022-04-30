#include <stdio.h>
#include <termios.h>
#include <fcntl.h> 
#include <unistd.h>


/* platform */
int mygetch() {
        char ch;
        int error;
        static struct termios Otty, Ntty;

        int oldf; 

        fflush(stdout);
        tcgetattr(0, &Otty);
        Ntty = Otty;

        Ntty.c_iflag  =  0;     /* input mode       */
        Ntty.c_oflag  =  0;     /* output mode      */
        Ntty.c_lflag &= ~ICANON;    /* line settings    */
        Ntty.c_lflag &= ~ECHO;  /* disable echo     */

        Ntty.c_cc[VMIN]  = CMIN;    /* minimum chars to wait for */
        Ntty.c_cc[VTIME] = CTIME;   /* minimum wait time    */

        #define FLAG TCSANOW
        oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
        fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);
        if ((error = tcsetattr(0, FLAG, &Ntty)) == 0) {
                error  = read(0, &ch, 1 );        /* get char from stdin */
                error += tcsetattr(0, FLAG, &Otty);   /* restore old settings */
                fcntl(STDIN_FILENO, F_SETFL, oldf);
        }

            return (error == 1 ? (int) ch : -1 );
}



char fb[8];
char c_x[10];
char c_y[10];
char cur_len = 3;

char f_x = 2;
char f_y = 2;
char x,y;
char t;
char t2;
char i;

char shifts[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};



void update_fb() {
    i = 0;
/*
ml  <- dlit $i
a   <- lit 0
mem <- a
*/
loop_fb_clear:

    *(fb + i) = 0;
/*
ml  <- dlit $i
a   <- dlit $fb
b   <- mem
op  <- lit add
st  <- alu
a   <- dlit $fb
a   <- lit 0
op  <- adc
st  <- alu

a   <- lit 0

mh  <- st
ml  <- st
mem <- a
*/


    i++;
    if(i<8) goto loop_fb_clear;

    i = 0;
loop_fb_snake:
    x = *(c_x + i);
    y = *(c_y + i);

    t = *(shifts + x);

    t2 = *(fb + y);
    t2 = t2 | t;

    *(fb + y) = t2;
    
    i++;
    if(i<cur_len) goto loop_fb_snake;

}

void draw_food() {
    fb[food_y] = fb[food_y] | (1 << food_x);
}

void undraw_food() {
    fb[food_y] = fb[food_y] & (~(1 << food_x));
}


void draw() {
    unsigned char c = 0;
    unsigned char r = 0;
    printf("%c[1J%c[H", 0x1b, 0x1b);
    printf("Length: %d\n.________.\n", current_length/2);
    for(r = 0; r < 8; r++) {
    	printf("|");
        for(c = 0; c < 8; c++) {
            printf("%s", (fb[r] & (1<<c))?"*":" ");
        }
        printf("|\n");
    }
    printf("^^^^^^^^^^\n");

}

void delay() {
    usleep(200*1000);
}


int main() {
    self[0] = 0b00000100;
    self[1] = 0b00000100;

    self[2] = 0b00000011;
    self[3] = 0b00000100;

    self[4] = 0b00000010;
    self[5] = 0b00000100;
   /* 
    self[6] = 0b00000001;
    self[7] = 0b00000100;
    
    self[8] = 0b00000000;
    self[9] = 0b00000100;
    
    self[10] = 0b00000000;
    self[11] = 0b00000101;

    self[12] = 0b00000000;
    self[13] = 0b00000110;
*/

    generate_food();
    while(1) {
        check_control();
        move();
        update_fb();

        draw_food();
        draw();
        delay();
        undraw_food();
        draw();
        delay();
    }

    return 0;
}
