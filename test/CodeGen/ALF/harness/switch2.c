/* MERGE=fr */
/* test large switch statements */
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

/* non-deterministic u32s */
uint32_t u32_init  = 3;
volatile uint32_t* u32_ptr = &u32_init;
uint32_t nondet_u32(uint32_t lb, uint32_t ub) {
  uint32_t v = *u32_ptr;
  if(v < lb) v = lb;
  if(v > ub) v = ub;
  return v;
}

int s(uint32_t v) {
  int i;
  uint32_t r1,r2;
  for(i = 0, r2=0; i < 32; i++) r2 ^= ((v>>i)&1);
  switch(v)
    {
    case 0:
    case 3:
    case 7:
    case 13:
    case 21:
    case 29:
    case 381:
    case 4872:
    case 5001:
      for(i = 0, r1=0; i < 32; i++ ) r1 = r1 ^ ((v>>i)&0x7);
      break;
    default:
      for(i = 0, r1=0; i < 32; i++)  r1 = r1 ^ ((v>>i)&0x3);
      break;
    }
#ifdef DEBUG
  printf("r1=%d, r2=%d, v=%d\n",r1&1,r2,v);
#endif
  if((r1&1) != r2) return 1;
  return 0;
}

int main()
{
  return s(nondet_u32(1,8192)) + s(nondet_u32(5001,5001)) + s(nondet_u32(5002,5002));
}
