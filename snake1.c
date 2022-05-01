#include <stdio.h>
#include <termios.h>
#include <fcntl.h> 
#include <unistd.h>
#include <stdlib.h>


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



unsigned char fb[8];
unsigned char c_x[40];
unsigned char c_y[40];
unsigned char cur_len = 3;
unsigned char cur_dir = 0; //right up left down

unsigned char f_x = 2;
unsigned char f_y = 2;
unsigned char x,y;
unsigned char t;
unsigned char t2;
unsigned char i;

unsigned char shifts[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};


void check_control() {
    t = mygetch();
    if(t == 'd') cur_dir = 0;
    if(t == 'w') cur_dir = 1;
    if(t == 'a') cur_dir = 2;
    if(t == 's') cur_dir = 3;
}

void move() {
    t = cur_len;
    t2 = cur_len - 1;

move_loop:
    c_x[t] = c_x[t2];
    c_y[t] = c_y[t2];
    t--;
    t2--;

    if(t > 0) goto move_loop;


    x = c_x[0];
    y = c_y[0];

    if(cur_dir == 0) x++;
    if(cur_dir == 1) y--;
    if(cur_dir == 2) x--;
    if(cur_dir == 3) y++;

    x = x & 0x07;
    y = y & 0x07;

    c_x[0] = x;
    c_y[0] = y;


    if(f_x != x) goto end_food;
    if(f_y != y) goto end_food;

    cur_len++;

    f_x = f_x | 0xf0;
    f_y = f_y | 0xf0;

end_food:

    t = fb[y];
    t2 = shifts[x];

    if((t & t2) != 0) {
        exit(1);
    } 

    if((f_x & 0x10) == 0) goto end_move;

 
    f_x += 10;
    f_x = f_x & 0x07;


    f_y += 14;
    f_y = f_y & 0x07;

end_move:
    return;
}


void update_fb() {
    i = 0;
loop_fb_clear:

    *(fb + i) = 0;

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
    t = *(fb + f_y);
    t2 = *(shifts + f_x);

    t = t | t2;

    *(fb + f_y) = t;

}

void undraw_food() {
    t = *(fb + f_y);
    t2 = *(shifts + f_x);

    t2 = ~t2;

    t = t & t2;

    *(fb + f_y) = t;
}


void draw() {
    unsigned char c = 0;
    unsigned char r = 0;
    printf("%c[1J%c[H", 0x1b, 0x1b);
    printf("\n.________.\n");
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
    c_x[0] = 4;
    c_y[0] = 4;

    c_x[1] = 3;
    c_y[1] = 4;

    c_x[2] = 2;
    c_y[2] = 4;

    f_x = 1;
    f_y = 1;


//    generate_food();
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
