/* test for infinity and NaN floating point constants and values */
#include <math.h>
volatile int in;
float  nan_f = NAN, pinff = INFINITY, ninff = -INFINITY;
double nand = NAN, pinfd = INFINITY, ninfd = -INFINITY;

int main() {
  volatile float zf = 0, n1f = 0;
  volatile double zd = 0, n1d = 0;
  if(in) {
    n1f = n1d = zf/zd;
  } else {
    n1f = n1d = zd/zf;
  }
  int r = 0;
  if(n1d <  nan_f)  r++;
  if(n1d >  nand)   r++;
  if(n1d >= pinfd)  r++;
  if(n1f <= ninfd)  r++;
  return r;
}
