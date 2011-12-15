#include <stdio.h>

void* my_memcpy(void*dest,const void*src,size_t n)
{
  size_t i;
  char*d       = dest;
  const char*s = src;
  for(i = 0; i < n; i++)
    {
      d[i] = s[i];
    }
  return dest;
}

int main(int argc, char** argv)
{
    int i,sum;
    int stack_array[20] = {0,1,1,2,3, 5,8,13,21,34, 55,89,144,233,377 ,610,987,1597,2584,4181};
    int stack_arr2[20];
    for(i=0,sum=0; i < 20; i++) {
        sum += stack_array[i];
        stack_array[i]++;
    }
#ifdef DEBUG
    printf("%d\n",sum);
#endif
    if(sum != 10945) return 1;
    my_memcpy(&stack_arr2[0],&stack_array[0],sizeof(stack_array));
    for(i=0,sum=0; i < 20; i++) {
        sum += stack_array[i]-1;
    }
#ifdef DEBUG
    printf("%d\n",sum);
#endif
    if(sum != 10945) return 1;
    return 0;
}
