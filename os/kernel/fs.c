#include "fs.h"
#include "klib.h"
#include "types.h"
#include "blk.h"

typedef struct f_entry {
    char name[12];
    uint16_t blk;
    uint16_t size;
} f_entry_t;


void list_files(int argc, char ** argv) {
    struct Block *dirent_block = bread(0,0);

    f_entry_t * f_entry = (f_entry_t *)(dirent_block->data);
    while(*(unsigned char *)(f_entry)) {
        puts(f_entry->name); puts(" sz "); printhex(f_entry->size); puts(" @ "); printhex(f_entry->blk); puts("\n");
        f_entry++;
    }

    bfree(dirent_block);

}

void read_file(unsigned char * dest, unsigned int blkn, unsigned int offset, unsigned int size) {
    unsigned int already_read = 0;
    while(already_read < size) {
        unsigned int c_pos = offset + already_read;

        unsigned int c_blk = blkn + (c_pos >> 8);
        struct Block * blk = bread(0,c_blk);
        unsigned int read_now = size - already_read;
        if(read_now + (c_pos&0xff) > 0x100U) {
            read_now = 0x100U - (c_pos&0xff);
        }
    
        //puts("\n\n -- Read from blk "); printhex(c_blk); puts(" start at "); printhex((c_pos&0xff)); puts(" size "); printhex(read_now); puts(" -- \n\n");

        memcpy(dest + already_read, blk->data + (c_pos&0xff), read_now);
        already_read += read_now;
        bfree(blk);
    }
}

int stat(char * name, struct stat * st) {
    int ret = -1;
    struct Block * dirent_block = bread(0,0);

    f_entry_t * f_entry = dirent_block->data;
    while(*(unsigned char *)(f_entry)) {
        if(!strcmp(f_entry->name, name)) {
            ret = 0;
            st->blk = f_entry->blk;
            st->size   = f_entry->size;
            break;
        }
        f_entry++;
    }
    bfree(dirent_block);
    return ret;
}