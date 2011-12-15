/* Test case: undefined pointer arithmetic (dynamic) */
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
  int i = 0;

  /* ptr arithmetic (struct s) between different global variables (depends on linker) */
  char *s = (char*) &a;
  char *e = (char*) &b;
  char  r;
  while(s != e)
    {
      r+=(*s++)%2;
      if(i++ > 10) break;
    }
  res += UEXPECT(r);
  return r; /* expecting: [-200,200] */
}
