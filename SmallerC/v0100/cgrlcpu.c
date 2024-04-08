/*
Copyright (c) 2012-2014, Alexey Frunze
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the FreeBSD Project.
*/

/*****************************************************************************/
/*                                                                           */
/*                                Smaller C                                  */
/*                                                                           */
/*       A simple and small single-pass C compiler ("small C" class).        */
/*                                                                           */
/*                 Tweaked for the 'Sweet32' minimal-RISC CPU                */
/*                         by Valentin Angelovski                            */
/*                   (work-in-progress date: 28/12/2014)                     */
/*****************************************************************************/
#ifndef __SMALLER_C__
#define STUB printf2("Stub for %s on line %d of file %s\n", \
                     __func__, __LINE__, __FILE__);
#else
#define STUB printf2("Stub");

#endif

#include "tree.h"

STATIC void GenPrintNumLabel(int label);
STATIC void GenNumLabel(int Label);

/*
`GenAddrData'
`GenDumpChar'
`GenExpr'
`GenFin'
`GenFxnEpilog'
`GenFxnProlog'
`GenFxnSizeNeeded'
`GenInit'
`GenInitFinalize'
`GenInitParams'
`GenIntData'
`GenJumpIfEqual'
`GenJumpIfNotZero'
`GenJumpIfZero'
`GenJumpUncond'
`GenLabel'
`GenMaxLocalsSize'
`GenNumLabel'
`GenPrintLabel'
`GenRecordFxnSize'
`GenStartAsciiString'
`GenStartCommentLine'
`GenWordAlignment'
`GenZeroData'


// call stack (from higher to lower addresses):
//   arg n
//   ...
//   arg 1
//   return address
//   saved xbp register
//   local var 1
//   ...
//   local var n



20: arg2 h
19: arg2 l @+6
18: arg1 h
17: arg1 l @+4
16: ret h
15: ret l
14: sbp h  
13: sbp l  @<<<<<< supposed BP reference
12: loc1 h <<<<<<< actual BP reference (after frame construction)
11: loc1 l @-2
10: loc2 h
9: loc2 l

Fix for local offsets: (@+x) = [m+x+1]


*/

unsigned char low(int v) { return v&0xff; }
unsigned char high(int v) { return (v>>8)&0xff; }

unsigned char register_usage[32];

void mark_reg_use(unsigned char reg, unsigned char v) {
  if(reg > 31) {
    error("Bad register for mask\n");
  }
  register_usage[reg] = v;
}

unsigned char get_reg_use(unsigned char reg) {
  if(reg > 31) {
    error("Bad register for mask\n");
  }
  return register_usage[reg];
}


#define USED_REGS_STACK_OPERATION_SIZE 20

void gen_push_used_regs() {
  unsigned char r = 0;
  for(;r<32;r++) {
    if(get_reg_use(r)) {
      printf2("mov a,r%d\n", r);
      printf2("push a\n");
    }
  }
}

void gen_pop_used_regs() {
  unsigned char r = 0;
  for(;r<32;r++) {
    if(get_reg_use(r)) {
      printf2("pop a\n");
      printf2("mov a,r%d\n", r);
    }
  }
}

char * adjust_sp_procedure = 
" ; adjust sp by %d\n"
"ld a, %d\n"
"mov b,a\n"
"mov a,sl\n"
"%s\n"
"mov sl,a\n"
"ld a, %d\n"
"mov b,a\n"
"mov a,sh\n"
"%s\n"
"mov sh,a\n"
;


void adjust_sp(int n) {
  
    if(n == 0) {
      printf2("; adjust by 0, skip\n");
      return;
    }
    char * op = "add";
    char * op2 = "adc";
    if(n < 0) {
        n = -n;
        op = "sub";
        op2 = "sbc";
    }


  printf2(adjust_sp_procedure, n, low(n), op, high(n), op);

}


Node * node_create(unsigned char token, int value, int size) {
  Node * node = (Node *)malloc(sizeof(Node));
  node->token = token;

  node->value = value;

  node->suppress_emit = 0;

  node->target_register = -1;

  node->size = size;

  node->kids = NULL;
  node->next = NULL;
  return node;
}

