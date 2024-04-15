#ifndef KEYWORDS_H__
#define KEYWORDS_H__


char * regs[16] = {
/*0*/   "B",
/*1*/   "SL",
/*2*/   "SH",
/*3*/   "ML",
/*4*/   "MH",
/*5*/   "---",
/*6*/   "XL",
/*7*/   "XH",
/*8*/   "---",
/*9*/   "[S]",
/*a*/   "F",
/*b*/   "[X]",
/*c*/   "---",
/*d*/   "---",
/*e*/   "---",
/*f*/   "A"
};


char * alu_args[16] = {
/*0000*/  "add",
/*0001*/  "adc",
/*0010*/  "sub",
/*0011*/  "sbc",
/*0100*/  "inc",
/*0101*/  "neg",
/*0110*/  "not",
/*0111*/  "----",
/*1000*/  "or",
/*1001*/  "xor",
/*1010*/  "and",
/*1011*/  "----",
/*1100*/  "shl",
/*1101*/  "shlc",
/*1110*/  "shr",
/*1111*/  "shrc"

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
