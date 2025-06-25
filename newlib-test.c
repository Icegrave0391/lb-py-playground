#include <stdio.h>
#include <unistd.h>

int testagain(void) {
  return 42;
}

int main(int argc, char *argv[]) {
  int a = 5; 
  int ans = testagain();
  
  // Write a test message to stdout
  write(1, "Hello from LiteBox!\n", 20);
  
  return ans; // Return the result from testagain
}
