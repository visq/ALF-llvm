/* Test cases for pointer arithmetic */

#include <stdio.h>
#include <stddef.h>

#ifdef DEBUG
#define EXPECT(e,a) (printf("Expected: %lu, Actual: %lu\n",e,a), (e==a) ? 0 : 1)
#else
#define EXPECT(e,a) ((e==a) ? 0 : 1)
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

  /* ptr arithmetic on array elements */
  size_t d1 = &a.x[3] - &a.x[0];
  res += EXPECT(3ul, d1);

   /* ptr arithmetic (array, floored) on struct elements */
  size_t d2 = &b.z -  &b.x;
  res += EXPECT(offsetof(mstruct,z) / sizeof(int[4]),d2);

  /* ptr arithmetic (byte) on struct elements */
  size_t d3 = (void*) &b.z -  (void*)&b.x;
  res += EXPECT(offsetof(mstruct,z),d3);

  /* ptr arithmetic (byte) on inner struct elements */
  size_t d4 = (void*)&c.y[2] - (void*)&c.x[1];
  res += EXPECT(offsetof(mstruct,y[2]) - offsetof(mstruct,x[1]), d4);

  /* ptr arithmetic (loop) */
  int steps = 0;
  char *p1  = &str[1];
  char *p2  = &str[8];
  while(p1 < p2) {
    steps++;
    p1++;
    --p2;
  }
  res += EXPECT(4, steps);

  return res; /* expecting: 0 */
}
