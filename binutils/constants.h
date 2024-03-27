#ifndef CONSTANTS_H__
#define CONSTANTS_H__

#include <stdint.h>

#define MAX_CONSTANTS 256

struct constant_entry {
  char name[64];
  uint16_t value;
};


struct constant_entry * find_constant(char * name, struct constant_entry * list[], uint8_t create);


#endif