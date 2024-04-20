#include "tree.h"

#define R(x) (((x)&0xff00)>>8),(char)((x)&0xff)

#define to_R(t,x) (((t)<<8)|((x)&0xff))

#define NO_REG to_R('z',0)

void emit_not_impl(Node * node) {
    printf2(" error !! not_impl \"%s\"\n", get_token_name(node->token));
}

void emit_tokNumInt(Node * node) {
    if(node->size == 0) {
        //error("Zero size for tokNumInt!\n");
        printf2("!!!! Zero size for tokNumInt!\n");
        node->size = 2;
    }

    printf2(" ; possible optimization - pass size\n");
    printf2("ld %c%d, %d\n", R(node->target_register), low(node->value));
    if(abs(node->size) > 1) {
        printf2("ld %c%d, %d\n", R(node->target_register+1), high(node->value));
    }
}

void emit_tokGoto(Node * node) {
    GenJumpUncond(node->value);
}

void emit_tokIf(Node * node) {
    if(node->kids->target_register != to_R('r',0)) {
        error("tokIf not on top!\n");
    }
    
    if(abs(node->kids->size) == 1) {
        printf2(" ; !!!!! XXX QUICK HACK\n");
        printf2("ld A,0\n");
        printf2("mov r1,A\n");
    }

    if(node->token == tokIfNot) {
        GenJumpIfZero(node->value);
    } else {
        GenJumpIfNotZero(node->value);
    }
}

void emit_tokBool(Node * node) {
    int rcl = node->target_register;
    int rch = node->target_register + 1;

    int ral = node->kids->target_register;
    int rah = node->kids->target_register + 1;

    if(node->size == 0) {
        error("Bad size for tokBool!\n");
    }

    printf2("; maybe omit it all? Why convert to bool?\n");
    printf2("; XXX Optimize size!\n");

    if(abs(node->size) == 2) {
        printf2("tor %c%d, %c%d, %c%d\n", R(rcl), R(ral), R(rah));
        //printf2("ttest %c%d, %c%d, %c%d\n", R(rcl), R(rcl), R(rcl));
        printf2("ld %c%d, 0\n", R(rch));
    } else {
        printf2("tor %c%d, %c%d, %c%d\n", R(rcl), R(ral), R(ral));
    }

    printf2(";;;;;;");
}


void emit_tokShift(Node * node) {
    if(node->size == 0) {
        error("Zero size for tokShift!\n");
    }
    if(node->kids->next->token == tokNumInt) { //shift on constant, can do in-place
    
        int k = node->kids->next->value;

        if(k == 8) {
                if(node->token == tokLShift) {
                    /*
                    printf2("mov A, %c%d\n", R(node->kids->target_register));
                    printf2("mov %c%d, A\n", R(node->target_register+1));
                    */
                    printf2("mov %c%d, %c%d\n", R(node->target_register+1), R(node->kids->target_register));

                    printf2("ld A,0\n");
                    printf2("mov %c%d, A\n", R(node->target_register));
                } else {
                    /*
                    printf2("mov A, %c%d\n", R(node->kids->target_register+1));
                    printf2("mov %c%d, A\n", R(node->target_register));
                    */
                    printf2("mov %c%d, %c%d\n", R(node->target_register), R(node->kids->target_register+1));

                    printf2("ld A,0\n");
                    printf2("mov %c%d, A\n", R(node->target_register+1));
                }
        } else {
            for(int i = 0; i<k; i++) {
                int reg = node->kids->target_register;
                if(i) {
                    reg = node->target_register;
                }
                if(node->token == tokLShift) {
                    if(abs(node->size) == 2) {
                        printf2("tshl %c%d, %c%d, %c%d\n", R(node->target_register), R(reg), 'r',0);
                        printf2("tshlc %c%d, %c%d, %c%d\n", R(node->target_register+1), R(reg+1), 'r',0);
                    } else if (abs(node->size) == 1) {
                        printf2("tshl %c%d, %c%d, %c%d\n", R(node->target_register), R(reg), 'r',0);
                    } else {
                        error("");
                    }

                } else if(node->token == tokRShift) {
                    if(abs(node->size) == 2) {
                        printf2("tshr %c%d, %c%d, %c%d\n", R(node->target_register+1), R(reg+1), 'r',0);
                        printf2("tshrc %c%d, %c%d, %c%d\n", R(node->target_register), R(reg), 'r',0);
                    } else if (abs(node->size) == 1) {
                        printf2("tshr %c%d, %c%d, %c%d\n", R(node->target_register), R(reg), 'r',0);
                    } else {
                        error("");
                    }

                } else if(node->token == tokURShift) {
                    if(abs(node->size) == 2) {
                        printf2("tshr %c%d, %c%d, %c%d\n", R(node->target_register+1), R(reg+1), 'r',0);
                        printf2("tshrc %c%d, %c%d, %c%d\n", R(node->target_register), R(reg), 'r',0);
                    } else if (abs(node->size) == 1) {
                        printf2("tshr %c%d, %c%d, %c%d\n", R(node->target_register), R(reg), 'r',0);
                    } else {
                        error("");
                    }

                } else {
                    error("Unknown shift\n");
                }
            }
        }
    } else {
        error("Can not shift over non-constant\n");
    }
}