Node * node_copy(Node * node) {
  Node * new_node = node_create(0,0,0);
  new_node->suppress_emit = node->suppress_emit;
  new_node->target_register = node->target_register;
  new_node->token = node->token;
  new_node->value = node->value;
  new_node->size = node->size;
  return new_node;
}

Node * node_copy_subtree(Node * node) {
  Node * new_node = node_copy(node);
  Node * kid = node->kids;
  while(kid) {
    node_add_kid_to_end(new_node, node_copy(kid));
    kid = kid->next;
  }
  return new_node;
}

void node_free(Node * node) {
  Node * kid = node->kids;
  while(kid) {
    Node * next_kid = kid->next;
    node_free(kid);
    kid = next_kid;
  }
  free(node);
}


Node * node_add_kid(Node * node, Node * kid) {
  kid->next = node->kids;
  node->kids = kid;
/*
  Node ** ptr_to_kid = &node->kids;
  while(*ptr_to_kid) {
    ptr_to_kid = &((*ptr_to_kid)->next);
  }
  *ptr_to_kid = kid;
  */
  return kid;
}

Node * node_add_kid_to_end(Node * node, Node * kid) {
  Node ** ptr_to_kid = &node->kids;
  while(*ptr_to_kid) {
    ptr_to_kid = &((*ptr_to_kid)->next);
  }
  *ptr_to_kid = kid;
  return kid;
}

//forward
char * get_token_name(unsigned char);

void node_print(Node * node, int indent) {
  int i = 0;
  printf2(" ; ");
  for(i = 0; i<indent; i++) {
    printf2(" - ");
  }
  
  printf2("%03d<%s> \"%d\" size() REG: r%d %s %s\n", node->token, get_token_name(node->token), node->size, node->value, node->target_register, node->suppress_emit?"SUPPRESSED":"", node->kids?"":"*");
}

void node_print_subtree(Node * node, int indent) {
  Node * kid;
  if(!node) {
    printf2("{NULL}\n");
    return;
  }
  kid = node->kids;
  node_print(node, indent);
  while(kid) {
    node_print_subtree(kid, indent+1);
    kid = kid->next;
  }
}

typedef struct TokenInfo_ {
  unsigned char id;
  char name[32];
  int n_args;
  int size;
  void (*emitter)(Node *);
} TokenInfo;

TokenInfo tokenInfoTable[0xff];

void add_token_info(unsigned char id, char * name, int n_args, int size, void (*emitter)(Node *)) {
  tokenInfoTable[id].id = id;
  tokenInfoTable[id].n_args = n_args;
  tokenInfoTable[id].size = size;
  tokenInfoTable[id].emitter = emitter;

  strcpy(tokenInfoTable[id].name, name);
}

#define tokSequential 0xfe
#include "cgrlcpu_emitters.c"

