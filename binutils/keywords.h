#ifndef KEYWORDS_H__
#define KEYWORDS_H__


char * regs[16] = {
/*0*/   "b",
/*1*/   "sl",
/*2*/   "sh",
/*3*/   "ml",
/*4*/   "mh",
/*5*/   "off",
/*6*/   "xl",
/*7*/   "xh",
/*8*/   "[m]",
/*9*/   "[s]",
/*a*/   "f",
/*b*/   "[x]",
/*c*/   "---",
/*d*/   "---",
/*e*/   "---",
/*f*/   "a"
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
  "---", //"test_a",//d <<<DOESNT WORK
  "shr",  //e
  "shrc"  //f

};

char * jumps[16] = {
  "jmp",
  "jz",
  "jnz",
  "jc",
  "jnc",
  "jeq",
  "jlt",
  "jle",
  "jgt",
  "jge",
  "jne",
  "---",
  "---",
  "---",
  "---",
  "---"
};


#endif
