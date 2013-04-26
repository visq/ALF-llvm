
int y = 5, z = 3;
int *p = 0; 
int *q = &z;

int main()
{
  if(p != &z) {
    p = &z;
  }
  if(q != 0) {
    q = &y;
  }
  if(2 * *p + *q == 11) {
    return 0;
  }
  return 1;
}