void gen_op_info() {
  add_token_info(tokEof        ,  "tokEof"          ,  0, -1, emit_not_impl);
  add_token_info(tokNumInt     ,  "tokNumInt"       ,  0,  2, emit_tokNumInt);
  add_token_info(tokNumUint    ,  "tokNumUint"      ,  0,  2, emit_tokNumInt);
  add_token_info(tokLitStr     ,  "tokLitStr"       , -1, -1, emit_not_impl);
  add_token_info(tokLShift     ,  "tokLShift"       ,  2, -1, emit_tokShift);
  add_token_info(tokRShift     ,  "tokRShift"       ,  2, -1, emit_tokShift);
  add_token_info(tokLogAnd     ,  "tokLogAnd"       ,  2, -1, emit_tokLogAndOr);
  add_token_info(tokLogOr      ,  "tokLogOr"        ,  2, -1, emit_tokLogAndOr);
  add_token_info(tokEQ         ,  "tokEQ"           ,  2, -1, emit_alu_op  );
  add_token_info(tokNEQ        ,  "tokNEQ"          ,  2, -1, emit_alu_op  );
  add_token_info(tokLEQ        ,  "tokLEQ"          ,  2, -1, emit_alu_op  );
  add_token_info(tokGEQ        ,  "tokGEQ"          ,  2, -1, emit_alu_op  );
  add_token_info(tokInc        ,  "tokInc"          ,  1, -1, emit_not_impl);
  add_token_info(tokDec        ,  "tokDec"          ,  1, -1, emit_not_impl);
  add_token_info(tokArrow      ,  "tokArrow"        , -1, -1, emit_not_impl);
  add_token_info(tokEllipsis   ,  "tokEllipsis"     , -1, -1, emit_not_impl);
  add_token_info(tokIdent      ,  "tokIdent"        ,  0, -1, emit_tokIdent);
  add_token_info(tokVoid       ,  "tokVoid"         ,  1, -1, emit_tokVoid );
  add_token_info(tokChar       ,  "tokChar"         , -1, -1, emit_not_impl);
  add_token_info(tokInt        ,  "tokInt"          , -1, -1, emit_not_impl);
  add_token_info(tokReturn     ,  "tokReturn"       ,  1, -1, emit_tokReturn);
  add_token_info(tokGoto       ,  "tokGoto"         ,  1, -1, emit_tokGoto);
  add_token_info(tokIf         ,  "tokIf"           ,  1, -1, emit_tokIf   );
  add_token_info(tokElse       ,  "tokElse"         ,  1, -1, emit_not_impl);
  add_token_info(tokWhile      ,  "tokWhile"        , -1, -1, emit_not_impl);
  add_token_info(tokCont       ,  "tokCont"         , -1, -1, emit_not_impl);
  add_token_info(tokBreak      ,  "tokBreak"        , -1, -1, emit_not_impl);
  add_token_info(tokSizeof     ,  "tokSizeof"       , -1, -1, emit_not_impl);
  add_token_info(tokAssignMul  ,  "tokAssignMul"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignDiv  ,  "tokAssignDiv"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignMod  ,  "tokAssignMod"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignAdd  ,  "tokAssignAdd"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignSub  ,  "tokAssignSub"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignLSh  ,  "tokAssignLSh"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignRSh  ,  "tokAssignRSh"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignAnd  ,  "tokAssignAnd"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignXor  ,  "tokAssignXor"    ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokAssignOr   ,  "tokAssignOr"     ,  2, -1, emit_not_impl); //convert to assign + op
  add_token_info(tokFloat      ,  "tokFloat"        , -1, -1, emit_not_impl);
  add_token_info(tokDouble     ,  "tokDouble"       , -1, -1, emit_not_impl);
  add_token_info(tokLong       ,  "tokLong"         , -1, -1, emit_not_impl);
  add_token_info(tokShort      ,  "tokShort"        , -1, -1, emit_not_impl);
  add_token_info(tokUnsigned   ,  "tokUnsigned"     , -1, -1, emit_not_impl);
  add_token_info(tokSigned     ,  "tokSigned"       , -1, -1, emit_not_impl);
  add_token_info(tokConst      ,  "tokConst"        , -1, -1, emit_not_impl);
  add_token_info(tokVolatile   ,  "tokVolatile"     , -1, -1, emit_not_impl);
  add_token_info(tokRestrict   ,  "tokRestrict"     , -1, -1, emit_not_impl);
  add_token_info(tokStatic     ,  "tokStatic"       , -1, -1, emit_not_impl);
  add_token_info(tokInline     ,  "tokInline"       , -1, -1, emit_not_impl);
  add_token_info(tokExtern     ,  "tokExtern"       , -1, -1, emit_not_impl);
  add_token_info(tokAuto       ,  "tokAuto"         , -1, -1, emit_not_impl);
  add_token_info(tokRegister   ,  "tokRegister"     , -1, -1, emit_not_impl);
  add_token_info(tokTypedef    ,  "tokTypedef"      , -1, -1, emit_not_impl);
  add_token_info(tokEnum       ,  "tokEnum"         , -1, -1, emit_not_impl);
  add_token_info(tokStruct     ,  "tokStruct"       , -1, -1, emit_not_impl);
  add_token_info(tokUnion      ,  "tokUnion"        , -1, -1, emit_not_impl);
  add_token_info(tokDo         ,  "tokDo"           , -1, -1, emit_not_impl);
  add_token_info(tokFor        ,  "tokFor"          , -1, -1, emit_not_impl);
  add_token_info(tokSwitch     ,  "tokSwitch"       , -1, -1, emit_not_impl);
  add_token_info(tokCase       ,  "tokCase"         , -1, -1, emit_not_impl);
  add_token_info(tokDefault    ,  "tokDefault"      , -1, -1, emit_not_impl);
  add_token_info(tok_Bool      ,  "tok_Bool"        ,  1, -1, emit_tokBool );
  add_token_info(tok_Complex   ,  "tok_Complex"     , -1, -1, emit_not_impl);
  add_token_info(tok_Imagin    ,  "tok_Imagin"      , -1, -1, emit_not_impl);
  add_token_info(tok_Asm       ,  "tok_Asm"         , -1, -1, emit_not_impl);
  add_token_info(tokURShift    ,  "tokURShift"      ,  2, -1, emit_tokShift);
  add_token_info(tokUDiv       ,  "tokUDiv"         ,  1, -1, emit_not_impl);
  add_token_info(tokUMod       ,  "tokUMod"         ,  1, -1, emit_not_impl);
  add_token_info(tokAssignURSh ,  "tokAssignURSh"   ,  2, -1, emit_not_impl);
  add_token_info(tokAssignUDiv ,  "tokAssignUDiv"   ,  2, -1, emit_not_impl);
  add_token_info(tokAssignUMod ,  "tokAssignUMod"   ,  2, -1, emit_not_impl);
  add_token_info(tokComma      ,  "tokComma"        ,  2, -1, emit_tokComma);
  add_token_info(tokIfNot      ,  "tokIfNot"        ,  1, -1, emit_tokIf   );
  add_token_info(tokUnaryAnd   ,  "tokUnaryAnd"     ,  1, -1, emit_not_impl);
  add_token_info(tokUnaryStar  ,  "tokUnaryStar"    ,  1, -1, emit_tokUnaryStar);
  add_token_info(tokUnaryPlus  ,  "tokUnaryPlus"    ,  1, -1, emit_not_impl);
  add_token_info(tokUnaryMinus ,  "tokUnaryMinus"   ,  1, -1, emit_tokUnaryAlu);
  add_token_info(tokPostInc    ,  "tokPostInc"      ,  1, -1, emit_not_impl);
  add_token_info(tokPostDec    ,  "tokPostDec"      ,  1, -1, emit_not_impl);
  add_token_info(tokPostAdd    ,  "tokPostAdd"      ,  2, -1, emit_not_impl);
  add_token_info(tokPostSub    ,  "tokPostSub"      ,  2, -1, emit_not_impl);
  add_token_info(tokULess      ,  "tokULess"        , -1, -1, emit_alu_op  );
  add_token_info(tokUGreater   ,  "tokUGreater"     , -1, -1, emit_alu_op  );
  add_token_info(tokULEQ       ,  "tokULEQ"         , -1, -1, emit_alu_op  );
  add_token_info(tokUGEQ       ,  "tokUGEQ"         , -1, -1, emit_alu_op  );
  add_token_info(tokLocalOfs   ,  "tokLocalOfs"     ,  0, -1, emit_tokLocalOfs);
  add_token_info(tokShortCirc  ,  "tokShortCirc"    ,  1, -1, emit_tokShortCirc);
  add_token_info(tokSChar      ,  "tokSChar"        , -1, -1, emit_not_impl);
  add_token_info(tokUChar      ,  "tokUChar"        , -1, -1, emit_not_impl);
  add_token_info(tokUShort     ,  "tokUShort"       , -1, -1, emit_not_impl);
  add_token_info(tokULong      ,  "tokULong"        , -1, -1, emit_not_impl);
  add_token_info(tokGotoLabel  ,  "tokGotoLabel"    , -1, -1, emit_not_impl);
  add_token_info(tokStructPtr  ,  "tokStructPtr"    , -1, -1, emit_not_impl);
  add_token_info(tokTag        ,  "tokTag"          , -1, -1, emit_not_impl);
  add_token_info(tokMemberIdent,  "tokMemberIdent"  , -1, -1, emit_not_impl);
  add_token_info(tokEnumPtr    ,  "tokEnumPtr"      , -1, -1, emit_not_impl);
  add_token_info(tokIntr       ,  "tokIntr"         , -1, -1, emit_not_impl);
  add_token_info(tokNumFloat   ,  "tokNumFloat"     , -1, -1, emit_not_impl);
  add_token_info(tokNumCharWide,  "tokNumCharWide"  , -1, -1, emit_not_impl);
  add_token_info(tokLitStrWide ,  "tokLitStrWide"   , -1, -1, emit_not_impl);
  add_token_info('+',             "tokAdd"          ,  2, -1, emit_alu_op  );
  add_token_info('-',             "tokSub"          ,  2, -1, emit_alu_op  );
  add_token_info('~',             "tokBNot"         ,  1, -1, emit_tokUnaryAlu);
  add_token_info('*',             "tokMul"          ,  2, -1, emit_not_impl);
  add_token_info('/',             "tokDiv"          ,  2, -1, emit_not_impl);
  add_token_info('%',             "tokMod"          ,  2, -1, emit_not_impl);
  add_token_info('&',             "tokAnd"          ,  2, -1, emit_alu_op  );
  add_token_info('|',             "tokOr"           ,  2, -1, emit_alu_op  );
  add_token_info('^',             "tokXor"          ,  2, -1, emit_alu_op  );
  add_token_info('!',             "tokNot"          ,  1, -1, emit_not_impl);
  add_token_info('<',             "tokLess"         ,  2, -1, emit_alu_op);
  add_token_info('>',             "tokMore"         ,  2, -1, emit_alu_op);
  add_token_info('(',             "tokStartArgs"    ,  0, -1, emit_not_impl);
  add_token_info(')',             "tokCall"         ,  1, -1, emit_tokCall ); //fn call
  add_token_info('[',             "'['"             ,  2, -1, emit_not_impl);
  add_token_info(']',             "']'"             ,  2, -1, emit_not_impl);
  add_token_info('{',             "'{'"             ,  2, -1, emit_not_impl);
  add_token_info('}',             "'}'"             ,  2, -1, emit_not_impl);
  add_token_info('=',             "tokAssign"       ,  2, -1, emit_tokAssign);
  add_token_info(',',             "','"             , -1, -1, emit_not_impl);
  add_token_info(';',             "';'"             ,  2, -1, emit_not_impl);
  add_token_info(':',             "':'"             ,  2, -1, emit_not_impl);
  add_token_info('.',             "'.'"             ,  2, -1, emit_not_impl);
  add_token_info('?',             "'?'"             ,  2, -1, emit_not_impl);


  add_token_info(tokSequential,   "tokSequential"   ,  2, -1, emit_tokSequential);

}


