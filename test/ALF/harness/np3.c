typedef struct { char _pad ; int val; } pint;
pint y = { 0, 5 }, z = { 0, 3 };
pint *p = 0; 
int *q = &z.val;
pint **P = &p;
int **Q = &q;

int main()
{
  if(*P != &z) {
    p = &z;
  }
  if(*Q != 0) {
    q = &y.val;
  }
  if(2 * (*P)->val + **Q == 11) {
    return 0;
  }
  return 1;
}
