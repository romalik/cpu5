#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "sections.h"
#include "util.h"
#include "constants.h"
#include <assert.h>


struct constant_entry * find_constant(char * name, struct constant_entry * list[], uint8_t create) {
  int i;
  struct constant_entry * e;
  for(i = 0; i<MAX_CONSTANTS; i++) {
    if(list[i] == 0) {
      break;      
    } else {
      if(!strcmp(list[i]->name, name)) {
        return list[i];
      }
    }
  }

  if(create) {
    if(i < MAX_CONSTANTS) {
      list[i] = (struct constant_entry *)malloc(sizeof(struct constant_entry));
      strcpy(list[i]->name, name);
      return list[i];
    }
  }


  return 0;
}

