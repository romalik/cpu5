#include <stdio.h>
#include <termios.h>
#include <fcntl.h> 
#include <unistd.h>

char fb[8];

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



void update_fb() {
    unsigned char iterator = 0;
    fb[0] = 0;
    fb[1] = 0;
    fb[2] = 0;
    fb[3] = 0;
    fb[4] = 0;
    fb[5] = 0;
    fb[6] = 0;
    fb[7] = 0;

    while(1) {
        unsigned char x;
        unsigned char y;
        unsigned char c_self;
        x = self[iterator];
        iterator++;
        y = self[iterator];
        iterator++;

        fb[y] = fb[y] | (1 << x);
        if(iterator >= current_length)
            break;
    }


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
