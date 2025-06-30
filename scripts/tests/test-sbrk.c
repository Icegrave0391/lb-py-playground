#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main() {
    // Get current program break
    void *current_brk = sbrk(0);
    // printf("Current program break: %p\n", current_brk);
    
    // Allocate 1024 bytes using sbrk
    void *new_memory = sbrk(1024);
    if (new_memory == (void *)-1) {
        perror("sbrk failed");
        return 1;
    }
    
    if (new_memory != current_brk) {
        write(1, "sbrk did not return the current program break\n", 44);
        return 1;
    }

    // printf("Allocated memory at: %p\n", new_memory);
    
    // Use the allocated memory to store data
    char *data_ptr = (char *)new_memory;
    strcpy(data_ptr, "Hello, this is data stored in sbrk allocated memory!");
    if (data_ptr[0] != 'H') {
        write(1, "Data integrity check failed\n", 28);
        return 1;
    }

    // Store some integers
    int *int_ptr = (int *)(data_ptr + 100);
    for (int i = 0; i < 10; i++) {
        int_ptr[i] = i * i;
    }
    
    // Get new program break
    void *final_brk = sbrk(0);
    // printf("Final program break: %p\n", final_brk);
    // printf("Memory allocated: %ld bytes\n", (char *)final_brk - (char *)current_brk);
    
    return 0;
}