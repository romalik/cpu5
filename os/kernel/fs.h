#ifndef FS_H__
#define FS_H__



void list_files(int argc, char ** argv);
void read_file(unsigned char * dest, unsigned int blk, unsigned int offset, unsigned int size);

struct stat {
    unsigned int blk;
    unsigned int size;
};

int stat(char * name, struct stat * st);

#endif