/*

tokEQ
tokNEQ
tokLEQ
tokGEQ
tokULEQ
tokUGEQ
tokULess
tokUGreater
'>'
'<'

*/
void emit_alu_op(Node * node) {
    char * first_op;
    char * second_op;

    char size = 2;
    char is_cmp = 0;

    if(node->size == 0) {
        error("Zero size for alu_op!\n");
    }

    size = abs(node->size);

    if(node->token == '+') {
        first_op = "add";
        second_op = "adc";
    } else if(node->token == '-') {
        first_op = "sub";
        second_op = "sbc";
    } else if(node->token == '&') {
        first_op = "and";
        second_op = "and";
    } else if(node->token == '|') {
        first_op = "or";
        second_op = "or";
    } else if(node->token == '^') {
        first_op = "xor";
        second_op = "xor";
    } else {
        if(is_comparison(node->token)) {
            is_cmp = 1;
        } else {
            emit_not_impl(node);
        }
   }


    int rcl = node->target_register;
    int rch = node->target_register + 1;

    int ral = node->kids->target_register;
    int rah = node->kids->target_register + 1;
    int rbl = node->kids->next->target_register;
    int rbh = node->kids->next->target_register + 1;

    if(!is_cmp) { //alu operations

        printf2("t%s %c%d, %c%d, %c%d\n", first_op, R(rcl), R(ral), R(rbl));

        if(size == 2) {
            printf2("t%s %c%d, %c%d, %c%d\n", second_op, R(rch), R(rah), R(rbh));
        }
    } else {

        
        //jump over loading one on opposite condition

        int labelAfter = LabelCnt++;
        printf2("ldd X, $"); GenPrintNumLabel(labelAfter); puts2("");

        if(size == 2) {
            printf2("tsub %c%d, %c%d, %c%d\n", R(rcl), R(ral), R(rbl));
            printf2("tsbc %c%d, %c%d, %c%d\n", R(rch), R(rah), R(rbh));
            printf2("ld %c%d, 0\n", R(rch)); //preload high zero for size==2
            printf2("ld %c%d, 0\n", R(rcl)); //preload low zero

        } else {
            printf2("tsub %c%d, %c%d, %c%d\n", R(rcl), R(ral), R(rbl));
            printf2("ld %c%d, 0\n", R(rcl)); //preload low zero
        }
        switch(node->token) {
        case tokEQ:
            printf2("jnz\n"); // ==jne
            break;
        case tokNEQ:
            printf2("jz\n"); // ==je
            break;
        case tokLEQ:
            printf2("jg\n");
            break;
        case tokGEQ:
            printf2("jl\n");
            break;
        case tokULEQ:
            printf2("ja\n");
            break;
        case tokUGEQ:
            printf2("jc\n"); // ==jb
            break;
        case tokULess:
            printf2("jnc\n"); // ==jae
            break;
        case tokUGreater:
            printf2("jbe\n");
            break;
        case '<':
            printf2("jge\n");
            break;
        case '>':
            printf2("jle\n");
            break;
            
            
        default: 
            error("");
            return;
        }

        printf2("ld %c%d, 1\n", R(rcl));

        printf2("; --- end of comparison:\n");
        GenNumLabel(labelAfter);

    }
}


void emit_tokUnaryAlu(Node * node) {
    int rcl = node->target_register;
    int rch = node->target_register + 1;

    int ral = node->kids->target_register;
    int rah = node->kids->target_register + 1;

    if(node->size == 0) {
        error("Zero size for tokUnaryAlu!\n");
    }

    char * op;
    if(node->token == '~') {
        printf2("tnot %c%d, %c%d, %c%d\n", R(rcl), R(ral), R(ral));
        printf2("tnot %c%d, %c%d, %c%d\n", R(rch), R(rah), R(rah));
    } else if(node->token == tokUnaryMinus) {
        if(abs(node->size) == 2) {
            printf2(" ;; optimize this\n");
            printf2("mov A, %c%d\n", R(ral));
            printf2("not\n");
            printf2("inc\n");
            printf2("mov %c%d, A\n", R(rcl));
            printf2("ld A,0\n");
            printf2("mov B,A\n");
            printf2("mov A, %c%d\n", R(rah));
            printf2("adc\n");
            printf2("mov %c%d, A\n", R(rch));

        } else {
            printf2("tneg %c%d, %c%d, %c%d\n", R(rcl), R(ral), R(ral));
        }
    } else {
        error("Unknown unary alu op\n");
    }

}

