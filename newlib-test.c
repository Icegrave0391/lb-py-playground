#include <stdio.h>
// quick test
#include <sys/stat.h>

// int fstat(int fd, struct stat *buf) {
//   return 0;               // Return success
// }

int testagain(void) {
  return 42;
}

void main(void) {
  int a = 5; 
  int ans = testagain();
  // putchar('a');
}

void _start(void) {
  // This function is called before main, typically used for initialization.
  // You can put any setup code here.
  main();
}