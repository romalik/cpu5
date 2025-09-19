#include "chibicc.h"

static FILE *ast_out = NULL;

static void dump_node(struct Node *nd, int indent);
static void dump_type(Type *ty, int indent);
static void dump_obj(Obj *obj, int indent);
static void dump_member(Member *mem, int indent);
static void indentf(int n, const char *fmt, ...) __attribute__((format(printf,2,3)));

static const char *node_kind_str(int k) {
  switch (k) {
  case ND_ADD: return "ADD";
  case ND_SUB: return "SUB";
  case ND_MUL: return "MUL";
  case ND_DIV: return "DIV";
  case ND_NEG: return "NEG";
  case ND_ASSIGN: return "ASSIGN";
  case ND_VAR: return "VAR";
  case ND_NUM: return "NUM";
  case ND_CAST: return "CAST";
  case ND_ADDR: return "ADDR(&)";
  case ND_DEREF: return "DEREF(*)";
  case ND_EQ: return "EQ(==)";
  case ND_NE: return "NE(!=)";
  case ND_LT: return "LT(<)";
  case ND_LE: return "LE(<=)";
  case ND_BITAND: return "BITAND(&)";
  case ND_BITOR: return "BITOR(|)";
  case ND_BITXOR: return "BITXOR(^)";
  case ND_SHL: return "SHL(<<)";
  case ND_SHR: return "SHR(>>)";
  case ND_LOGAND: return "LOGAND(&&)";
  case ND_LOGOR: return "LOGOR(||)";
  case ND_COND: return "COND(?:)";
  case ND_COMMA: return "COMMA(,)";
  case ND_NOT: return "NOT(!)";
  case ND_BITNOT: return "BITNOT(~)";
  case ND_MEMBER: return "MEMBER";
  case ND_FUNCALL: return "FUNCALL";
  case ND_NULL_EXPR: return "NULL_EXPR";
  case ND_STMT_EXPR: return "STMT_EXPR";
  case ND_EXPR_STMT: return "EXPR_STMT";
  case ND_BLOCK: return "BLOCK";
  case ND_IF: return "IF";
  case ND_FOR: return "FOR";
  case ND_SWITCH: return "SWITCH";
  case ND_CASE: return "CASE";
  case ND_GOTO: return "GOTO";
  case ND_LABEL: return "LABEL";
  case ND_RETURN: return "RETURN";
  default: return "UNKNOWN";
  }
}

static const char *type_kind_str(int k) {
  switch (k) {
  case TY_VOID: return "void";
  case TY_BOOL: return "_Bool";
  case TY_CHAR: return "char";
  case TY_SHORT: return "short";
  case TY_INT: return "int";
  case TY_LONG: return "long";
  case TY_FLOAT: return "float";
  case TY_DOUBLE: return "double";
  case TY_LDOUBLE: return "long double";
  case TY_ENUM: return "enum";
  case TY_PTR: return "ptr";
  case TY_FUNC: return "func";
  case TY_ARRAY: return "array";
  case TY_VLA: return "vla";
  case TY_STRUCT: return "struct";
  case TY_UNION: return "union";
  default: return "ty?";
  }
}

static void indentf(int n, const char *fmt, ...) {
  for (int i=0;i<n;i++) fputs("  ", ast_out);
  va_list ap; va_start(ap, fmt);
  vfprintf(ast_out, fmt, ap);
  va_end(ap);
}

static void dump_type(Type *ty, int indent) {
  if (!ty) { indentf(indent, "Type: (null)\n"); return; }
  indentf(indent, "Type: %s", type_kind_str(ty->kind));
  if (ty->is_unsigned) fprintf(ast_out, " unsigned");
  if (ty->is_atomic)   fprintf(ast_out, " atomic");
  if (ty->align)       fprintf(ast_out, " align=%d", ty->align);
  if (ty->size)        fprintf(ast_out, " size=%d", ty->size);
  fputc('\n', ast_out);

  switch (ty->kind) {
  case TY_PTR:
    indentf(indent+1, "-> Pointee:\n");
    dump_type(ty->base, indent+2);
    break;
  case TY_ARRAY:
    indentf(indent+1, "-> Array len=%ld\n", (long)ty->array_len);
    indentf(indent+1, "-> Base:\n");
    dump_type(ty->base, indent+2);
    break;
  case TY_FUNC:
    indentf(indent+1, "-> Return:\n");
    dump_type(ty->return_ty, indent+2);
    if (ty->params) {
      indentf(indent+1, "-> Params:\n");
      for (Type *p = ty->params; p; p = p->next)
        dump_type(p, indent+2);
    }
    break;
  case TY_STRUCT:
  case TY_UNION:
    if (ty->members) {
      indentf(indent+1, "-> Members:\n");
      for (Member *m = ty->members; m; m = m->next)
        dump_member(m, indent+2);
    }
    break;
  default:
    break;
  }
}

static void dump_member(Member *m, int indent) {
  if (!m) return;
  indentf(indent, "Member: name_ptr=%p offset=%d bitwidth=%d bit_offset=%d\n",
          (void*)m->name, m->offset, m->bit_width, m->bit_offset);
  dump_type(m->ty, indent+1);
}