void emit_tokLogAndOr(Node * node) {
    printf2(" ; tokLogAndOr\n");
    GenNumLabel(node->value);
}


void emit_tokShortCirc(Node * node) {
    printf2(" ; tokShortCirc\n");
    if (node->value >= 0) {
        GenJumpIfZero(node->value); // &&
    } else {
        GenJumpIfNotZero(-node->value); // ||
    }
}


void emit_tokComma(Node * node) {
    /* pass */
    printf2(" ; tokComma\n");
}


void emit_tokVoid(Node * node) {
    /* pass */
    printf2(" ; tokVoid\n");
}

void convert_signed_char_to_signed_int(int r_src, int r_target) {
    printf2("; XXX Convert signed_char_to_signed_int\n");
}

void emit_tokReturn(Node * node) {
    if(node->target_register != to_R('r',0) || node->kids->next != NULL) {
        error("Internal Error: Unexpected tokReturn contents\n");
    }

    if(node->kids->target_register != to_R('r',0)) {
        /*
        printf2("mov A,%c%d\n", R(node->kids->target_register));
        printf2("mov %c%d,A\n", R(node->target_register));
        printf2("mov A,%c%d\n", R(node->kids->target_register+1));
        printf2("mov %c%d,A\n", R(node->target_register+1));
        */
        printf2("mov %c%d, %c%d\n",R(node->target_register),R(node->kids->target_register));
        printf2("mov %c%d, %c%d\n",R(node->target_register+1),R(node->kids->target_register+1));
    }

    if(node->kids->size == 1) {
        printf2("ld A,0\n");
        printf2("mov %c%d, A\n", R(node->target_register + 1));
    } else if(node->kids->size == -1) {
        convert_signed_char_to_signed_int(0,0);
        printf2("; !!!!!!!!!!!! THIS IS WRONG, WILL LOOSE SIGN!\n");
        printf2("ld A,0\n");
        printf2("mov %c%d, A\n", R(node->target_register + 1));
    }

    /* pass */
    printf2(" ; tokReturn\n");
}


void emit_tokSequential(Node * node) {
    if(node->target_register != to_R('r',0)) {
        error("Internal Error: Unexpected tokReturn contents\n");
    }

    if(node->kids->target_register != to_R('r',0)) {
        printf2(" ; XXX Remove this if no return need\n");
        /*
        printf2("mov A,%c%d\n", R(node->kids->target_register));
        printf2("mov %c%d,A\n", R(node->target_register));
        printf2("mov A,%c%d\n", R(node->kids->target_register+1));
        printf2("mov %c%d,A\n", R(node->target_register+1));
        */

        printf2("mov %c%d, %c%d\n",R(node->target_register),R(node->kids->target_register));
        printf2("mov %c%d, %c%d\n",R(node->target_register+1),R(node->kids->target_register+1));

    }

    /* pass */
    printf2(" ; tokSequential\n");
}


void emit_ldd_x_with_ident(int ident) {
    char *p = IdentTable + ident;
    printf2("ldd X, $%s%s\n", isdigit(*p)?"L":"", p);
}

