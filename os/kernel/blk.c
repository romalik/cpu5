#include "blk.h"
#include "ata.h"

struct Block blockCache[BLOCK_CACHE_SIZE];
unsigned char blockDataCache[BLOCK_CACHE_SIZE * 256];

void dump_blocks() {
    int i;
    for (i = 0; i < BLOCK_CACHE_SIZE; i++) {
        puts("blk "); printhex(i); puts(" @ & "); printhex(&blockCache[i]);
        puts(" n "); printhex(blockCache[i].n); puts("\n");
        /*
        printf("Block cache %d flags %d device %d n %d cnt %d\n", i,
               blockCache[i].flags, blockCache[i].device, blockCache[i].n,
               blockCache[i].cnt);
        */
    }
}

void block_sync() {
    int i;
    //puts("\n\n--sync--\n\n");
    //    dump_blocks();
    for (i = 0; i < BLOCK_CACHE_SIZE; i++) {
        struct Block * blk = &blockCache[i];
        if (blk->cnt == 0) {
            if (blk->flags == BLOCK_MODIFIED) {
                ata_write_block(blk->n, blk->data);
            }
            blk->flags = BLOCK_FREE;
        }
    }
}

struct Block *bread(unsigned char device, unsigned int n) {
    unsigned int i;
    //    printf("bread: %d %d\n", device, n);
    while (1) {
        for (i = 0; i < BLOCK_CACHE_SIZE; i++) {
            struct Block * blk = &blockCache[i];
            if (blk->flags != BLOCK_FREE) {
                if (blk->device == device && blk->n == n) {
                    blk->cnt++;
                    //          printf("bread ret %d\n", i);
                    return blk;
                }
            }
        }
        for (i = 0; i < BLOCK_CACHE_SIZE; i++) {
            struct Block * blk = &blockCache[i];
            if (blk->flags == BLOCK_FREE) {
                blk->flags = BLOCK_USED;
                blk->device = device;
                blk->n = n;
                blk->cnt = 1;
                blk->data = &blockDataCache[i << 8];
                ata_read_block(n, blk->data);
                //        printf("bread fetch and ret %d\n", i);
                return blk;
            }
        }
        block_sync();
    }
}
void bfree(struct Block *b) {
    //  printf("bfree\n");
    b->cnt--;
}

void block_init() {
    unsigned int i;
    for (i = 0; i < BLOCK_CACHE_SIZE; i++) {
        blockCache[i].flags = BLOCK_FREE;
    }
}
