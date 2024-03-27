#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <stdlib.h>
#include "sections.h"
#include "labels.h"
#include "constants.h"
#include "util.h"
#include "token.h"
#include "keywords.h"
#include "robj.h"

#include <assert.h>

#define panic(msg) panic_full((msg), __FILE__, __LINE__, current_line, token)

struct section * sections[MAX_SECTIONS];

struct section * current_section = NULL;

struct constant_entry * constants[MAX_CONSTANTS];

int n_sections = 0;

#define S_TEXT 0
#define S_DATA 1

char is_section_executable(char * name) {
  if(!strncmp(name, "text", 4)) {
    return 1;
  } else if(!strcmp(name, "start_section")) {
    return 1;
  } else {
    return 0;
  }
}

struct section * create_section(char * sect_name) {
  struct section * retval = NULL;
  if(n_sections < MAX_SECTIONS) {
    sections[n_sections] = (struct section *)malloc(sizeof(struct section));
    strncpy(sections[n_sections]->name, sect_name, SECTION_NAME_SIZE - 1);
    sections[n_sections]->name[SECTION_NAME_SIZE - 1] = 0;
    memset(sections[n_sections]->label_vec, 0, MAX_LABEL_VEC_SIZE);
    sections[n_sections]->data_pos = 0;
    sections[n_sections]->label_vec_pos = 0;
    sections[n_sections]->label_mask_pos = 0;
    sections[n_sections]->executable = is_section_executable(sect_name);
    retval = sections[n_sections];

    n_sections++;
  } else {
    fprintf(stderr, "MAX_SECTIONS exceeded\n");
    exit(1);
  }
  return retval;
}

void select_section(char * sect_name) {
  int i;
  for(i = 0; i<n_sections; i++) {
    if(!strcmp(sect_name, sections[i]->name)) {
      current_section = sections[i];
      return;
    }
  }
  current_section = create_section(sect_name);
}


void emit(uint8_t opcode) {
  if(!current_section) {
    panic("No section selected!");
  }
  current_section->data[current_section->data_pos] = opcode;
  current_section->data_pos++;
  if(current_section->data_pos > 65534) {
    fprintf(stderr, "Section %s overflow\n", current_section->name);
    panic("Section overflow");
  }
}

char expect_arg_n = 0;
char expect_arg_size = 0;


void generate_nop() {
  emit(0x00);
}

void generate_mov() {
  uint8_t dest = 0;
  uint8_t src = 0;
  uint8_t is_mreg = 0;
  uint8_t opcode = 0;
  get_next_token();
  dest = find_keyword(regs, token);
  
  if(dest == 0xff) {
    if(token[0] == 'r') {
      dest = strtol(token+1,0,0);
      if(dest > 31) {
        panic("Bad mreg");
      }
      dest = dest | 0x80;
      is_mreg = 1;
    }
  }
  if(dest == 0xff) {
    panic("Bad dest register");
  }

  get_next_token();
  src = find_keyword(regs, token);
  
  if(src == 0xff) {
    if(token[0] == 'r') {
      if(is_mreg) {
        panic("Mov two mreg");
      }
      src = strtol(token+1,0,0);
      if(src > 31) {
        panic("Bad mreg");
      }
      src = src | 0x80;
      is_mreg = 1;
    }
  }

  if(src == 0xff) {
    panic("Bad src register");
  }

  if(dest != 0x0f) {
    if(src != 0x0f) {
      panic("Dest or src register must be A");
    }
  }

  if(dest == src) {
    panic("Register dest equals src");
  }

  if(is_mreg) {
    if(src == 0x0f) { // A->r??
      opcode = 0x60 | (dest&0x1f);
    }
    if(dest == 0x0f) { // A<-r??
      opcode = 0x80 | (src&0x1f);
    }
  } else {
    if(src == 0x0f) { // A->??
      opcode = 0x20 | dest;
    }
    if(dest == 0x0f) { // A<-??
      opcode = 0x40 | src;
    }
  }
  emit(opcode);
}

void generate_push() {
  uint8_t reg = 0;
  get_next_token();
  reg = find_keyword(regs, token);

  if(reg != 0x0f) {
    panic("Try push other than A reg");
  }

  emit(0x29);
}

