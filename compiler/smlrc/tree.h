#ifndef TREE_H__
#define TREE_H__

#define R(x) (((x)&0xff00)>>8),(char)((x)&0xff)

#define to_R(t,x) (((t)<<8)|((x)&0xff))


typedef struct Node_ {
  unsigned char token;
  int value;
  int size;
  int target_register;

  char suppress_emit;

  struct Node_ * kids;
  struct Node_ * next;
} Node;

Node * node_create(unsigned char token, int value, int size);
void node_free(Node * node);
Node * node_add_kid(Node * node, Node * kid);
Node * node_add_kid_to_end(Node * node, Node * kid);
void node_print(Node * node, int indent);
void node_print_subtree(Node * node, int indent);


Node * node_copy_subtree(Node * node);

char * get_token_name(unsigned char tok);
int get_n_kids(unsigned char tok);

#endif