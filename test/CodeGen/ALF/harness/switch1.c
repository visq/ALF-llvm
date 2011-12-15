/* MERGE=fr */
/* test large switch statements */
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

/* non-deterministic u32s */
uint32_t u32_init  = 1;
volatile uint32_t* u32_ptr = &u32_init;
uint32_t nondet_u32(uint32_t lb, uint32_t ub) {
  uint32_t v = *u32_ptr;
  if(v < lb) v = lb;
  if(v > ub) v = ub;
  return v;
}
int s(int arg, int v) {
    switch(arg) {
    case 0:  return v*3;
    case 1:  return v*5;
    case 2:  return v*7;
    default: return v*11;
    }
}

int main()
{
    int r,i;
    r=0;
    for(i=0;i<4;i++)
    {
        r+=s(i, nondet_u32(1,3)); 
    }
    /* r \in [26,78] */
    return r-26; /* [0,52] */
}