void emit_tokCall(Node * node) {

    /* !!! Convert all args to words!*/

    Node * kid = node->kids;
    int n_args = 0;
    while(kid->next) {
        if(abs(kid->size) == 2) {
            /*
            printf2("mov A, %c%d\n", R(kid->target_register + 1));
            printf2("push A\n");
            printf2("mov A, %c%d\n", R(kid->target_register));
            printf2("push A\n");
            */
           /*
           printf2("push %c%d\n", R(kid->target_register + 1));
           printf2("push %c%d\n", R(kid->target_register));
           */
           
           printf2("pushw %c%d\n", R(kid->target_register));
        } else {
            if(kid->size == 1) {
                printf2("ld A,0\n");
                printf2("push A\n");
    /*
                printf2("mov A, %c%d\n", R(kid->target_register));
                printf2("push A\n");
    */
               printf2("push %c%d\n", R(kid->target_register));

            } else {
                convert_signed_char_to_signed_int(kid->target_register, kid->target_register);
/*
                printf2("mov A, %c%d\n", R(kid->target_register + 1));
                printf2("push A\n");
                printf2("mov A, %c%d\n", R(kid->target_register));
                printf2("push A\n");
                */
            /*
               printf2("push %c%d\n", R(kid->target_register+1));
               printf2("push %c%d\n", R(kid->target_register));
            */
                printf2("pushw %c%d\n", R(kid->target_register));
            }
        }
        kid = kid->next;
        n_args++;
    }
    printf2(" ; pushed %d args\n", n_args);

    if(n_args == 0) {
        printf2(" ; no args, reserve 2 bytes for retval\n");
        printf2("SP-=2\n");
        n_args = 1;
    }
    if(kid->token == tokIdent && kid->suppress_emit) {
        emit_ldd_x_with_ident(kid->value);
        printf2("jmp\n");
    } else {

        printf2(" ; Call not by tokIdent - load address\n");
        /*
        printf2("mov A, %c%d\n", R(kid->target_register));
        printf2("mov XL, A\n", R(kid->target_register));

        printf2("mov A, %c%d\n", R(kid->target_register+1));
        printf2("mov XH, A\n", R(kid->target_register+1));
        */

        printf2("movw X, %c%d\n", R(kid->target_register));

        printf2("jmp\n");
    }

/*
    printf2("pop A\n");
    printf2("mov %c%d,A\n", R(node->target_register));
    printf2("pop A\n");
    printf2("mov %c%d,A\n", R(node->target_register+1));
*/

/*
    printf2("pop %c%d\n", R(node->target_register));
    printf2("pop %c%d\n", R(node->target_register + 1));
    */

    printf2("popw %c%d\n", R(node->target_register));

    //adjust_sp((n_args-1)*2);

    int to_remove = (n_args-1)*2;
    while(to_remove) {
        if(to_remove >= 8) {
            printf2("SP+=8\n");
            to_remove -= 8;
        } else if(to_remove >= 2) {
            printf2("SP+=2\n");
            to_remove -= 2;
        } else {
            printf2("pop A\n");
        }
    }
}




void emit_tokLocalOfs(Node * node) {
    char * op = "add";
    char * op2 = "adc";
    int off;

    if(node->size != 2) {
        error("Bad size for tokLocalOfs!\n");
    }

    if(node->value <= 0) {
        off = (node->value - 15); // -15 because of SP->BP store features
    } else {
        off = (node->value + 1); // +1 because of SP->BP store features
    }

    printf2(" ; localOfs: %d, fix for [m+off] to %d\n", node->value, off);

    if(off < 0) {
        off = -off;
        op = "sub";
        op2 = "sbc";
    }

    printf2("ld A, %d\n", low(off));
    printf2("mov B,A\n");
    printf2("mov A,ML\n");
    printf2("%s\n", op);
    printf2("mov %c%d,A\n", R(node->target_register));

    printf2("ld A, %d\n", high(off));
    printf2("mov B,A\n");
    printf2("mov A,MH\n");
    printf2("%s\n", op2);
    printf2("mov %c%d,A\n", R(node->target_register+1));


}

void emit_inc_x() {
    printf2(" ; emit_inc_x()\n");
    printf2("X++\n");

}
int off_to_reg(int off) {
    int s_reg = 0;
    if(off <= 0) {
        s_reg = to_R('l',off);
    } else {
        s_reg = to_R('a',off-4);
    }
    return s_reg;
}

void emit_tokUnaryStar(Node * node) {
    Node * kid = node->kids;

    if(node->size == 0) {
        error("Bad size for tokUnaryStar!\n");
    }

    int off = 0;
    int use_m_off = 0;
    int s_reg = 0;

    
    if(node->kids->token == tokIdent && node->kids->suppress_emit) {
        //we deref ident
        emit_ldd_x_with_ident(node->kids->value);
        printf2("mov A, [X]\n"); 
    } else if(node->kids->token == tokLocalOfs && node->kids->suppress_emit) {
        off = node->kids->value;

        s_reg = off_to_reg(off);
        use_m_off = 1;
        printf2("mov A, %c%d\n", R(s_reg)); 
    } else {
        //we assign to something else
        printf2(" ; deref from non-ident non-local tok : %s suppress %d\n", get_token_name(node->kids->token), node->kids->suppress_emit);
        /*
        printf2("mov A, %c%d\n", R(kid->target_register));
        printf2("mov XL, A\n");
        printf2("mov A, %c%d\n", R(kid->target_register + 1));
        printf2("mov XH, A\n");
        */
        printf2("movw X, %c%d\n", R(kid->target_register));
        printf2("mov A, [X]\n");
    }

    printf2("mov %c%d, A\n", R(node->target_register));

    if(abs(node->size) == 2) {

        if(use_m_off) {
            printf2("mov A, %c%d\n", R(s_reg+1)); 
        } else {
            emit_inc_x();
            printf2("mov A, [X]\n");
        }

        printf2("mov %c%d, A\n", R(node->target_register+1));
    }
}