int get_n_kids(unsigned char tok) {
  return tokenInfoTable[tok].n_args;
}

char * get_token_name(unsigned char tok) {
  return tokenInfoTable[tok].name;
}

void (* get_emitter(unsigned char tok))(Node *) {
  return tokenInfoTable[tok].emitter;
}


STATIC void GenEmitNode(Node * node) {
  Node * kid = node->kids;
  printf2(" ; r%02d <-[%s]- ", node->target_register, get_token_name(node->token));
  while(kid) {
    printf2("r%02d ", kid->target_register);
    kid = kid->next;
  }
  printf2(" value(%d) size (%d)\n", node->value, node->size);
  if(node->suppress_emit) {
    printf2(" ; !!! emit suppressed\n");
  } else {
    (*get_emitter(node->token))(node);
  }
}

STATIC void GenEmitTree(Node * root) {
  Node * kid = root->kids;
  while(kid) {
    GenEmitTree(kid);
    kid = kid->next;
  }
  GenEmitNode(root);
}

STATIC void GenAssignRegistersToTree(Node * root, int r_idx) {
  Node * kid = root->kids;
  root->target_register = r_idx;

  mark_reg_use(r_idx,1);
  mark_reg_use(r_idx+1,1);

  while(kid) {
    GenAssignRegistersToTree(kid, r_idx);
    kid = kid->next;
    switch(root->token) {
      case tokLogAnd:
      case tokLogOr: //these will bail on first fail, let them all write to self output
      case tokComma: //discard first result
        break;
      default:
        r_idx += 2;
        break;
    }
  }

}

