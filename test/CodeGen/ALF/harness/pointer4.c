/* Test cases for pointer arithmetic on absolute addresses */
/* Expecting memory areas:
   - 0x000 - 0x100
   - 0x100000 - 0x200000
*/
#include <stdio.h>
#include <stddef.h>

#ifdef DEBUG
#define EXPECT(e,a) (printf("Expected: %d, Actual: %d\n",e,a), (e==a) ? 0 : 1)
#else
#define EXPECT(e,a) ((e==a) ? 0 : 1)
#endif

#ifdef DEBUG
#define A ((size_t)&a)
#define B ((size_t)&b)
#define C ((size_t)&s.c)
#define D ((size_t)&s.d)
#else
#define BASE1  ((size_t)0x20)
#define BASE2  ((size_t)0x110000)
#define BASE3  ((size_t)0x1f0000)
#define A (BASE1)
#define B (BASE1+sizeof(int))
#define C (BASE2)
#define D (BASE3)
#endif

#define VPTR(x) ((volatile int*)x)
#define PTR(x)  ((int*)x)
#define SPTR(x) ((struct s*)x)
#define STEP    ((D-C)/(4*sizeof(struct s)))

struct s {
  short f1;
  char  f2;
};

#ifdef DEBUG
int a;
int b[4];
struct {
    struct s c;
    int _p1[1000];
    struct s d;
} s;
#endif

int dbg;

int main()
{
  int res = 0;
  int i;
  int x;
  int *xp;
  struct s * sp;

  PTR(B)[0] = 1;
  PTR(B)[1] = 2;
  PTR(B)[2] = 3;
  PTR(B)[3] = 4;
  SPTR(C)->f1 = 5;
  SPTR(D)->f2 = 6;
#ifdef DEBUG
  printf("Address of a: %p\n",&a);
  printf("Address of b: %p\n",&b[0]);
  printf("Address of c: %p\n",&s.c);
  printf("Address of d: %p\n",&s.d);
#endif
  /* store (non-volatile) to absolute address */
  *PTR(A) = 17;
  /* load (non-volatile) from absolute address */
  x = *PTR(A);
  res += EXPECT(17, x);

  /* store (volatile) to absolute address */
  *VPTR(A) = 23;
  /* load (non-volatile) from absolute address */
  x = *PTR(A);
  res += EXPECT(23, x);

  /* pointer arithmetic */
  xp = PTR(B);
  for(i = 0; i < 3; i++) {
    if(*(PTR(B)+i) == 3) xp=PTR(B)+i;
  }
  x = *xp;
  res += EXPECT(3,x);


  /* Structs, larger base offset */
  res += EXPECT(11, SPTR(C)->f1 + SPTR(D)->f2);

  /* Moving around in a larger memory area */
  x  = 0;
  sp = SPTR(C);
  i  = 0;

  while(sp <= SPTR(D))
  {
#ifdef DEBUG
      printf("Writing at %p\n",sp);
#endif
      sp->f1 = 0xafe;
      sp += STEP;
      if(i++ > 32) break;
  }
  i = 0;
  while(sp >= SPTR(C) + STEP)
  {
#ifdef DEBUG
      printf("Reading at %p\n",sp);
#endif
      sp -= STEP;
      x += sp->f1;
      if(i++ > 32) break;
  }
  dbg = i;
  res += EXPECT(5*0xafe, x);

  return res; /* expecting: 0 */
}
