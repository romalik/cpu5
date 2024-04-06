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
  "test", //"test_a",//d <<<DOESNT WORK
  "shr",  //e
  "shrc"  //f

};


/*
0 0 000    JNE(JNZ)        ZF = 0	
1 0 001    JAE(JNB/JNC)    CF = 0
2 0 010    JG(JNLE)        ZF = 0 and SF = OF	
3 0 011    JA(JNBE)        CF = 0 and ZF = 0
4 0 100    JGE(JNL)        SF = OF	
8 1 000    JE(JZ)          ZF = 1	
9 1 001    JB(JNAE/JC)	   CF = 1
A 1 010    JLE(JNG)        ZF = 1 or SF != OF
B 1 011    JBE(JNA)        CF = 1 or ZF = 1
C 1 100    JL(JNGE)        SF != OF	

F 1 111    JMP
*/
char * jumps[16] = {
/*0*/  "jnz",
/*1*/  "jnc",
/*2*/  "jg",
/*3*/  "ja",
/*4*/  "jge",
/*5*/  "---",
/*6*/  "---",
/*7*/  "---",
/*8*/  "jz",
/*9*/  "jc",
/*A*/  "jle",
/*B*/  "jbe",
/*C*/  "jl",
/*D*/  "---",
/*E*/  "---",
/*F*/  "jmp"
};


#endif