typedef struct OptimizerInfo_ {
  void (*optimizer)(Node **, Node **);
  struct OptimizerInfo_ * next;
} OptimizerInfo;

OptimizerInfo * optimizers;

void add_optimizer(void (*opt)(Node **, Node **)) {
  OptimizerInfo * new_opt = (OptimizerInfo *)malloc(sizeof(OptimizerInfo));
  new_opt->next = optimizers;
  new_opt->optimizer = opt;
  optimizers = new_opt;  
}

void init_optimizers() {
  optimizers = NULL;
  add_optimizer(opt_callWithIdent);
  add_optimizer(opt_assignSizes);
  add_optimizer(opt_suppressDereferences);

  add_optimizer(opt_replaceTokensWithCalls);

  add_optimizer(opt_replacePostOps);
  add_optimizer(opt_replaceAssignArith);
  
}


STATIC void GenOptimizeTree(Node ** node, Node ** head, void (*optimizer)(Node **, Node **)) {
  Node ** kid;
  (*optimizer)(node, head);

  kid = &((*node)->kids);
  while(*kid) {
    GenOptimizeTree(kid, head, optimizer);
    kid = &((*kid)->next);
  }
}

void GenRunOptimizers(Node ** head) {
  OptimizerInfo * opt = optimizers;
  while(opt) {
    GenOptimizeTree(head, head, opt->optimizer);
    opt = opt->next;
  }
}



