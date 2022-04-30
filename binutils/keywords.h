#ifndef KEYWORDS_H__
#define KEYWORDS_H__

char * keyword_dest[16] = {
/*0*/   "a",
/*1*/   "b",
/*2*/   "ml",
/*3*/   "mh",
/*4*/   "sl",
/*5*/   "sh",
/*6*/   "mem",
/*7*/   "st",
/*8*/   "op",
/*9*/   "off",
/*a*/   "zl",
/*b*/   "zh",
/*c*/   "zm",
/*d*/   "---",
/*e*/   "j_c",
/*f*/   "j"
};

char * keyword_src[16] = {
/*0*/   "a",
/*1*/   "b",
/*2*/   "alu",
/*3*/   "mem",
/*4*/   "st",
/*5*/   "lit",
/*6*/   "zm",
/*7*/   "---",
/*8*/   "---",
/*9*/   "---",
/*a*/   "---",
/*b*/   "---",
/*c*/   "dst",
/*d*/   "dlit",
/*e*/   "---",
/*f*/   "---"
};



char * alu_args[16] = {
  "add",  //0
  "sub",  //1
  "neg",  //2
  "shl",  //3
  "shlc", //4
  "inc",  //5
  "adc",  //6
  "sbc",  //7
  "not",  //8
  "and",  //9
  "or",   //a
  "xor",  //b
  "zero", //c
  "NOP",  //d
  "shr",  //e
  "shrc"  //f

};

char * alu_conds[16] = {
  "eq",  //0
  "lt",  //1
  "le",  //2
  "g",  //3
  "ge", //4
  "ne",  //5
  "---",
  "---",
  "---",
  "---",
  "---",
  "---",
  "---",
  "---",
  "---",
  "---"
};


char alu_cond_codes[16] = {
  0x11,
  0x21,
  0x31,
  0x41,
  0x51,
  0x61,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
};

#endif
