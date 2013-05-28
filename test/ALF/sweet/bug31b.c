/* ASSUME: x \in [0,1] */
/* d at loop entry: [1,0] \join [0,1] = [[0,1],[0,1]] */

#include <stdint.h>
int16_t *g;
int16_t d[2];
int16_t x;
void m(void)
{
   int i;
   g = &d[x];
   *g = 1;
   for (i=0; i<d[0]; i++)
      ;
}
