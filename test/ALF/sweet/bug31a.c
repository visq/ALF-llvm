/* ASSUME g \in ((void*)d + [0,3]) */

#include <stdint.h>
int16_t *g;
int16_t d[2];
void m(void)
{
   int i;
   *g = 1;
   for (i=0; i<d[0]; i++)
      ;
}
