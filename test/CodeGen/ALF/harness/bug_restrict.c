/* bug with restrictions */
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

/* non-deterministic u32s */
volatile uint32_t g;
uint32_t nondet_u32(int lb) {
  uint32_t v = g;
  if(v < lb) v = lb;
  return v;
}
int main()
{
  uint32_t v = nondet_u32(0);
  if(v > 0) v = 0;
  return v;
}
