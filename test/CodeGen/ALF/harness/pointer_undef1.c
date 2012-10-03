/* Test case: undefined pointer arithmetic 1*/

#include <stdio.h>
#include <stddef.h>

#ifdef DEBUG
#define UEXPECT(a)  (printf("Expecting undef, actual value is: %lu\n",a), a)
#else
#define UEXPECT(a)  (a)
#endif

typedef struct {
  int x[4];
  char y[4];
  int z[4];
} mstruct;
mstruct a;
char str[9] = "9-char-s";
mstruct b;

int main()
{
  int expect[2] = {0, 0};
  mstruct c;

  /* ptr arithmetic between different stack variable and global variable (undefined) */
  size_t d6 = (void*)&c - (void*)&b;
  if(UEXPECT(d6) == sizeof(b)) expect[0] = 1;
  /* ptr arithmetic (struct s) between different global variables (depends on linker) */
  size_t d7 = &b - &a;
  if(UEXPECT(d7) == sizeof(a)) expect[1] = 1;
  /* Expecting 0..3 (all expect entries undefined) */
  return (expect[0]<<1) + expect[1];
}