void emit_tokIdent(Node * node) {
    char *p = IdentTable + node->value;
    printf2("ld %c%d, $(l)%s%s\n", R(node->target_register), isdigit(*p)?"L":"", p);
    printf2("ld %c%d, $(h)%s%s\n", R(node->target_register+1), isdigit(*p)?"L":"", p);
}

void emit_convType(Node * node) {
    if(node->kids->target_register != node->target_register) {
        /*
        printf2("mov A, %c%d\n", R(node->kids->target_register));
        printf2("mov %c%d, A\n", R(node->target_register));
        */
        printf2("mov %c%d, %c%d\n",R(node->target_register),R(node->kids->target_register));

    }

    if(abs(node->size) == 2) {
        if(node->token == tokInt) {
            if(node->kids->size < 0) {
                printf2(" ; XXX DO PROPER SIGN EXTEND HERE\n");
                printf2("ld A, 0x00\n");
            } else {
                printf2("ld A, 0x00\n");
            }
        }
        printf2("mov %c%d, A\n", R(node->target_register+1));
    } else {
        printf2(" ; skip 2->1 conv\n");
    }
}

void emit_tokAssign(Node * node) {
    if(node->size == 0) {
        error("Bad size for tokAssign!\n");
    }

    if(node->kids == NULL || node->kids->next == NULL) {
        error("Internal Error: Assign too few kids!\n");
    }

    int ral = node->kids->target_register;
    int rah = node->kids->target_register + 1;
    int rvl = node->kids->next->target_register;
    int rvh = node->kids->next->target_register + 1;

    int off = 0;
    int use_m_off = 0;

    if(node->kids->token == tokIdent && node->kids->suppress_emit) {
        //we assign to ident
        emit_ldd_x_with_ident(node->kids->value);
        printf2("mov A, %c%d\n", R(rvl));
        printf2("mov [X], A\n");
    } else if(node->kids->token == tokLocalOfs && node->kids->suppress_emit) {
        off = node->kids->value; // +1 because of SP->BP store features
        use_m_off = 1;
        /*
        printf2("mov A, %c%d\n", R(rvl));
        printf2("mov %c%d, A\n", R(off_to_reg(off))); 
        */
        printf2("mov %c%d, %c%d\n",R(off_to_reg(off)),R(rvl));

    } else if((node->kids->token == tokNumInt || node->kids->token == tokNumUint) && node->kids->suppress_emit) {
        printf2("ldd X, 0x%04X\n", node->kids->value);
        printf2("mov A, %c%d\n", R(rvl));
        printf2("mov [X], A\n");
    } else {
        //we assign to something else
        printf2(" ; assign to non-ident non-local lvalue\n");
        /*
        printf2("mov A, %c%d\n", R(ral));
        printf2("mov XL, A\n");
        printf2("mov A, %c%d\n", R(rah));
        printf2("mov XH, A\n");
        */
        printf2("movw X, %c%d\n", R(ral));
        printf2("mov A, %c%d\n", R(rvl));
        printf2("mov [X], A\n");
    }


    printf2(" ; load to retval\n");
    printf2("mov %c%d, A\n", R(node->target_register));

    if(abs(node->size) == 2) {
        if(use_m_off) {
            off++;
            /*
            printf2("mov A, %c%d\n", R(rvh));
            printf2("mov %c%d, A\n", R(off_to_reg(off))); 
            */
            printf2("mov %c%d, %c%d\n",R(off_to_reg(off)),R(rvh));


        } else {
            emit_inc_x();
            printf2("mov A, %c%d\n", R(rvh));
            printf2("mov [X], A\n");
        }

        printf2(" ; load to retval\n");
        printf2("mov %c%d, A\n", R(node->target_register+1));
    }

}









void opt_callWithIdent(Node ** node, Node ** head) {
    if((*node)->token == ')') {
        Node * kid = (*node)->kids;
        while(kid->next) {
            kid = kid->next;
        }
        if(kid->token == tokIdent) {
            kid->suppress_emit = 1;
        }
    }
}

