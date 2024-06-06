#ifndef BLK_H__
#define BLK_H__

#include "types.h"

#define BLOCK_FREE 0x00
#define BLOCK_USED 0x01
#define BLOCK_MODIFIED 0x02
#define BLOCK_LOCKED 0x04

#define BLOCK_CACHE_SIZE 4

struct Block {
    unsigned char flags;
    unsigned char device;
    unsigned int n;
    unsigned char cnt;
    unsigned char *data;
};

extern struct Block blockCache[];

struct Block *bread(unsigned char device, unsigned int n);
void bfree(struct Block *b);
void block_init();
void block_sync();

#endif
