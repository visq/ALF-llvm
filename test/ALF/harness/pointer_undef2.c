/* Test case: pointer arithmetic between different frames */
#include <stdio.h>
#include <stddef.h>

#ifdef DEBUG
#define EXPECT(e,a) (printf("Expected: %lu, Actual: %lu\n",e,a), (e==a) ? 0 : 1)
#define UEXPECT(a)  (printf("Expecting undef, actual value is: %lu\n",a), a)
#else
#define EXPECT(e,a) ((e==a) ? 0 : 1)
#define UEXPECT(a)  (a)
#endif

char a[10] = "10-char-s";
char str[9] = "9-char-s";
char b[10] = "10-char-s";

int main()
{
  int res = 0;
  int i = 0;

  /* ptr arithmetic (struct s) between different global variables (depends on linker) */
  /* Update: ALF will (correctly) assume that these pointers never alias, but cannot decide which one is larger */
  char *s = (char*) &a;
  char *e = (char*) &b;
  unsigned  r = 0;
  while(s != e)
    {
      r = (r << 1);
      if(s < e)
        r++;
      if(++i >= 10)
        break;
      s++;
    }
  /* i should be 10 */
  /* r should be u[0,1023] */
  res += UEXPECT(r);
  res += EXPECT(i, 10);
  return r; /* expecting: [0,1023] */
}
