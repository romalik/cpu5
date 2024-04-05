#ifndef TREE_H__
#define TREE_H__

typedef struct Node_ {
  unsigned char token;
  int value;
  int target_register;

  char suppress_emit;

  struct Node_ * kids;
  struct Node_ * next;
} Node;

Node * node_create(unsigned char token, int value);
void node_free(Node * node);
Node * node_add_kid(Node * node, Node * kid);
Node * node_add_kid_to_end(Node * node, Node * kid);
void node_print(Node * node, int indent);
void node_print_subtree(Node * node, int indent);


char * get_token_name(unsigned char tok);
int get_n_kids(unsigned char tok);

#endif