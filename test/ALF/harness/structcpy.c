#include <stdio.h>
#include <stdint.h>

struct s {
  uint64_t a;
  uint32_t b;
  uint16_t c;
  struct {
    uint16_t a;
    uint8_t b;
  } d;
};

struct s a = { .a = 0x0303030303030303, .b = 0x05050505, .c = 0x0707, .d = { . a = 0x0909, .b = 0x11 } };
volatile uint16_t vol = 0x0909;

struct s* cpy(struct s* dst, struct s* src) {
  *dst = *src;
  return dst;
}

uint64_t f(struct s* s) {

  struct s tmp = *cpy(s,s);
  tmp.d.a = vol % 0x1000; /* 0 - 0xfff */
  tmp.d.b = vol % 0x10;   /* 0 - 0xf   */
  tmp.c += tmp.d.a + tmp.d.b;
  tmp.b += tmp.c;
  tmp.a += tmp.b;
  return tmp.a - tmp.b + tmp.c - tmp.d.a;
}

int main(){
  uint64_t r64 = f(&a);
  uint32_t r32 = ((uint32_t)(r64>>32))+((uint32_t)r64);
#ifdef DEBUG
  printf("%d\n",r32);
#endif
  if(r32 < 101051648) return 1;
  if(r32 > 101068073) return 1;
  return 0;
}

