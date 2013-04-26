/* RUN sweet -i=np1.alf func=main -ae css pu debug=trace
 */

#define Y 3
#define Z 7

int y = Y, z = Z;
int *p = 0; 

int main()
{
  if(p != 0) {
    p = &z;
  }
  if(p != &z) {
    p = &y;
  }
  if(*p == Y) {
    return 0;
  } else {
    return -1;
  }
}
