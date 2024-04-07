#include "tree.h"

void emit_not_impl(Node * node) {
    printf2(" error !! not_impl \"%s\"\n", get_token_name(node->token));
}

void emit_tokNumInt(Node * node) {

    printf2(" ; possible optimization - pass size\n");
    printf2("ld r%d, %d\n", node->target_register, low(node->value));
    printf2("ld r%d, %d\n", node->target_register+1, high(node->value));
}

void emit_tokGoto(Node * node) {
    GenJumpUncond(node->value);
}

void emit_tokIf(Node * node) {
    if(node->kids->target_register != 0) {
        error("tokIf not on top!\n");
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

    printf2("; maybe omit it all? Why convert to bool?\n");
    printf2("tor r%d, r%d, r%d\n", rcl, ral, rah);
    printf2("ttest r%d, r%d, r%d\n", rcl, rcl, rcl);
    printf2("ld r%d, 0\n", rch);

    printf2(";;;;;;");
}


void emit_tokShift(Node * node) {
    if(node->kids->next->token == tokNumInt) { //shift on constant, can do in-place
        int k = node->kids->next->value;
        for(int i = 0; i<k; i++) {
            if(node->token == tokLShift) {
                if(node->value == 2 || node->value == 0) {
                    printf2("tshl r%d, r%d, r%d\n", node->target_register, node->kids->target_register, 0);
                    printf2("tshlc r%d, r%d, r%d\n", node->target_register+1, node->kids->target_register+1, 0);
                } else if (node->value == 1) {
                    printf2("tshl r%d, r%d, r%d\n", node->target_register, node->kids->target_register, 0);
                } else {
                    error("");
                }

            } else if(node->token == tokRShift) {
                if(node->value == 2 || node->value == 0) {
                    printf2("tshr r%d, r%d, r%d\n", node->target_register+1, node->kids->target_register+1, 0);
                    printf2("tshrc r%d, r%d, r%d\n", node->target_register, node->kids->target_register, 0);
                } else if (node->value == 1) {
                    printf2("tshr r%d, r%d, r%d\n", node->target_register, node->kids->target_register, 0);
                } else {
                    error("");
                }

            } else if(node->token == tokURShift) {
                if(node->value == 2 || node->value == 0) {
                    printf2("tshr r%d, r%d, r%d\n", node->target_register+1, node->kids->target_register+1, 0);
                    printf2("tshrc r%d, r%d, r%d\n", node->target_register, node->kids->target_register, 0);
                } else if (node->value == 1) {
                    printf2("tshr r%d, r%d, r%d\n", node->target_register, node->kids->target_register, 0);
                } else {
                    error("");
                }

            } else {
                error("Unknown shift\n");
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

    if(node->value == 1) { // value can be 0 for some ops - assume size 2
        size = 1;
    }

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

        switch(node->token) {
        case tokEQ:
        case tokNEQ:
        case tokLEQ:
        case tokGEQ:
        case tokULEQ:
        case tokUGEQ:
        case tokULess:
        case tokUGreater:
        case '>':
        case '<':
            is_cmp = 1;
            break;
        default: 
            emit_not_impl(node);
            return;
        }
    }


    int rcl = node->target_register;
    int rch = node->target_register + 1;

    int ral = node->kids->target_register;
    int rah = node->kids->target_register + 1;
    int rbl = node->kids->next->target_register;
    int rbh = node->kids->next->target_register + 1;

    if(!is_cmp) { //alu operations

        printf2("t%s r%d, r%d, r%d\n", first_op, rcl, ral, rbl);

        if(size == 2) {
            printf2("t%s r%d, r%d, r%d\n", second_op, rch, rah, rbh);
        }
    } else {

        //preload result with zero
        //jump over loading one on opposite condition

        printf2("ld r%d, 0\n", rcl);
        printf2("ld r%d, 0\n", rch);
        if(size == 2) {
            int labelAfter = LabelCnt++;
            printf2("ldd x, $"); GenPrintNumLabel(labelAfter); puts2("");

            printf2("tsub r%d, r%d, r%d\n", rah, rah, rbh);
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

            // Higher byte matches comparison, compare lower byte
            // Always use unsigned comparison here

            printf2("tsub r%d, r%d, r%d\n", ral, ral, rbl);

            switch(node->token) {
            case tokEQ:
                printf2("jnz\n"); // ==jne
                break;
            case tokNEQ:
                printf2("jz\n"); // ==je
                break;
            case tokULEQ:
            case tokLEQ:
                printf2("ja\n"); // ABOVE, because comparing 2's complements
                break;
            case tokUGEQ:
            case tokGEQ:
                printf2("jc\n"); // ==jb, BELOW
                break;
            case '<':
            case tokULess:
                printf2("jnc\n"); // ==jae
                break;
            case '>':
            case tokUGreater:
                printf2("jbe\n");
                break;
                
                 
            default: 
                error("");
                return;
            }

            printf2("ld r%d, 1\n", rcl);

            printf2("; --- end of comparison:\n");
            GenNumLabel(labelAfter);

        } else {
        }


    }
}


void emit_tokUnaryAlu(Node * node) {
    int rcl = node->target_register;
    int rch = node->target_register + 1;

    int ral = node->kids->target_register;
    int rah = node->kids->target_register + 1;

    char * op;
    if(node->token == '~') {
        printf2("tnot r%d, r%d, r%d\n", rcl, ral, ral);
        printf2("tnot r%d, r%d, r%d\n", rch, rah, rah);
    } else if(node->token == tokUnaryMinus) {
        if(node->value == 0 || node->value == 2) {
            printf2(" ;; optimize this\n");
            printf2("mov a, r%d\n", ral);
            printf2("not\n");
            printf2("inc\n");
            printf2("mov r%d, a\n", rcl);
            printf2("ld a,0\n");
            printf2("mov b,a\n");
            printf2("mov a, r%d\n", rah);
            printf2("adc\n");
            printf2("mov r%d, a\n", rch);

        } else {
            printf2("tneg r%d, r%d, r%d\n", rcl, ral, ral);
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


void emit_tokReturn(Node * node) {
    if(node->target_register != 0 || node->kids->target_register != 0 || node->kids->next != NULL) {
        error("Internal Error: Unexpected tokReturn contents\n");
    }
    /* pass */
    printf2(" ; tokReturn\n");
}


void emit_tokSequential(Node * node) {
    if(node->target_register != 0 || node->kids->target_register != 0) {
        error("Internal Error: Unexpected tokReturn contents\n");
    }
    /* pass */
    printf2(" ; tokSequential\n");
}


void emit_ldd_x_with_ident(int ident) {
    char *p = IdentTable + ident;
    printf2("ldd x, $%s%s\n", isdigit(*p)?"L":"", p);
}

void emit_tokCall(Node * node) {
    Node * kid = node->kids;
    int n_args = 0;
    while(kid->next) {
        printf2("mov a, r%d\n", kid->target_register + 1);
        printf2("push a\n");
        printf2("mov a, r%d\n", kid->target_register);
        printf2("push a\n");
        kid = kid->next;
        n_args++;
    }
    printf2(" ; pushed %d args\n", n_args);

    if(kid->token == tokIdent && kid->suppress_emit) {
        emit_ldd_x_with_ident(kid->value);
        printf2("jmp\n");
    } else {

        printf2(" ; Call not by tokIdent - load address\n");
        printf2("mov a, r%d\n", kid->target_register);
        printf2("mov xl, a\n", kid->target_register);

        printf2("mov a, r%d\n", kid->target_register+1);
        printf2("mov xh, a\n", kid->target_register+1);
        printf2("jmp\n");
    }

    adjust_sp(n_args*2);
}




void emit_tokLocalOfs(Node * node) {
    char * op = "add";
    char * op2 = "adc";
    int off;

    off = (node->value + 1); // +1 because of SP->BP store features

    printf2(" ; localOfs: %d, fix for [m+off] to %d\n", node->value, off);

    if(off < 0) {
        off = -off;
        op = "sub";
        op2 = "sbc";
    }

    printf2("ld a, %d\n", low(off));
    printf2("mov b,a\n");
    printf2("mov a,ml\n");
    printf2("%s\n", op);
    printf2("mov r%d,a\n", node->target_register);

    printf2("ld a, %d\n", high(off));
    printf2("mov b,a\n");
    printf2("mov a,mh\n");
    printf2("%s\n", op2);
    printf2("mov r%d,a\n", node->target_register+1);


}

void emit_inc_x() {
    printf2(" ; emit_inc_x()\n");
    printf2("x++\n");

}

void emit_tokUnaryStar(Node * node) {
    Node * kid = node->kids;

    int size = abs(node->value);

    int off = 0;
    int use_m_off = 0;

    
    if(node->kids->token == tokIdent && node->kids->suppress_emit) {
        //we deref ident
        emit_ldd_x_with_ident(node->kids->value);
        printf2("mov a, [x]\n"); 
    } else if(node->kids->token == tokLocalOfs && node->kids->suppress_emit) {
        off = node->kids->value + 1; // +1 because of SP->BP store features
        use_m_off = 1;
        printf2("mov a, [m%+d]\n", off); 
    } else {
        //we assign to something else
        printf2(" ; deref from non-ident non-local tok : %s suppress %d\n", get_token_name(node->kids->token), node->kids->suppress_emit);
        printf2("mov a, r%d\n", kid->target_register);
        printf2("mov xl, a\n");
        printf2("mov a, r%d\n", kid->target_register + 1);
        printf2("mov xh, a\n");
        printf2("mov a, [x]\n");
    }

    printf2("mov r%d, a\n", node->target_register);

    if(size == 2) {

        if(use_m_off) {
            off++;
            printf2("mov a, [m%+d]\n", off); 
        } else {
            emit_inc_x();
            printf2("mov a, [x]\n");
        }

        printf2("mov r%d, a\n", node->target_register+1);
    }

}

void emit_tokIdent(Node * node) {
    emit_ldd_x_with_ident(node->value);

    printf2("mov a, xl\n");
    printf2("mov r%d, a\n", node->target_register);
    printf2("mov a, xh\n");
    printf2("mov r%d, a\n", node->target_register+1);
}

void emit_tokAssign(Node * node) {
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
        printf2("mov a, r%d\n", rvl);
        printf2("mov [x], a\n");
    } else if(node->kids->token == tokLocalOfs && node->kids->suppress_emit) {
        off = node->kids->value + 1; // +1 because of SP->BP store features
        use_m_off = 1;
        printf2("mov a, r%d\n", rvl);
        printf2("mov [m%+d], a\n", off); 
    } else {
        //we assign to something else
        printf2(" ; assign to non-ident non-local lvalue\n");
        printf2("mov a, r%d\n", ral);
        printf2("mov xl, a\n");
        printf2("mov a, r%d\n", rah);
        printf2("mov xh, a\n");
        printf2("mov a, r%d\n", rvl);
        printf2("mov [x], a\n");
    }


    printf2(" ; load to retval\n");
    printf2("mov r%d, a\n", node->target_register);

    if(abs(node->value) == 2) {
        if(use_m_off) {
            off++;
            printf2("mov a, r%d\n", rvl);
            printf2("mov [m%+d], a\n", off); 
        } else {
            emit_inc_x();
            printf2("mov a, r%d\n", rvh);
            printf2("mov [x], a\n");
        }

        printf2(" ; load to retval\n");
        printf2("mov r%d, a\n", node->target_register+1);
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

int can_descend_size(int tok) {
    switch(tok) {
        case '+':
        case '-':
        case '|':
        case '&':
        case '^':
            return 1;
        default:
            return 0;
    }
}

void opt_assignSizes(Node ** node, Node ** head) {
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
}


int ok_for_imm(Node * node) {
    if(node->token == tokLocalOfs) {
        int off = node->value + 1; // SP->BP features
        if(off < -16 || off > 14) { //14 because of 2-byte args
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
        if((*node)->kids->token == tokIdent || ok_for_imm((*node)->kids))  { // XXX add tokNumInt for constant addrs
            (*node)->kids->suppress_emit = 1;
        }

    }

    if((*node)->token == tokUnaryStar) {
        if((*node)->kids->token == tokIdent || ok_for_imm((*node)->kids)) {
            (*node)->kids->suppress_emit = 1;
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
            Node * new_head = node_create(tokSequential, 0);
            node_add_kid(new_head, (*head));
            (*head) = new_head;
        }
    }

    if(op->token == tokPostInc) {
        new_op   = node_create('+', op->value);
        node_add_kid(new_op, node_create(tokNumInt, 1));
    } else if(op->token == tokPostDec) {
        new_op   = node_create('-', op->value);
        node_add_kid(new_op, node_create(tokNumInt, 1));
    } else if(op->token == tokPostAdd) {
        //post add and post sub have second kid, relink it here
        new_op   = node_create('+', op->value);
        node_add_kid(new_op, op->kids->next);
    } else if(op->token == tokPostSub) {
        //post add and post sub have second kid, relink it here
        new_op   = node_create('-', op->value);
        node_add_kid(new_op, op->kids->next);
    }

    // fill tree from new_op
    n = node_add_kid(new_op, node_create(tokUnaryStar, op->value));
    node_add_kid(n, node_create(op->kids->token, op->kids->value));    


    if(!on_top) {
        new_root = node_create(tokUnaryStar, op->value);
        node_add_kid(new_root, op->kids);
    }

    new_asgn = node_create('=',op->value);
    node_add_kid(new_asgn, new_op);
    node_add_kid(new_asgn, node_create(op->kids->token, op->kids->value));


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
    Node * new_root = node_create('=', node->value);
    new_root->kids = node_copy_subtree(node->kids); // reuse target
    Node * arith_op = node_create(assign_arith_to_tok(node->token), node->value);
    if(node->token != tokInc && node->token != tokDec) {
        node_add_kid(arith_op, node->kids->next); //second kid goes to arith_op
    } else {
        node_add_kid(arith_op, node_create(tokNumInt, 1)); //second kid goes to arith_op
    }
    Node * unary_star = node_create(tokUnaryStar, node->value);
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
    
    Node * fxnIdent = node_create(tokIdent, AddIdent(fxnName)); // AddIdent will return ident if exists, create if not
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
