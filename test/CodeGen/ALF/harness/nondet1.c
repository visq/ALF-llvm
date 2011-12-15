/* testcase for an implementation of nondet() using volatile variables */

#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

int8_t i8_init     = -18;
uint32_t u32_init  = 3;

volatile int8_t* i8_ptr = &i8_init;
volatile uint32_t* u32_ptr = &u32_init;

int8_t nondet_i8() {
  return *i8_ptr;
}

uint32_t nondet_u32(uint32_t lb, uint32_t ub) {
  uint32_t v = *u32_ptr;
  if(v < lb) v = lb;
  if(v > ub) v = ub;
  return v;
}

int main()
{
  uint32_t v = nondet_u32(3,7) * nondet_u32(2,3);
  int32_t  vs = (int32_t) v;
  vs += nondet_i8();

  return vs; /* expecting: s[-122,148], and 0 with the initial values given for {i8,u32}_init */
}
