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
  int res = 0;
  mstruct c;

  /* ptr arithmetic between different stack variable and global variable (undefined) */
  size_t d6 = (void*)&c - (void*)&a;
  res += UEXPECT(d6);

  /* ptr arithmetic (struct s) between different global variables (depends on linker) */
  size_t d7 = &b - &a;
  res += UEXPECT(d7);

  return res; /* expecting: [-200,200] */
}