static void dump_obj(Obj *obj, int indent) {
  if (!obj) { indentf(indent, "Obj: (null)\n"); return; }
  indentf(indent, "Obj: %s %s%s\n",
          obj->is_function ? "function" : "object",
          obj->name ? obj->name : "(anon)",
          obj->is_static ? " static" : "");
  if (obj->ty) dump_type(obj->ty, indent+1);

  if (obj->is_function) {
    if (obj->is_definition) {
      indentf(indent+1, "params:\n");
      for (Obj *p = obj->params; p; p = p->next)
        dump_obj(p, indent+2);

      indentf(indent+1, "locals:\n");
      for (Obj *l = obj->locals; l; l = l->next)
        dump_obj(l, indent+2);

      indentf(indent+1, "stack_size=%d\n", obj->stack_size);
      indentf(indent+1, "body:\n");
      dump_node(obj->body, indent+2);
    } else {
      indentf(indent+1, "(decl only)\n");
    }
  } else {
    if (obj->init_data) {
      indentf(indent+1, "has init_data {");
      for(size_t i = 0; i<obj->ty->size; i++) {
        printf("%c", obj->init_data[i]);
      }
      printf("}\n");
    }
  }
}

static void dump_node(Node *nd, int indent) {
  if (!nd) { indentf(indent, "(null)\n"); return; }

  indentf(indent, "Node: %s", node_kind_str(nd->kind));
  if (nd->tok && nd->tok->filename)
    fprintf(ast_out, " @%s:%d", nd->tok->filename, nd->tok->line_no);
  fputc('\n', ast_out);

  if (nd->ty) dump_type(nd->ty, indent+1);

  if (nd->kind == ND_NUM) {
    indentf(indent+1, "value: %ld (f=%Lg)\n", (long)nd->val, nd->fval);
  }
  if (nd->kind == ND_VAR && nd->var) {
    indentf(indent+1, "var:\n");
    dump_obj(nd->var, indent+2);
  }

  if (nd->kind == ND_MEMBER && nd->member) {
    indentf(indent+1, "member:\n");
    dump_member(nd->member, indent+2);
  }

  if (nd->lhs) { indentf(indent+1, "lhs:\n"); dump_node(nd->lhs, indent+2); }
  if (nd->rhs) { indentf(indent+1, "rhs:\n"); dump_node(nd->rhs, indent+2); }

  if (nd->kind == ND_FUNCALL) {
    if (nd->lhs) { indentf(indent+1, "callee (lhs): name(%s)\n", nd->lhs->var->name); }
    if (nd->args) {
      indentf(indent+1, "args:\n");
      for (Node *a = nd->args; a; a = a->next)
        dump_node(a, indent+2);
    }
  }

  if (nd->kind == ND_COND) {
    if (nd->cond) { indentf(indent+1, "cond:\n"); dump_node(nd->cond, indent+2); }
    if (nd->then) { indentf(indent+1, "then:\n"); dump_node(nd->then, indent+2); }
    if (nd->els)  { indentf(indent+1, "else:\n"); dump_node(nd->els,  indent+2); }
  }

  if (nd->kind == ND_IF) {
    if (nd->cond) { indentf(indent+1, "cond:\n"); dump_node(nd->cond, indent+2); }
    if (nd->then) { indentf(indent+1, "then:\n"); dump_node(nd->then, indent+2); }
    if (nd->els)  { indentf(indent+1, "else:\n"); dump_node(nd->els,  indent+2); }
  }
  if (nd->kind == ND_FOR) {
    if (nd->init) { indentf(indent+1, "init:\n"); dump_node(nd->init, indent+2); }
    if (nd->cond) { indentf(indent+1, "cond:\n"); dump_node(nd->cond, indent+2); }
    if (nd->inc)  { indentf(indent+1, "inc:\n");  dump_node(nd->inc,  indent+2); }
    if (nd->body) { indentf(indent+1, "body:\n"); dump_node(nd->body, indent+2); }
  }
  if (nd->kind == ND_SWITCH) {
    if (nd->cond) { indentf(indent+1, "cond:\n"); dump_node(nd->cond, indent+2); }
    if (nd->then) { indentf(indent+1, "body:\n"); dump_node(nd->then, indent+2); }
    if (nd->case_next) {
      indentf(indent+1, "cases:\n");
      for (Node *c = nd->case_next; c; c = c->case_next) {
        indentf(indent+2, "case:\n");
        if (c->lhs) { indentf(indent+3, "value:\n"); dump_node(c->lhs, indent+4); }
        if (c->body) { indentf(indent+3, "case-body:\n"); dump_node(c->body, indent+4); }
      }
    }
    if (nd->default_case) {
      indentf(indent+1, "default:\n");
      if (nd->default_case->body)
        dump_node(nd->default_case->body, indent+2);
    }
  }

  if (nd->kind == ND_BLOCK || nd->kind == ND_STMT_EXPR) {
    if (nd->body) {
      indentf(indent+1, "block:\n");
      dump_node(nd->body, indent+2);
    }
  }

  if (nd->next) {
    indentf(indent, "next:\n");
    dump_node(nd->next, indent+1);
  }
}

void ast_dump_program(Obj *prog, FILE *out) {
  ast_out = out ? out : stderr;
  fprintf(ast_out, "=== AST DUMP BEGIN ===\n");
  for (Obj *obj = prog; obj; obj = obj->next) {
    dump_obj(obj, 0);
  }
  fprintf(ast_out, "=== AST DUMP END ===\n");
  fflush(ast_out);
}