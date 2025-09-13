#include "ata.h"

#define STORAGE_ADDR_LOW    0x4000
#define STORAGE_ADDR_MID    0x4001
#define STORAGE_ADDR_HIGH   0x4002
#define STORAGE_DATA        0x4003

void ataInit() {
    
}

unsigned char ata_read_block(unsigned int block, unsigned char *buf) {
    *(unsigned char *)(STORAGE_ADDR_HIGH) = block >> 8;
    *(unsigned char *)(STORAGE_ADDR_MID)  = block & 0xff;
    for(int i = 0; i<256; i++) {
        //*(unsigned char *)(STORAGE_ADDR_LOW) = i;
        *(buf++) = *(unsigned char *)(STORAGE_DATA);
    }
}

unsigned char ata_write_block(unsigned int block, unsigned char *buf) {
    *(unsigned char *)(STORAGE_ADDR_HIGH) = block >> 8;
    *(unsigned char *)(STORAGE_ADDR_MID)  = block & 0xff;
    for(int i = 0; i<256; i++) {
        //*(unsigned char *)(STORAGE_ADDR_LOW) = i;
        *(unsigned char *)(STORAGE_DATA) = buf[i];
    }
}
