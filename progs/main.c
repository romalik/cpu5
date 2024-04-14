int putc(char c) {
    *(unsigned char *)(0x4803) = c;
}

void puts(char * s) {
    while(*s) {
        *(unsigned char *)(0x4803) = *s;
        s++;
    }
}

int strcmp(const char *s1, const char *s2)
{
	const unsigned char *c1 = (const unsigned char *)s1;
	const unsigned char *c2 = (const unsigned char *)s2;
	unsigned char ch;
	int d = 0;

	while (1) {
		d = (int)(ch = *c1++) - (int)*c2++;
		if (d || !ch)
			break;
	}

	return d;
}

void printhex(int i) {
    char printnum_buffer[8];
	char * s = printnum_buffer + 7;
	char n_rem;
	char n;
   *s = 0;
	s--;

   n = i;
	if(n == 0) {
		*s = '0';
		s--;
	}

	while(n) {
		n_rem = n & 0x0f;
		if(n_rem > 9) {
			*s = n_rem + 'A' - 10;
		} else {
			*s = n_rem + '0';
		}
		n = n >> 4;
		s--;
	}

   n = (i>>8);
	if(n == 0) {
		*s = '0';
		s--;
	}

	while(n) {
		n_rem = n & 0x0f;
		if(n_rem > 9) {
			*s = n_rem + 'A' - 10;
		} else {
			*s = n_rem + '0';
		}
		n = n >> 4;
		s--;
	}




	*s = 'x';
	s--;
	*s = '0';
	puts(s);
}
void tests() {
   puts("Should print 5As nad 5Bs twice\n");
   for(char i = 0; i<10; i++) {
      if(i < 5) {
         putc('A');
      } else {
         putc('B');
      }
   }
   putc('\n');

   for(int i = 0; i<10; i++) {
      if(i < 5) {
         putc('A');
      } else {
         putc('B');
      }
   }
   putc('\n');

   puts("Print 0x1234:\n");
   printhex(0x1234);
   putc('\n');

   puts("Compare 'str1' and 'str2', should print not-zero\n");
   printhex(strcmp("str1","str2"));
   putc('\n');

   puts("Compare 'str3' and 'str3', should print zero\n");
   printhex(strcmp("str3","str3"));
   putc('\n');

   if(!strcmp("str1","str2")) {
      puts("This line should NOT be printed\n");
   }

   if(strcmp("str1","str2")) {
      puts("This line SHOULD be printed\n");
   }

   int count = 10;

   if(count < 50) {
      puts("1.Pass\n");
   } else {
      puts("1.Fail\n");
   }

   count = 100;

   if(count < 50) {
      puts("2.Fail\n");
   } else {
      puts("2.Pass\n");
   }

   count = -1;
   if(count < 0) {
      puts("3.Pass\n");
   } else {
      puts("3.Fail\n");
   }

}


void main() {
    puts("Hello world!\n");
    puts("This is a test string\n");
    tests();
    puts("Tests done. Halt.\n");
    asm("hlt\n");
}