void generate_pop() {
  uint8_t reg = 0;
  get_next_token();
  reg = find_keyword(regs, token);

  if(reg != 0x0f) {
    panic("Try pop other than A reg");
  }

  emit(0x4f); // S++
  emit(0x49); // A <- (S)
}

void generate_ld() {
  uint8_t reg = 0;
  get_next_token();
  reg = find_keyword(regs, token);

  if(reg != 0x0f) {
    panic("Try ld other than A reg");
  }
  emit(0x4C);
  expect_arg_n = 1;
  expect_arg_size = 1;
}

void generate_ldd() {
  uint8_t reg = 0;
  get_next_token();
  if(token[0] == 's') {
    reg = 0;
  } else if(token[0] == 'm') {
    reg = 1;
  } else if(token[0] == 'x') {
    reg = 2;
  } else {
    panic("Bad ldd destination");
  }
  emit(0xE0 | reg);
  expect_arg_n = 1;
  expect_arg_size = 2;
}

void generate_cmp() {
  emit(0xD1); //CMP SUB
}

void generate_alu(uint8_t arg) {
  emit(0xC0 | arg);
}

void generate_jmp() {
  uint8_t arg = 0;
  if(!strcmp(token, "jmp")) {
    arg = 0x0f;
  } else if(!strcmp(token, "jc")) {
    arg = 0x01;
  } else if(!strcmp(token, "jnc")) {
    arg = 0x04;
  } else if(!strcmp(token, "jz")) {
    arg = 0x02;
  } else if(!strcmp(token, "jnz")) {
    arg = 0x08;
  } else {
    panic("Bad jump");
  }

  emit(0xA0 | arg);
}

void gen_instruction() {
  uint8_t arg = 0;

  expect_arg_n = 0;
  expect_arg_size = 0;

  if(!strcmp(token, "nop")) {
    generate_nop();
  } else if(!strcmp(token, "mov")) {
    generate_mov();
  } else if(!strcmp(token, "push")) {
    generate_push();
  } else if(!strcmp(token, "pop")) {
    generate_pop();
  } else if(!strcmp(token, "ld")) {
    generate_ld();
  } else if(!strcmp(token, "ldd")) {
    generate_ldd();
  } else if(!strcmp(token, "cmp")) {
    generate_cmp();
  } else if(!strcmp(token, "hlt")) {
    emit(0x03);
  } else if(!strcmp(token, "ei")) {
    emit(0x02);
  } else if(!strcmp(token, "di")) {
    emit(0x01);
  } else if(!strcmp(token, "iret")) {
    emit(0x1f);
  } else if((arg = find_keyword(alu_args, token)) != 0xFF) {
    generate_alu(arg);
  } else if((arg = find_keyword(jumps, token)) != 0xFF) {
    generate_jmp();
  } else {
    panic("Bad token");
  }
}

