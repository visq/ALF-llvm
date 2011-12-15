/* test for floating point division */
#include <math.h>

#ifdef DEBUG
#include<stdio.h>
#endif

int main() {
  float fs = 0;
  double ds = 0;
  int i,j;
  for(i = 0; i<=100; i++) {
    for(j = 10; j<=100; j++) {
      fs += (float)i / (float)j;
      ds += (double)i / (double)j;
    }
  }
#ifdef DEBUG
    printf("fs: %f, ds: %f\n",fs,ds);
#endif
  if(fs <= 11909.0) return 1;
  if(ds <= 11909.0) return 1;
  if(fs >= 11910.0) return 1;
  if(ds >= 11910.0) return 1;
  return 0;
}