STATIC Node * GenTree(int sp_idx, int * new_sp_idx) {
  Node * root = NULL;
  int n_kids = 0;
  int tok = stack[sp_idx][0];
  int v = stack[sp_idx][1];

  root = node_create(tok, v, 0);

  n_kids = get_n_kids(tok);
  if(n_kids == -1) {
    printf2(" ; !!!!! n_kids == -1\n");
    error("Internal Error: GenTree(): Token with -1 kids (%s)\n", get_token_name(tok));
    n_kids = 0;
  }

  sp_idx--;
  while(n_kids) {
    node_add_kid(root, GenTree(sp_idx, &sp_idx));
    if(tok == ')') { //function call
      if(stack[sp_idx][0] == ',') { //next arg
        sp_idx--; //skip delimiter token
      } else if(stack[sp_idx][0] == '(') { //last arg passed
        sp_idx--; //skip last delimeter token
        break;
      }
    } else {
      n_kids--;
    }
  }

  if(new_sp_idx) {
    *new_sp_idx = sp_idx;
  }

  return root;
}

STATIC void GenPrintNumLabel(int label)
{
  printf2("L%d", label);
}

STATIC
void GenRecordFxnSize(char* startLabelName, int endLabelNo)
{
  (void)startLabelName;
  (void)endLabelNo;
}

STATIC
int GenFxnSizeNeeded(void)
{
  return 0;
}

STATIC
int GenMaxLocalsSize(void)
{
  return 0xFF;
}

STATIC
void GenStartAsciiString(void)
{
  printf2(".ascii ");
}

STATIC
void GenDumpChar(int ch)
{
  char c_v = '.';

  if(ch > 0) {

    if (ch >= 0x20 && ch <= 0x7E)
      c_v = ch;

    printf2(".byte 0x%02x ; (%c)\n", ch, c_v);
  } else {
    printf2(".byte 0x00 ; (NUL)\n");
  }
/*
  if (ch < 0)
  {
    if (quot)
    {
      printf2("\"");
      quot = 0;
    }
    if (TokenStringLen)
      printf2("\n");
    return;
  }

  if (TokenStringLen == 0)
    GenStartAsciiString();

  // quote ASCII chars for better readability
  if (ch >= 0x20 && ch <= 0x7E && ch != '"')
  {
    if (!quot)
    {
      quot = 1;
      if (TokenStringLen)
        printf2(",");
      printf2("\"");
    }
    printf2("%c", ch);
  }
  else
  {
    if (quot)
    {
      quot = 0;
      printf2("\"");
    }
    //if (TokenStringLen)
    //  printf2(",");
    printf2("\n.byte %u ; !!! CHECK THIS, QUICK HACK AT cgrlcpu.c+548\n.byte 0\n", ch & 0xFFu);
  }
*/
}


