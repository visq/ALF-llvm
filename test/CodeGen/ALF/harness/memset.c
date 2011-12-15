#include <stdint.h>
#include <stdio.h>

int main()
{
  uint8_t ones[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  uint8_t i,sum;
  ones[0]=1;
  for(i = 1; i < 16; i++) {
    ones[i] += ones[i-1] + 1;
  }
  for(i = 0,sum=0; i < 16; i++) {
    sum += ones[i];
  }
#ifdef DEBUG
  printf("%d\n",sum);
#endif
  if(sum != 136) return 1;
  return 0;
}
