#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <stdlib.h>
#include "sections.h"
#include "labels.h"
#include "util.h"
#include "token.h"
#include "keywords.h"
#include "robj.h"

#include <assert.h>

#define panic(msg) panic_full((msg), __FILE__, __LINE__, current_line, token)

struct section * sections[MAX_SECTIONS];

struct section * current_section = NULL;

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


void gen_instruction() {
  char keyword_id;
  char arg_id;
  uint8_t opcode = 0;

  expect_arg_n = 0;
  expect_arg_size = 0;


  keyword_id = find_keyword(keyword_dest, token);
  if(keyword_id < 16) {
    opcode = keyword_id;
    switch(keyword_id) {
      case 0xe: /* J_COND */
      case 0xf: /* J */

        emit(opcode);
        return;
      
      default:
        break;
    }
  } else {
    panic("Bad destination");
  }

  get_next_token();
 
  if(!strcmp(token, "<-")) get_next_token();
 
  keyword_id = find_keyword(keyword_src, token);
  if(keyword_id < 16) {
    opcode = opcode | (keyword_id << 4);
    emit(opcode);

    switch(keyword_id) {
      case 0x5: /* LIT */
        expect_arg_n = 1;
        expect_arg_size = 1;
        break;
      case 0xd: /* DLIT */
        expect_arg_n = 1;
        expect_arg_size = 2;
        break;      
      default:
        break;
    }

  } else {
    panic("Bad source");
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
    } else if((kw_id = find_keyword(alu_args, token)) < 16) {
      //alu operation
      if(expect_arg_size == 2) {
        panic("Unexpected alu op!");
      }
      if(expect_arg_size == 1) {
        emit(low(kw_id));
      }
      if(!expect_arg_size) {
        panic("Unexpected alu op!");
      }
      expect_arg_n--;
    } else if((kw_id = find_keyword(alu_conds, token)) < 16) {
      //alu operation condition
      if(expect_arg_size == 2) {
        panic("Unexpected alu cond!");
      }
      if(expect_arg_size == 1) {
        emit(low(alu_cond_codes[kw_id]));
      }
      if(!expect_arg_size) {
        panic("Unexpected alu cond!");
      }
      expect_arg_n--;
    } else  {
      if(expect_arg_n) {
        panic("Arguments expected");
      }
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
