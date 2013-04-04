/* Test cases for pointer arithmetic using modulo */
#include <stdint.h>
#include <stddef.h>
 __attribute__(( aligned(4) ))
uint8_t data[]  = { 3, 5, 8, 9, 11, 13, 15, 18, 0 };
uint32_t test(uint8_t *p) {
  uint32_t c = 0, r = 0;
  while(*p++) {
    switch((size_t)p & 4) {
    case 0: c = *p;
    case 1: c = (c<<8) | *p;
    case 2: c = (c<<8) | *p;
    case 3: r = r ^ (c<<8 | *p);
    }
  }
  return r;
}
int main() {
  uint32_t r = test(&data[0]);
  if(r != 67372036) return 1;
  return 0;
}

