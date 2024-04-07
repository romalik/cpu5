#include "util.h"
#include "labels.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void panic_full(char * msg, char * c_file, int c_line, int current_line, char * token) {
  printf("Error (%s:%d): \"%s\" at line %d near \"%s\"\n", c_file, c_line, msg, current_line, token);
  exit(1);
}

#define panic(msg) panic_full((msg), __FILE__, __LINE__)


int find_keyword(char * kw[], char * str) {
  char i;
  for(i = 0; i<16; i++) {
    if(!strcmp(kw[i], str)) {
      return i;
    }
  }
  return 0xff;
}


void hexdump(uint8_t * data, uint16_t length) {
  uint16_t i = 0;
  uint8_t j = 0;
  printf("Image:\n");
  for(i = 0; i<length; i+=16) {
    printf("0x%04x\t", i);
    for(j = 0; j<16; j++) {
      printf("%02x ", (data[i+j] & 0xff));
      if(j == 7) printf(" ");
    }
    printf("\n");
  }
}



typedef struct map {
  char key[32];
  int value;
  struct map * next;
} map_t;


map_t * kw_map = NULL;

void count(char * key) {
  map_t ** e = (&kw_map);
  while((*e)) {
    if(!strcmp((*e)->key, key)) break;
    e = &((*e)->next);
  }

  if((*e)) {
    (*e)->value++;
  } else {
    (*e) = (map_t *)malloc(sizeof(map_t));
    (*e)->value = 1;
    strcpy((*e)->key, key);
    (*e)->next = NULL;
  }
}

void print_counts() {
  map_t * e = kw_map;
  printf("Count:\n");
  while(e) {
    printf("\t%s:\t%d\n", e->key, e->value);
    e = e->next;
  }
}