STATIC
void GenPrintLabel(char* Label)
{
  if (isdigit(*Label))
    printf2("$L%s", Label);
  else
    printf2("$%s", Label);
}

STATIC
void GenAddrData(int Size, char *Label, int ofs) {
  puts2(" ; GenAddrData");
  ofs = truncInt(ofs);

  // XXX 32 bit
  if (Size == 1) {
    printf2(".byte ");
  } else if (Size == 2) {
    printf2(".word ");
  }

  GenPrintLabel(Label);
  if (ofs) {
    printf2("%+d\n", ofs);
  }
  puts2("");

  // XXX GenAddGlobal - ???

}

STATIC void GenExpr(void) {
  

  int i;
  int gotUnary = 0;
  Node * root = NULL;



#ifndef NO_ANNOTATIONS
  printf2(" ; Expression stack:    \"");
  for (i = 0; i < sp; i++)
  {
    int tok = stack[i][0];
    switch (tok)
    {
    case tokNumInt:

      printf2("%d", truncInt(stack[i][1]));
      break;
    case tokNumUint:

      printf2("%uu", truncUint(stack[i][1]));
      break;
    case tokIdent:

      {
        char* p = IdentTable + stack[i][1];
        if (isdigit(*p))
          printf2("L");
        printf2("%s", p);
      }
      break;

    case tokShortCirc:
      if (stack[i][1] >= 0)
        printf2("[sh&&->%d]", stack[i][1]);
      else
        printf2("[sh||->%d]", -stack[i][1]);
      break;
    case tokGoto:
        printf2("[goto->%d]", stack[i][1]);
      break;
    case tokLocalOfs:
      printf2("(@%d)", truncInt(stack[i][1]));
      break;

    case tokUnaryStar:
      printf2("*(%d)", stack[i][1]);
      break;
    case '(': case ',':
      printf2("%c", tok);
      break;
    case ')':
      printf2(")%d", stack[i][1]);
      break;

    case tokIf:
      printf2("IF[%d]", stack[i][1]);
      break;
    case tokIfNot:
      printf2("IF![%d]", stack[i][1]);
      break;
    default:
      printf2("%s", GetTokenName(tok));
      switch (tok)
      {
      case tokLogOr: case tokLogAnd:
        printf2("[%d]", stack[i][1]);
        break;
      case '=':
      case tokInc: case tokDec:
      case tokPostInc: case tokPostDec:
      case tokAssignAdd: case tokAssignSub:
      case tokPostAdd: case tokPostSub:
      case tokAssignMul: case tokAssignDiv: case tokAssignMod:
      case tokAssignUDiv: case tokAssignUMod:
      case tokAssignLSh: case tokAssignRSh: case tokAssignURSh:
      case tokAssignAnd: case tokAssignXor: case tokAssignOr:
        printf2("(%d)", stack[i][1]);
        break;
      }
      break;
    }
    printf2(" ");
  }
  printf2("\"\n");
#endif

  root = GenTree(sp-1, NULL);

  printf2(" ; Expr tree before optim: \n");
  node_print_subtree(root, 0);



  GenRunOptimizers(&root);

  GenAssignRegistersToTree(root, 0);

  printf2(" ; Expr tree: \n");
  node_print_subtree(root, 0);

  printf2("\n");

  

  GenEmitTree(root);

  printf2("\n\n\n");



}

STATIC void GenFin(void) {
  if (StructCpyLabel)
  {
    char s[1 + 2 + (2 + CHAR_BIT * sizeof StructCpyLabel) / 3];
    char *p = s + sizeof s;

    puts2("StructCpyLabel????");
    STUB;

    *--p = '\0';
    p = lab2str(p, StructCpyLabel);
    *--p = '_';
    *--p = '_';


    puts2(CodeHeaderFooter[0]);

    GenLabel(p, 1);
    GenFxnProlog();

    if (SizeOfWord == 2)
    {
      puts2("WTF???");
    }

    // XXX 32_bit support needed here - see cgx86.c

    GenFxnEpilog();

  }

  // XXX Switch Tab

  // XXX 32 bit
}

