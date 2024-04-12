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
  count("nop", 1);

  emit(0x03);
}

// type 0 - reg, 1 - mreg, 2 - m+imm
void parse_mov_arg(char * token, uint8_t * value, uint8_t * type) {
  int reg = find_keyword(regs, token);
  int v = 0;
  if(reg == 0xff) {
    if(token[0] == 'r') {
      v = strtol(token+1,0,0);
      if(v > 31 || v < 0) {
        panic("Bad mreg");
      }
      *value = v;
      *type = 1;
    } else if(token[0] == '[' && token[1] == 'm') {
      v = strtol(token+2,0,0);
      if(v < -16 || v > 15) {
        panic("Too big imm offset");
      }
      *value = (uint8_t)v;
      *type = 2;
    } else {
      panic("Bad arg for mov");
    }
  } else {
    *value = reg;
    *type = 0;
  }
}

void generate_mov() {
  uint8_t dest = 0;
  uint8_t src = 0;
  uint8_t dest_type = 0; 
  uint8_t src_type = 0; //0 - reg, 1 - mreg, 2 - m+imm
  uint8_t opcode = 0;

  get_next_token();
  parse_mov_arg(token, &dest, &dest_type);

  get_next_token();
  parse_mov_arg(token, &src, &src_type);
  
  if(dest_type == 0 && dest == 0x0f) { // A<-...
    if(src_type == 0) { //A<-reg
      opcode = 0xE0 | src;
      count("mov", 1);
    } else if(src_type == 1) { //A<-mreg
      opcode = 0x80 | (src&0x1f);
      count("mov_mr", 1);
    } else if(src_type == 2) { //A<-m+imm
      opcode = 0x40 | (src&0x1f);
      count("mov_imm", 1);
    } else {
      panic("Bad mov arg type");
    }

  } else if(src_type == 0 && src == 0x0f) { // A->...
    if(dest_type == 0) { //A->reg
      opcode = 0xD0 | dest;
      count("mov", 1);
    } else if(dest_type == 1) { //A->mreg
      opcode = 0x60 | (dest&0x1f);
      count("mov_mr", 1);
    } else if(dest_type == 2) { //A->m+imm
      opcode = 0x20 | (dest&0x1f);
      count("mov_imm", 1);
    } else {
      panic("Bad mov arg type");
    }
  } else {
    panic("Bad move instruction\n");
  }

  emit(opcode);
}

void generate_push() {
  uint8_t reg = 0;
  get_next_token();
  if(!strcmp(token, "xm")) {
    emit(0xF0);
    count("push_xm", 1);
  } else {
    reg = find_keyword(regs, token);

    if(reg != 0x0f) {
      panic("Try push other than A reg");
    }
    count("push", 1);

    emit(0xD9);
  }
}

void generate_pop() {
  uint8_t reg = 0;
  get_next_token();
  if(!strcmp(token, "mx")) {
    emit(0xF1);
    count("pop_mx", 1);
  } else {
    reg = find_keyword(regs, token);

    if(reg != 0x0f) {
      panic("Try pop other than A reg");
    }

    count("pop", 1);

    emit(0xE9);
  }
}

void generate_ld() {
  uint8_t dest = 0;
  uint8_t dest_type;
  get_next_token();
  parse_mov_arg(token, &dest, &dest_type);

  if(dest_type == 0) {
    if(dest != 0x0f) {
      panic("Try ld other than A reg");
    }

    count("ld_a", 2);
    emit(0xEC);
    expect_arg_n = 1;
    expect_arg_size = 1;

  } else if(dest_type == 1) { // ld r#, #
    count("ld_r", 3);
    emit(0xDF);
    emit(dest);
    expect_arg_n = 1;
    expect_arg_size = 1;
  }

}

void generate_ldd() {
  get_next_token();
  if(token[0] == 's') {
    emit(0xDC);
  } else if(token[0] == 'm') {
    emit(0xDD);
  } else if(token[0] == 'x') {
    emit(0xDE);
  } else {
    panic("Bad ldd destination");
  }

  count("ldd", 3);

  expect_arg_n = 1;
  expect_arg_size = 2;
}

void generate_cmp() {
  panic("cmp?");emit(0xD1); //CMP SUB
}

void generate_alu(uint8_t arg) {
  emit(0xC0 | arg);
  count("alu", 1);
}

void generate_t_alu(uint8_t arg) {
  count("alu_t", 4);

  emit(0xB0 | arg);
  uint8_t ra, rb, rd;
  uint8_t ra_type, rb_type, rd_type;

  get_next_token();
  parse_mov_arg(token, &rd, &rd_type);
  get_next_token();
  parse_mov_arg(token, &ra, &ra_type);
  get_next_token();
  parse_mov_arg(token, &rb, &rb_type);

  if(rd_type != 1 || ra_type != 1 || rb_type != 1) {
    panic("Bad arg for three-address alu\n");
  }

  emit(ra);
  emit(rb);
  emit(rd);
}


void generate_jmp(uint8_t arg) {
  count("jmp", 1);
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
  } else if(!strcmp(token, "x++")) {
    count("x++", 1);
    emit(0x07);
  } else if(!strcmp(token, "hlt")) {
    count("hlt", 1);
    emit(0x00);
  } else if(!strcmp(token, "ei")) {
    count("ei", 1);
    emit(0x02);
  } else if(!strcmp(token, "di")) {
    count("di", 1);
    emit(0x01);
  } else if(!strcmp(token, "iret")) {
    count("iret", 1);
    emit(0x0f);
  } else if(!strcmp(token, "movms")) {
    count("movms", 1);
    emit(0xef);
  } else if(!strcmp(token, "movsm")) {
    count("movsm", 1);
    emit(0xee);
  } else if((arg = find_keyword(alu_args, token)) != 0xFF) {
    generate_alu(arg);
  } else if((arg = find_keyword(jumps, token)) != 0xFF) {
    generate_jmp(arg);
  } else if((arg = find_keyword(alu_args, token+1)) != 0xFF) {
    generate_t_alu(arg);
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

      } else if(!strcmp(&token[1], "align")) {
        uint16_t align = 0;
        get_next_token();
        align = strtol(token,0,0);

        current_section->data_pos += (align - (current_section->data_pos % align)) % align;

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
  print_counts();
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
