#include <stdio.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>

/**
 * Lists all files and sub-directories at given path.
 */

unsigned char fs[1024*1024]; //1 Mb

unsigned int c_offset = 512;
unsigned int c_file = 0;

typedef struct f_entry {
    char name[12];
    uint16_t offset;
    uint16_t size;
} f_entry_t;

void append_directory(const char *path)
{
    struct dirent *dp;
    DIR *dir = opendir(path);

    if (!dir) 
        return; 

    while ((dp = readdir(dir)) != NULL)
    {
        if(dp->d_type == DT_REG) {
            struct stat f_stat;
            fstatat(dirfd(dir), dp->d_name, &f_stat, 0);
            printf("%s %zu (0x%04x) at 0x%04x\n", dp->d_name, f_stat.st_size, (uint16_t)f_stat.st_size, (uint16_t)c_offset);
            f_entry_t new_ent;
            new_ent.offset = c_offset >> 8;
            new_ent.size = f_stat.st_size;
            strncpy(new_ent.name, dp->d_name, 11);
            memcpy(fs+c_file*sizeof(f_entry_t), &new_ent, sizeof(f_entry_t));
            
            int file_fd = openat(dirfd(dir), dp->d_name, O_RDONLY);
            read(file_fd, fs + c_offset, f_stat.st_size);
            close(file_fd);

            c_file++;
            c_offset += f_stat.st_size;
            c_offset += (256 - (c_offset % 256)) % 256;
        }
    }

    // Close directory stream
    closedir(dir);
}

int main(int argc, char ** argv) {
    if(argc < 3) {
        printf("Usage: %s directory fs_file\n", argv[0]);
        exit(1);
    }

    memset(fs, 0, 1024*1024);

    append_directory(argv[1]);

    int fd = open(argv[2], O_WRONLY | O_TRUNC | O_CREAT, 0644);
    write(fd, fs, c_offset);
    close(fd);
    return 0;
}

