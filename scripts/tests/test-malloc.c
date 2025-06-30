#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[], char *envp[]) {
    printf("Testing malloc/free with sbrk implementation...\n");
    
    // Test 1: Basic malloc/free
    printf("Test 1: Basic malloc/free\n");
    void *ptr1 = malloc(1024);
    if (ptr1 == NULL) {
        printf("ERROR: malloc(1024) failed\n");
        return 1;
    }
    printf("malloc(1024) = %p\n", ptr1);
    
    // Write some data to verify the memory is usable
    memset(ptr1, 0xAB, 1024);
    printf("Memory write test passed\n");
    
    free(ptr1);
    printf("free() completed\n");
    
    // Test 2: Multiple allocations
    printf("\nTest 2: Multiple allocations\n");
    void *ptrs[10];
    for (int i = 0; i < 10; i++) {
        ptrs[i] = malloc(256);
        if (ptrs[i] == NULL) {
            printf("ERROR: malloc(256) failed on iteration %d\n", i);
            return 1;
        }
        printf("malloc[%d] = %p\n", i, ptrs[i]);
        memset(ptrs[i], i, 256);  // Fill with pattern
    }
    
    // Free all allocations
    for (int i = 0; i < 10; i++) {
        free(ptrs[i]);
        printf("free[%d] completed\n", i);
    }
    
    // Test 3: Large allocation
    printf("\nTest 3: Large allocation\n");
    void *large_ptr = malloc(64 * 1024);  // 64KB
    if (large_ptr == NULL) {
        printf("ERROR: malloc(64KB) failed\n");
        return 1;
    }
    printf("malloc(64KB) = %p\n", large_ptr);
    
    // Test the memory
    memset(large_ptr, 0xCC, 64 * 1024);
    printf("Large memory write test passed\n");
    
    free(large_ptr);
    printf("Large free() completed\n");
    
    printf("\nAll malloc/free tests passed!\n");
    return 0;
}
