#include <stdio.h>
#include <stdlib.h>

#include <sys/mman.h>
#include <unistd.h>
#include <string.h>

// MAP_ANONYMOUS

int main() {
    char * buf = malloc(100);
    char *addr = mmap(NULL, sizeof(int), 0x1 | 0x2, 0x1 | 0x20, -1, 0);
    memset(buf, 'A', 100);
    write(1, "hello from write\n", 18);
    free(buf);
    return 0;
}