//#define LINUX


#define WIDTH 8
#define HEIGHT 8

#ifdef LINUX

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

        /* disable echoing the char as it is typed */
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


void delay() {
    usleep(100*1000);
}

char getch() {
    return mygetch();
}

void draw_frame(unsigned char * fb) {
    printf("\033[2J\033[H");
    for(int r = 0; r<HEIGHT; r++) {
        for(int c = 0; c<WIDTH; c++) {
            if(fb[r*WIDTH + c]) {
                putchar('#');
            } else {
                putchar(' ');
            }
        }
        putchar('\n');
    }
}

#else

void puts(char * s) {
    while(*s) {
        *(unsigned char *)(0x4803) = *s;
        s++;
    }
}


void printhex(int i) {
    char printnum_buffer[8];
	char * s = printnum_buffer + 7;
	char n_rem;
	char n;
    *s = 0;
	s--;

    n = i & 0x000f;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    n = i & 0x00f0;
    n = n >> 4;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    i = i >> 8;

    n = i & 0x000f;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

    n = i & 0x00f0;
    n = n >> 4;
    if(n > 9) {
        *s = n + 'a' - 10;
    } else {
        *s = n + '0';
    }
    s--;

	*s = 'x';
	s--;
	*s = '0';
	puts(s);
}

/*reverse order of arguments!*/
int fxnLShift(int n, int v) {
    while(n) {

        v = v<<1;
        n--;
    }

    return v;
}

void delay() {

}

char mygetch() {
   char c = *(unsigned char *)(0x4803);
   if(c == 0xff) c = 0;
   return c;
}

void draw_frame(unsigned char * fb) {
    unsigned char * lcd_array = (unsigned char *)(0x4000);
    for(unsigned char r = 0; r<HEIGHT; r++) {
        unsigned char lcd_row = 0;
        for(unsigned char c = 0; c<WIDTH; c++) {
            if(fb[r*WIDTH + c]) {
                lcd_row |= (1 << (7-c));
            } else {
            }
        }
        lcd_array[r] = lcd_row;
    }
}
#endif

unsigned char fb[WIDTH*HEIGHT];

typedef struct Point {
    char x;
    char y;
} Point_t;

unsigned char pt_equal(Point_t * pt1, Point_t * pt2) {
    if(pt1->x == pt2->x && pt1->y == pt2->y) {
        return 1;
    } else {
        return 0;
    }
}
#define MAX_SNAKE_LENGTH WIDTH*HEIGHT

typedef struct Snake {
    Point_t direction;
    unsigned char length;
    Point_t pts[MAX_SNAKE_LENGTH];
} Snake_t;

Snake_t snake;

Point_t food;

unsigned char prev_rnd;

unsigned char m_rand() {
    prev_rnd = prev_rnd + 3;
    return prev_rnd&0x7;
}


void gen_food() {
    unsigned char again = 1;
    while(again) {
        food.x = m_rand();
        food.y = m_rand();
        again = 0;
        for(unsigned char i = 0; i<snake.length; i++) {
            if(pt_equal(&food, &snake.pts[i])) {
                again = 1;
                break;
            }
        }
    }
}

void init_game() {
    snake.length = 3;
    snake.pts[0].x = 4; snake.pts[0].y = 5;
    snake.pts[1].x = 4; snake.pts[1].y = 6;
    snake.pts[2].x = 4; snake.pts[2].y = 7;
    snake.direction.x = 1;
    snake.direction.y = 0;

    gen_food();
}

unsigned char move_snake() {
    Point_t new_head;
    new_head.x = snake.pts[0].x + snake.direction.x;
    new_head.y = snake.pts[0].y + snake.direction.y;

    if(new_head.x < 0) new_head.x = WIDTH-1;
    if(new_head.x >= WIDTH) new_head.x = 0;

    if(new_head.y < 0) new_head.y = HEIGHT-1;
    if(new_head.y >= HEIGHT) new_head.y = 0;

    if(pt_equal(&new_head, &food)) {
        snake.length++;
        gen_food();
    }

    for(unsigned char i = snake.length-1; i>0; i--) {
        snake.pts[i].x = snake.pts[i-1].x;
        snake.pts[i].y = snake.pts[i-1].y;
        if(pt_equal(&snake.pts[i], &new_head)) {
            return 1;
        }
    }

    snake.pts[0].x = new_head.x;
    snake.pts[0].y = new_head.y;
    return 0;
}

void render(unsigned char render_food) {
    for(unsigned char i = 0; i<WIDTH*HEIGHT; i++) {
        fb[i] = 0;
    }

    for(unsigned char i = 0; i<snake.length; i++) {
        fb[snake.pts[i].y * WIDTH + snake.pts[i].x] = 1;
    }
    if(render_food) {
        fb[food.y * WIDTH + food.x] = 1;
    }
}

char autopilot;

void change_direction() {
    if(autopilot) {

    } else {
        char c = mygetch();
        if(c == 'a') {
            snake.direction.x = -1;
            snake.direction.y = 0;
        } else if(c == 'd') {
            snake.direction.x = 1;
            snake.direction.y = 0;
        } else if(c == 'w') {
            snake.direction.x = 0;
            snake.direction.y = -1;
        } else if(c == 's') {
            snake.direction.x = 0;
            snake.direction.y = 1;
        }
    }
}

void show_defeat() {
    for(char i = 0; i<WIDTH*HEIGHT; i++) {
        fb[i] = 1;
    }
    draw_frame(fb);

    for(char i = 0; i<10; i++) {
        delay();
    }
}

void loop() {
    while(1) {
        change_direction();
        if(move_snake()) break;
        render(1);
        draw_frame(fb);
        delay();
        render(0);
        draw_frame(fb);
        delay();
    }

    
}

void test_fb() {
    for(char i = 0; i<WIDTH*HEIGHT/2; i++) {
        fb[i]   = 0;
    }

    fb[0]  = 1;
    fb[9]  = 1;
    fb[18] = 1;
    fb[27] = 1;
    fb[36] = 1;
    fb[45] = 1;
    fb[54] = 1;
    fb[63] = 1;

    fb[0*8 + 7]  = 1;
    fb[1*8 + 6]  = 1;
    fb[2*8 + 5]  = 1;
    fb[3*8 + 4]  = 1;
    fb[4*8 + 3]  = 1;
    fb[5*8 + 2]  = 1;
    fb[6*8 + 1]  = 1;
    fb[7*8 + 0]  = 1;

}

int main() {

/*
    test_fb();

    draw_frame(fb);
    delay();

    asm("hlt\n");
*/
    autopilot = 0;
    while(1) {
        init_game();
        loop();
        show_defeat();
    }
}