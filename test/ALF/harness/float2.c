/* simple test for floating point numbers */
float  o1f = 1.0000001,
       o2f = 1.0000000,
       z1f = 0.999999;
double z1d =  0.99999998; /* one as 32-bit float */
double o1d = 1.000000000000001,
       o2d = 1.000000000000000;

int main() {
  char c;
  short s;
  int i;
  unsigned u;
  
  int r = 28;
  c = z1f;        if(c == 0) r--;
  c = z1d;        if(c == 0) r--;
  c = o1f;        if(c == 1) r--;
  c = o2f;        if(c == 1) r--;
  c = o1d;        if(c == 1) r--;
  c = o2d;        if(c == 1) r--;
  c = (float)z1d; if(c == 1) r--;

  s = z1f;        if(s == 0) r--;
  s = z1d;        if(s == 0) r--;
  s = o1f;        if(s == 1) r--;
  s = o2f;        if(s == 1) r--;
  s = o1d;        if(s == 1) r--;
  s = o2d;        if(s == 1) r--;
  s = (float)z1d; if(s == 1) r--;

  i = z1f;        if(i == 0) r--;
  i = z1d;        if(i == 0) r--;
  i = o1f;        if(i == 1) r--;
  i = o2f;        if(i == 1) r--;
  i = o1d;        if(i == 1) r--;
  i = o2d;        if(i == 1) r--;
  i = (float)z1d; if(i == 1) r--;

  u = z1f;        if(u == 0) r--;
  u = z1d;        if(u == 0) r--;
  u = o1f;        if(u == 1) r--;
  u = o2f;        if(u == 1) r--;
  u = o1d;        if(u == 1) r--;
  u = o2d;        if(u == 1) r--;
  u = (float)z1d; if(u == 1) r--;

  return r;
}