void assemble() {
  char token_length = 0;
  uint8_t byte_literal;
  uint16_t word_literal;
  int kw_id = 0;

  while(1) {
    token_length = get_next_token();
    //printf("token '%s'\n", token);
    if(token[0] == ';') {
      skip_comment();
      continue;
    }

    if(eof_hit) break;

    if(token[token_length - 1] == ':') {
      //printf("Got label %s\n", token);
      token[token_length - 1] = 0;
      mark_label_position(token, current_section->data_pos, current_section);
    } else if(token[0] == '.') {
      //directive

      if(expect_arg_n) panic("Arguments expected");

      if(!strcmp(&token[1], "org")) {
        get_next_token();
        current_section->data_pos = strtol(token,0,0);
      } else if(!strcmp(&token[1], "byte")) {
        expect_arg_size = 1;
        expect_arg_n = 1;

      } else if(!strcmp(&token[1], "word")) {
        expect_arg_size = 2;
        expect_arg_n = 1;

      } else if(!strcmp(&token[1], "ascii")) {
        int c;
        while((c = get_quoted_text()) >= 0) {
          emit(c);
        }
      } else if(!strcmp(&token[1], "skip")) {
        get_next_token();
        current_section->data_pos += strtol(token,0,0);

      } else if(!strcmp(&token[1], "section")) {
        get_next_token();
        select_section(token);

      } else if(!strcmp(&token[1], "const")) {
        struct constant_entry * e = NULL;
        get_next_token();
        e = find_constant(token, constants, 1);
        if(!e) {
          panic("Constant list overflow");
        }        
        get_next_token();
        e->value = strtol(token,0,0);
      } else if(!strcmp(&token[1], "export")) {
        get_next_token();
        mark_label_export(token, current_section);


      } else if(!strcmp(&token[1], "import")) {
        int i;
        get_next_token();
        for(i = 0; i<n_sections; i++) {
          mark_label_import(token, sections[i]);
        }

      } else {
        printf("Directive: %s\n", token);
        panic("Bad directive");
      }

    } else if(token[0] == '$') {
      //label
      uint16_t label_id;
      int half_word = 0;
      int label_start = 1;

      if(strlen(token) > 4) {
        if(token[1] == '(') {
          if(token[2] == 'l') half_word = 1;
          if(token[2] == 'h') half_word = 2;
          label_start = 4;
        }
      }

      label_id = mark_label_use(&token[label_start], current_section->data_pos, current_section, half_word);

      if(half_word) {
        if(expect_arg_size != 1) { panic("Wrong label size"); }
      } else {
        if(expect_arg_size != 2) { panic("Wrong label size"); }
      }

      emit(0); // placeholder for label
      if(!half_word) emit(0);

      expect_arg_size = 0;
      expect_arg_n--;

    } else if(token[0] == '\'') {
      //literal char
 
      emit(token[1]);
      if(expect_arg_size > 1) {
        emit(0);
      }
      if(!expect_arg_size) {
        panic("Unexpected literal char!");
      }
      expect_arg_n--;
    } else if((token[0] >= '0' && token[0] <= '9') || token[0] == '-') {
      //literal
      word_literal = strtol(token,0,0);
      if(expect_arg_size == 2) {
        emit(low(word_literal));
        emit(high(word_literal));
      }
      if(expect_arg_size == 1) {
        emit(low(word_literal));
      }
      if(!expect_arg_size) {
        panic("Unexpected literal!");
      }
      expect_arg_n--;
    } else if(expect_arg_n) {
      struct constant_entry * e = NULL;
      e = find_constant(token, constants, 0);
      if(e) {
        if(expect_arg_size == 2) {
          emit(low(e->value));
          emit(high(e->value));
        }
        if(expect_arg_size == 1) {
          emit(low(e->value));
        }
      } else {
        panic("Arguments expected");
      }
      expect_arg_n--;
    } else {
      gen_instruction();
    }

  }
  if(expect_arg_n) {
    panic("Hit eof expecting args");
  }

}


char * infile_name;
char * outfile_name;

int main(int argc, char ** argv) {
  int i;
  FILE * infile;
  FILE * outfile;
  struct robj_header header;
  if(argc < 3) {
    printf("Usage: %s infile outfile\n", argv[0]);
    exit(1);
  }


  memset(constants, 0, MAX_CONSTANTS * sizeof(struct constant_entry *));

  infile_name = argv[1];
  outfile_name = argv[2];

  infile = fopen(infile_name, "r");

  parser_set_file(infile);


  assemble();
/*
  for(i = 0; i<n_sections; i++) {
    printf("section %s: %d bytes\n", sections[i]->name, sections[i]->data_pos);
  }

  for(i = 0; i<n_sections; i++) {
    printf("section %s:\n", sections[i]->name);
    print_labels(sections[i]->label_vec);
  }
*/

  //print_labels(label_vec);
  //print_label_usage(get_label_usage_list_size());
  //hexdump(image, current_pos);

/*
  linker_init();

  linker_add_image(image, label_vec, label_usage_list, current_pos, get_label_vec_size(), get_label_usage_list_size());

  linker_offset_labels();
  linker_link();
*/
  //hexdump(image, current_pos);

  fclose(infile);


  outfile = fopen(outfile_name, "wb");


  memcpy(header.signature, ROBJ_SIGNATURE, 4);
  header.type = ROBJ_TYPE_OBJECT;
  header.n_sections = n_sections;

  fwrite(&header, 1, sizeof(struct robj_header), outfile);


  for(i = 0; i<n_sections; i++) {
    serialize_section(sections[i], outfile);
  }


  fclose(outfile);
  return 0; 
}