int default_size(int tok) {
    switch(tok) {
/* constant size operations, can not pass size down*/
        case tokIdent: 
            return 2;
            break;
        case tokChar: 
            return 1;
            break;
        case tokInt: 
            return -2;
            break;
        case tokReturn: 
            return 2;
            break;
        case tokShort: 
            return -2;
            break;
        case tokUnsigned: 
            return 2;
            break;
        case tokSigned: 
            return -2;
            break;
        case tokSChar: 
            return -1;
            break;
        case tokUChar: 
            return 1;
            break;
        case tokUShort: 
            return 2;
            break;
        case tokLocalOfs:
            return 2;
            break;
        case ')':
            return 2;
            break;



/* assign operations, can not pass size down*/
        case '=': 
        case tokInc:
        case tokDec:
        case tokAssignMul:
        case tokAssignDiv:
        case tokAssignMod:
        case tokAssignAdd:
        case tokAssignSub:
        case tokAssignLSh:
        case tokAssignRSh:
        case tokAssignAnd:
        case tokAssignXor:
        case tokAssignOr:
        case tokUnaryStar:
        case tokPostInc:
        case tokPostDec:
        case tokPostAdd:
        case tokPostSub:
            return 0xff;
        default:
            return 0;
    }
}

int can_not_derive_from_down(int tok) {
    switch(tok) {
        case ')':
            return 1;
        default:
            return 0;
    }
}

int can_descend_size(int tok) {
    switch(tok) {
        case tokNumInt:
        case tokNumUint:
        case tokLogAnd:
        case tokLogOr:
        case tokEQ:
        case tokNEQ:
        case tokLEQ:
        case tokGEQ:
        case tokInc:
        case tokDec:
        case tokIf:
        case tok_Bool:
        case tokUDiv:
        case tokUMod:
        case tokAssignURSh:
        case tokAssignUDiv:
        case tokAssignUMod:
        case tokUnaryMinus:
        case tokULess:
        case tokUGreater:
        case tokULEQ:
        case tokUGEQ:
        case tokShortCirc:
        case '+':
        case '-':
        case '~':
        case '*':
        case '/':
        case '%':
        case '&':
        case '|':
        case '^':
        case '<':
        case '>':

            return 1;
        default:
            return 0;
    }
}



void opt_assignSizes(Node ** node, Node ** head) {
    int size = default_size((*node)->token);
    if(size == 0xff) {
        (*node)->size = (*node)->value;
    } else {
        (*node)->size = size;
    }
/*
    if((*node)->token == '=' || can_descend_size((*node)->token)) {        
        if(abs((*node)->value) == 1) {
            if(!(*node)->kids || !(*node)->kids->next) {
                error("Internal Error: Descend size too few kids!\n");
            }
            Node * kid = (*node)->kids->next;
            if(can_descend_size(kid->token)) {
                kid->value = 1;
            }
        }
    }
*/
}

int get_max_size_subtree(Node * node, int c_max) {
    if(node->size != 0) {
        if(abs(node->size) > abs(c_max)) {
            return node->size;
        } else {
            return c_max;
        }
    }
    Node * kid = node->kids;
    int max_among_kids = c_max;
    while(kid) {
        max_among_kids = get_max_size_subtree(kid, max_among_kids);
        kid = kid->next;
    }
    return max_among_kids;
}

void opt_deriveSizes(Node ** node, Node ** head) {
    if((*node)->token == tokNumInt || (*node)->token == tokNumUint) {
        return; //will assign later
    }
    if((*node)->size != 0) {
        return; //already assigned
    }

    (*node)->size = get_max_size_subtree((*node), 0);
}


void opt_deriveNumSizes(Node ** node, Node ** head) {
    Node * kid = (*node)->kids;
    while(kid) {
        if(kid->token == tokNumInt || kid->token == tokNumUint) {
            kid->size = (*node)->size;

            /* override for exceptions */
            if(kid == (*node)->kids) { /* is first kid */
                if(((*node)->token == '=') || ((*node)->token == tokUnaryStar)) {
                    kid->size = 2;
                }
            }
        }
        kid = kid->next;
    }
}

void opt_replaceMulDiv(Node ** node, Node ** head) {
    char new_token = 0;
    if((*node)->token == '*') {
        new_token = tokLShift;
    }

    if((*node)->token == tokUDiv || (*node)->token == '/') {
        new_token = tokRShift;
    }

    // if second kid is constant int
    if(new_token) {
        if((*node)->kids->next->token == tokNumInt || (*node)->kids->next->token == tokNumUint) {
            if((*node)->kids->next->value == 2) {
                (*node)->token = new_token;
                (*node)->kids->next->value = 1;
                (*node)->kids->next->suppress_emit = 1;
            }
            if((*node)->kids->next->value == 4) {
                (*node)->token = new_token;
                (*node)->kids->next->value = 2;
                (*node)->kids->next->suppress_emit = 1;
            }
            if((*node)->kids->next->value == 8) {
                (*node)->token = new_token;
                (*node)->kids->next->value = 3;
                (*node)->kids->next->suppress_emit = 1;
            }
        }
    }

}