fpos_t GenPrologPos;

STATIC void GenFxnProlog(void) {
  memset(register_usage, 0, 32);
  puts2(" ; prolog");
  puts2("push xm");

  puts2("movms");

  fgetpos(OutFile, &GenPrologPos);
  for(int i = 0; i<strlen(adjust_sp_procedure) + 25 + USED_REGS_STACK_OPERATION_SIZE*32; i++) { // 25 should be enough for 2 ops and 3 figures + 32 push operations
    printf2(" ");
  }
  puts2("\n ; prolog end\n");
}

STATIC void GenFxnEpilog(void) {
  puts2(" ; epilog");

  gen_pop_used_regs();
  adjust_sp(-CurFxnMinLocalOfs);
  puts2("movsm");
  puts2("pop mx");

  puts2("jmp");
  puts2(" ; epilog end\n");
  puts2(" ; end of function ");



  fpos_t pos;
  fgetpos(OutFile, &pos);
  fsetpos(OutFile, &GenPrologPos);

  adjust_sp(CurFxnMinLocalOfs);
  gen_push_used_regs();

  fsetpos(OutFile, &pos);


}


STATIC void GenInit(void) {
  SizeOfWord = 2;
}

STATIC
void GenInitFinalize(void)
{
  CodeHeaderFooter[0] = ".section text";
  DataHeaderFooter[0] = ".section data";
  RoDataHeaderFooter[0] = ".section rodata";
  BssHeaderFooter[0] = ".section bss";

  gen_op_info();
  init_optimizers();
}

STATIC
    int GenInitParams(int argc, char **argv, int *idx)
{
  STUB return 0;
}

STATIC
void GenIntData(int Size, int Val){
  Val = truncInt(Val);
  if (Size == 1)
  {
  	printf2(".byte %d\n", Val);
  }
  else if (Size == 2)
  {
    printf2(".word %d\n", Val);
  }
}


STATIC void GenJumpIfEqual(int val, int label) {
  printf2(" ; Jump if equals [0x04x] to ", val); GenPrintNumLabel(label);
  printf2("\n ; 16 bit for now, optimize\n");

  printf2("ld r2, %d\n",(val&0xff));
  printf2("ld r3, %d\n", ((val&0xff00) >> 8));

  printf2("tsub r0,r2,r0\n");
  printf2("tsbc r1,r3,r1\n");
  printf2("tor r0,r0,r1\n");
  printf2("ldd x, $"); GenPrintNumLabel(label); puts2("");
  printf2("jz\n");

}

STATIC void GenJumpIfNotZero(int label) {
  printf2(" ; Jump if not zero to "); GenPrintNumLabel(label);
  printf2("\n ; 16 bit for now, optimize\n");
  
  printf2("tor r0,r0,r1\n");
  printf2("ldd x, $"); GenPrintNumLabel(label); puts2("");
  printf2("jnz\n");

}


STATIC void GenJumpIfZero(int label) {
  printf2(" ; Jump if zero to "); GenPrintNumLabel(label);
  printf2("\n ; 16 bit for now, optimize\n");
  
  printf2("tor r0,r0,r1\n");
  printf2("ldd x, $"); GenPrintNumLabel(label); puts2("");
  printf2("jz\n");
  
}



STATIC void GenJumpUncond(int label)
{
  printf2(" ; Unconditional jump to "); GenPrintNumLabel(label);
  printf2("\nldd x, $"), GenPrintNumLabel(label); puts2("");
  puts2("jmp");
}

STATIC void GenLabel(char *Label, int Static)
{
  printf2("%s:\n", Label);
  if (!Static && GenExterns) {
    printf2(".export %s\n", Label);
  }
}

STATIC
void GenNumLabel(int Label)
{
  printf2("L%d:\n", Label);
}

STATIC
void GenStartCommentLine(void)
{
  printf2(" ; ");
}


STATIC
void GenWordAlignment(int bss)
{
  (void)bss;
  /* pass, no alignment */
}

STATIC
void GenZeroData(unsigned Size, int bss)
{
  (void)bss;
  printf2(".skip %u\n", truncUint(Size));
}
