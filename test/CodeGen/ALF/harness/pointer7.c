/* Test cases for pointer arithmetic using integers */
#include <stdint.h>
#include <stddef.h>
uint8_t data[]  = { 3, 5, 8, 9, 11, 13, 15, 18, 0 };
size_t ptr;
__attribute__((noinline))
void store_index(uint8_t *arr, int index) {
  ptr = (intptr_t)(&arr[index]);
}
__attribute__((noinline))
uint8_t load() {
  return *((uint8_t*)ptr);
}
__attribute__((noinline))
uint32_t test() {
  uint32_t r = 0;
  unsigned i;
  for(i = 0; i < sizeof(data)/sizeof(data[0]);i++) {
    store_index(data,i);
    r = ((r<<28)|(r>>4)) ^ load();
  }
  /* printf("%x\n",r); */
  return r;
}
int main() {
  uint32_t r = test();
  if(r != 0x2fdb9852) return 1;
  return 0;
}

