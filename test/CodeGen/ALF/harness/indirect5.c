/* test for indirect jumps/branches 5: labels as addresses */
/* a bug (http://llvm.org/bugs/show_bug.cgi?id=10286)
 * in clang prevents this from working,
 * fixed in commit (r136768) */
#include <stdint.h>
#ifdef DEBUG
#include <stdio.h>
#endif

volatile int select;
typedef int16_t (*fun)(int16_t);
int16_t f(int16_t arg, int select) {
  void *fs[] = { &&f, &&g, &&h };  
  goto *fs[select%3];
 f:
  return (arg+1)/2;
 g:
  return arg*2;
 h:
  return arg+1;
}
int main()
{
  int16_t t1 = 0;
  int16_t t2 = 3;
  int16_t t3 = 7;
  int16_t r1,r2,r3,s;
  
  r1 = f(t1,select%3); /* 0 0  1 => [0,1]  */
  r2 = f(t2,select%3); /* 2 6  4 => [2,6]  */
  r3 = f(t3,select%3); /* 4 14 8 => [4,14] */
#ifdef DEBUG
  printf("%d,%d,%d\n",r1,r2,r3);
#endif
  s = r1+r2+r3-6; /* [0,15], 0 if select stays 0 */
  return s;
}
