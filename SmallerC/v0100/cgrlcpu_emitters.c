#include "tree.h"

unsigned char low(int v) { return v&0xff; }
unsigned char high(int v) { return (v>>8)&0xff; }

void emit_not_impl(Node * node) {
    printf2(" !! not_impl \"%s\"\n", get_token_name(node->token));
}

void emit_tokNumInt(Node * node) {

    printf2(" ; possible optimization - pass size\n");
    printf2("ld a, %d\n", low(node->value));
    printf2("mov r%d,a\n", node->target_register);
    printf2("ld a, %d\n", high(node->value));
    printf2("mov r%d,a\n", node->target_register+1);
}


/*

tokEQ
tokNEQ
tokLEQ
tokGEQ
tokULEQ
tokUGEQ

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
        printf2("mov a, r%d\n", rbl);
        printf2("mov b, a\n");
        printf2("mov a, r%d\n", ral);

        printf2("%s\n", first_op);
        printf2("mov r%d, a\n", rcl);

        if(size == 2) {
            printf2("mov a, r%d\n", rbh);
            printf2("mov b, a\n");
            printf2("mov a, r%d\n", rah);

            printf2("%s\n", second_op);
            printf2("mov r%d, a\n", rch);
        }
    } else {
        printf2("ld a, 0\n");
        printf2("mov r%d, a\n", rcl);
        printf2("mov r%d, a\n", rch);
        if(size == 2) {
            printf2("mov a, r%d\n", rbh);
            printf2("mov b, a\n");
            printf2("mov a, r%d\n", rah);

            printf2("sub\n");
            switch(node->token) {
            case tokEQ:
            case tokNEQ:
            case tokLEQ:
            case tokGEQ:
            case tokULEQ:
            case tokUGEQ:
                is_cmp = 1;
                break;
            default: 
                error("");
                return;
            }
        }

        printf2("mov a, r%d\n", rbl);
        printf2("mov b, a\n");
        printf2("mov a, r%d\n", ral);

        printf2("sub\n");

        printf2("--- ;; load x l_out\n")

        switch(node->token) {
        case tokEQ:
            printf2("jnz\n");
            printf2("ld a,1\n");
            printf2("mov r%d, a\n", rcl);        
            break;
        case tokNEQ:
            printf2("jz\n");
            printf2("ld a,1\n");
            printf2("mov r%d, a\n", rcl);        
            break;
        case tokLEQ:
        case tokGEQ:
        case tokULEQ:
            printf2("jnz\n");
            printf2("ld a,1\n");
            printf2("mov r%d, a\n", rcl);        
            break;

        case tokUGEQ:
            is_cmp = 1;
            break;
        default: 
            error("");
            return;
        }

        printf2("--- ;; l_out:\n")

    }
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


void adjust_sp(int n) {
  
    char * op = "add";
    char * op2 = "adc";
    if(n < 0) {
        n = -n;
        op = "sub";
        op2 = "sbc";
    }

    printf2(" ; adjust sp by %d\n", n);

    printf2("ld a, %d\n", low(n));
    printf2("mov b,a\n");
    printf2("mov a,sl\n");
    printf2("%s\n", op);
    printf2("mov sl,a\n");

    printf2("ld a, %d\n", high(n));
    printf2("mov b,a\n");
    printf2("mov a,sh\n");
    printf2("%s\n", op2);
    printf2("mov sh,a\n");

    printf2(" ;;;;;;;;;;;;;;;;;\n");

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
        printf2("mov xl, r%d\n", kid->target_register);
        printf2("mov xh, r%d\n", kid->target_register+1);
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
    } else if(node->kids->token == tokLocalOfs && node->kids->suppress_emit) {
        off = node->kids->value + 1; // +1 because of SP->BP store features
        use_m_off = 1;
        printf2("ld a, %d\n", off); 
        printf2("mov off, a\n");
    } else {
        //we assign to something else
        printf2(" ; deref from non-ident non-local tok : %s suppress %d\n", get_token_name(node->kids->token), node->kids->suppress_emit);
        printf2("mov a, r%d\n", kid->target_register);
        printf2("mov xl, a\n");
        printf2("mov a, r%d\n", kid->target_register + 1);
        printf2("mov xh, a\n");
    }


    printf2("mov a, [%s]\n", use_m_off?"m":"x");

    printf2("mov r%d, a\n", node->target_register);

    if(size == 2) {

        if(use_m_off) {
            off++;
            printf2("ld a, %d\n", off); 
            printf2("mov off, a\n");
        } else {
            emit_inc_x();
        }

        printf2("mov a, [%s]\n", use_m_off?"m":"x");

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
    int ral = node->kids->target_register;
    int rah = node->kids->target_register + 1;
    int rvl = node->kids->next->target_register;
    int rvh = node->kids->next->target_register + 1;

    int off = 0;
    int use_m_off = 0;

    if(node->kids->token == tokIdent && node->kids->suppress_emit) {
        //we assign to ident
        emit_ldd_x_with_ident(node->kids->value);
    } else if(node->kids->token == tokLocalOfs && node->kids->suppress_emit) {
        off = node->kids->value + 1; // +1 because of SP->BP store features
        use_m_off = 1;
        printf2("ld a, %d\n", off); 
        printf2("mov off, a\n");
    } else {
        //we assign to something else
        printf2(" ; assign to non-ident non-local lvalue\n");
        printf2("mov a, r%d\n", ral);
        printf2("mov xl, a\n");
        printf2("mov a, r%d\n", rah);
        printf2("mov xh, a\n");
    }

    printf2("mov a, r%d\n", rvl);
    printf2("mov [%s], a\n", use_m_off?"m":"x");

    printf2(" ; load to retval\n");
    printf2("mov r%d, a\n", node->target_register);

    if(abs(node->value) == 2) {
        if(use_m_off) {
            off++;
            printf2("ld a, %d\n", off); 
            printf2("mov off, a\n");
        } else {
            emit_inc_x();
        }
        printf2("mov a, r%d\n", rvh);
        printf2("mov [%s], a\n", use_m_off?"m":"x");

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
            Node * kid = (*node)->kids->next;
            if(can_descend_size(kid->token)) {
                kid->value = 1;
            }
        }
    }
}



void opt_suppressDereferences(Node ** node, Node ** head) {
    if((*node)->token == '=') {        
        if((*node)->kids->token == tokIdent || (*node)->kids->token == tokLocalOfs) { // XXX add tokNumInt for constant addrs
            (*node)->kids->suppress_emit = 1;
        }
    }

    if((*node)->token == tokUnaryStar) {
        if((*node)->kids->token == tokIdent || (*node)->kids->token == tokLocalOfs) {
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
        (*node) = gen_replacePostOps_subtree(*node, head);
        printf2(" ; After replace\n");
        node_print_subtree(*node, 0);
    }
}