void opt_insertConvs(Node ** node, Node ** head) {
    Node ** kid = &((*node)->kids);
    if(abs((*node)->size) == 2) { // conv to 1-byte not needed, will happen automatically
        if((*node)->token == tokInt) return;

        while((*kid)) {
            if((*kid)->size != (*node)->size) {
                if((*kid)->token != tokIdent) {
                    Node * moving_node = (*kid);
                    Node * conv_node = node_create(tokInt, 0, (*node)->size);

                    
                    *kid = conv_node;
                    conv_node->next = moving_node->next;
                    moving_node->next = NULL;
                    conv_node->kids = moving_node;
                }
            }
            kid = &((*kid)->next);
        }
    }
}


int ok_for_reg_addr(Node * node) {
    if(node->token == tokLocalOfs) {
        int off = node->value;
        if(off < -128 || off > 127) { 
            return 0;
        } else {
            return 1;
        }
    }
    return 0;
}

void opt_suppressDereferences(Node ** node, Node ** head) {
    if((*node)->token == '=') {        
        if(!(*node)->kids || !(*node)->kids->next) {
            error("Too few kids for assign!\n");
        }
        if((*node)->kids->token == tokIdent || ok_for_reg_addr((*node)->kids))  { // XXX add tokNumInt for constant addrs
            (*node)->kids->suppress_emit = 1;
        } else if(ok_for_reg_addr((*node)->kids)  && (*node)->kids->next->target_register == NO_REG) {
        /* first kid is local ofs, second kid has no register assigned */
            printf2(" ; replace assign with kid->next with correct regs\n");
            Node * tmp = (*node);
            (*node)->kids->next->target_register = off_to_reg((*node)->kids->value);
            (*node)->kids->next->next = (*node)->next;
            *node = (*node)->kids->next;
            tmp->next = NULL;
            tmp->kids->next = NULL;
            node_free(tmp);
        } else if(((*node)->kids->token == tokNumInt) || ((*node)->kids->token == tokNumUint))  { // XXX add tokNumInt for constant addrs
        /*first kid is a constant address*/
            (*node)->kids->suppress_emit = 1;
        }
    }

    if((*node)->token == tokUnaryStar) {
        if((*node)->kids->token == tokIdent) {
            (*node)->kids->suppress_emit = 1;
        }
    }
}

void opt_assignRegsLocals(Node ** node, Node ** head) {
    if((*node)->token == tokUnaryStar) {
        if(ok_for_reg_addr((*node)->kids)) {
            (*node)->suppress_emit = 1;
            (*node)->kids->suppress_emit = 1;
            (*node)->target_register = off_to_reg((*node)->kids->value);
        }
    }
}



/*
Replace postInc, postDec, Inc, Dec
 (a++)
 conv
 ((a = a+1)-1)
orig:
 ; 020<tokReturn> "0" REG: r0  
 ;  - 082<tokPostDec> "2" REG: r0  
 ;  -  - 089<tokLocalOfs> "-2" REG: r0  *
target:
 ;XXX<tokSequential> "0" REG: r0
 ; 020<tokReturn> "0" REG: r0  
 ;  -  - 089<tokUnaryStar> "-2"
 ;  -  -  - 089<tokLocalOfs> "-2"
 ; 000<=> "2"
 ;  - 089<tokLocalOfs> "-2"
 ;  - 089<-> "-2"
 ;  -  - 089<tokUnaryStar> "-2"
 ;  -  -  - 089<tokLocalOfs> "-2"
 ;  -  - 089<tokNumInt> "1"
 ;


*/

Node * gen_replacePostOps_subtree(Node * op, Node ** head) {
    Node * new_root;
    Node * new_op;
    Node * new_asgn;
    Node * n;

    int on_top = 0;

    if((*head) == op) { //we're on top!
        on_top = 1;
    }

    if(!on_top) {
        if((*head)->token != tokSequential) {
            Node * new_head = node_create(tokSequential, 0, 0);
            node_add_kid(new_head, (*head));
            (*head) = new_head;
        }
    }

    if(op->token == tokPostInc) {
        new_op   = node_create('+', op->value, op->size);
        node_add_kid(new_op, node_create(tokNumInt, 1, op->size));
    } else if(op->token == tokPostDec) {
        new_op   = node_create('-', op->value, op->size);
        node_add_kid(new_op, node_create(tokNumInt, 1, op->size));
    } else if(op->token == tokPostAdd) {
        //post add and post sub have second kid, relink it here
        new_op   = node_create('+', op->value, op->size);
        node_add_kid(new_op, op->kids->next);
    } else if(op->token == tokPostSub) {
        //post add and post sub have second kid, relink it here
        new_op   = node_create('-', op->value, op->size);
        node_add_kid(new_op, op->kids->next);
    }

    // fill tree from new_op
    n = node_add_kid(new_op, node_create(tokUnaryStar, op->value, op->size));
    node_add_kid(n, node_copy_subtree(op->kids));    


    if(!on_top) {
        new_root = node_create(tokUnaryStar, op->value, op->size);
        node_add_kid(new_root, op->kids);
    }

    new_asgn = node_create('=',op->value, op->size);
    node_add_kid(new_asgn, new_op);
    node_add_kid(new_asgn, node_copy_subtree(op->kids));


    if(!on_top) {
        node_add_kid_to_end((*head), new_asgn);
    }

    op->kids = NULL;
    node_free(op);

    if(on_top) {
        return new_asgn;
    } else {
        return new_root;
    }
}

