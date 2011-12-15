/* test for indirect jumps/branches 3 (array index for FP init) */
#include <stdint.h>
#ifdef DEBUG
#include <stdio.h>
#endif

volatile int select;
typedef int16_t (*fun)(int16_t);
int16_t f(int16_t arg) {
  return (arg+1)/2;
}
int16_t g(int16_t arg) {
  return arg*2;
}
int16_t h(int16_t arg) {
  return arg+1;
}
int main()
{
  fun fs[3];
  int16_t t1 = 0;
  int16_t t2 = 3;
  int16_t t3 = 7;
  int16_t r1,r2,r3,s;
  
  fs[2] = h;
  fs[1] = g;
  fs[0] = f;
  r1 = fs[select%3](t1); /* 0 0  1 => [0,1]  */
  r2 = fs[select%3](t2); /* 2 6  4 => [2,6]  */
  r3 = fs[select%3](t3); /* 4 14 8 => [4,14] */
#ifdef DEBUG
  printf("%d,%d,%d\n",r1,r2,r3);
#endif
  s = r1+r2+r3-6; /* [0,15], 0 if select stays 0 */
  return s;
}
