#include <stdio.h>
#include <stdlib.h>


int main() {
    printf("Hello, World!\n");
    write(1, "hello from write\n", 18);
    return 0;
}