void opt_replacePostOps(Node ** node, Node ** head) {
    if( (*node)->token == tokPostInc || (*node)->token == tokPostDec ||
        (*node)->token == tokPostAdd || (*node)->token == tokPostSub
        ) {
        printf2(" ; Found tokPostInc/Dec/Add/Sub\n");
        node_print_subtree(*node, 0);
        Node * next = (*node)->next;
        (*node) = gen_replacePostOps_subtree(*node, head);
        (*node)->next = next;
        printf2(" ; After replace\n");
        node_print_subtree(*node, 0);
    }
}


int assign_arith_to_tok(int token){
    switch(token) {
    case tokAssignMul:
        return '*';
    case tokAssignDiv:
        return '/';
    case tokAssignMod:
        return '%';
    case tokAssignAdd:
        return '+';
    case tokAssignSub:
        return '-';
    case tokAssignLSh:
        return tokLShift;
    case tokAssignRSh:
        return tokRShift;
    case tokAssignAnd:
        return '&';
    case tokAssignXor:
        return '^';
    case tokAssignOr:
        return '|';
    case tokAssignURSh:
        return tokURShift;
    case tokAssignUDiv:
        return tokUDiv;
    case tokAssignUMod:
        return tokUMod;

    case tokInc:
        return '+';
    case tokDec:
        return '-';
    default:
        return 0;
    }
}

Node * gen_replaceAsignArith_subtree(Node * node, Node ** head) {
    Node * new_root = node_create('=', node->value, node->size);
    new_root->kids = node_copy_subtree(node->kids); // reuse target
    Node * arith_op = node_create(assign_arith_to_tok(node->token), node->value, node->size);
    if(node->token != tokInc && node->token != tokDec) {
        node_add_kid(arith_op, node->kids->next); //second kid goes to arith_op
    } else {
        node_add_kid(arith_op, node_create(tokNumInt, 1, node->size)); //second kid goes to arith_op
    }
    Node * unary_star = node_create(tokUnaryStar, node->value, node->size);
    node_add_kid(unary_star, node->kids); //reuse target
    node_add_kid(arith_op, unary_star); //add source as a first kid for arith

    node_add_kid_to_end(new_root, arith_op);

    node->kids = NULL;
    node_free(node);
    
    return new_root;
}

void opt_replaceAssignArith(Node ** node, Node ** head) {
    int target_token = assign_arith_to_tok((*node)->token);
    if( target_token ) {
        printf2(" ; Found tokPostInc/Dec/Add/Sub\n");
        node_print_subtree(*node, 0);
        Node * next = (*node)->next;
        (*node) = gen_replaceAsignArith_subtree(*node, head);
        (*node)->next = next;
        printf2(" ; After replace\n");
        node_print_subtree(*node, 0);
    }
    
}

void do_replace_with_call(Node * node) {
    char fxnName[32];
    strcpy(fxnName, get_token_name(node->token));
    fxnName[0] = 'f';
    fxnName[1] = 'x';
    fxnName[2] = 'n';

    node->token = ')';
    Node * fxnIdent = node_create(tokIdent, AddIdent(fxnName), 0); // AddIdent will return ident if exists, create if not
    node_add_kid_to_end(node, fxnIdent);
}

void opt_replaceTokensWithCalls(Node ** node,  Node ** head) {
    int rep = 0; //need replace
    switch((*node)->token) {
        case tokLShift:
        case tokRShift:
        case tokURShift:
            if((*node)->kids->next->token != tokNumInt) rep = 1;
            break;
        case tokUDiv:
        case tokUMod:
        case '*':
        case '/':
        case '%':
            rep = 1;
            break;
        default: 
            break;
    }

    if(rep) do_replace_with_call(*node);
}
