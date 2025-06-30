#include <stdio.h>
#include <stdlib.h>


int main() {
    char buf[] = "Hello from write!\n";
    write(1, buf, sizeof(buf) - 1);
    return 0;
}