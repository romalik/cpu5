#ifndef ATA_H__
#define ATA_H__


void ataInit(void);


unsigned char ata_read_block(unsigned int block, unsigned char *buf);
unsigned char ata_write_block(unsigned int block, unsigned char *buf);

#endif
