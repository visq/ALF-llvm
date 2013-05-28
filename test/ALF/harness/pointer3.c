/* Test case for pointer arithmetic alignment, packed structs */
#include <stdio.h>
#include <stddef.h>

#ifdef DEBUG
#define EXPECT(e,a) (printf("Expected: %lu, Actual: %lu\n",e,a), (e==a) ? 0 : 1)
#else
#define EXPECT(e,a) ((e==a) ? 0 : 1)
#endif

typedef struct {
  int   x;
  short y;
  char  z;
  short u;
  int   v;
  long long w;
} mstruct;

typedef struct {
  mstruct dat[2];
} arr_of_mstruct;

mstruct dat[2];

int main()
{
  int res = 0;
  mstruct* a = &dat[0];
  size_t diff;

  /* ptr arithmetic on structs */
  diff = (void*) &dat[1] -  (void*)&dat[0];
  res += EXPECT(offsetof(arr_of_mstruct,dat[1]),diff);  

  /* ptr arithmetic (byte) on struct elements */
  diff = (void*) &a->y -  (void*)&a->x;
  res += EXPECT(offsetof(mstruct,y),diff);
  diff = (void*) &a->z -  (void*)&a->x;
  res += EXPECT(offsetof(mstruct,z),diff);
  diff = (void*) &a->u -  (void*)&a->x;
  res += EXPECT(offsetof(mstruct,u),diff);
  diff = (void*) &a->v -  (void*)&a->x;
  res += EXPECT(offsetof(mstruct,v),diff);
  diff = (void*) &a->w -  (void*)&a->x;
  res += EXPECT(offsetof(mstruct,w),diff);

  diff = (void*) &a->z -  (void*)&a->y;
  res += EXPECT(offsetof(mstruct,z)-offsetof(mstruct,y),diff);
  diff = (void*) &a->u -  (void*)&a->y;
  res += EXPECT(offsetof(mstruct,u)-offsetof(mstruct,y),diff);
  diff = (void*) &a->v -  (void*)&a->y;
  res += EXPECT(offsetof(mstruct,v)-offsetof(mstruct,y),diff);
  diff = (void*) &a->w -  (void*)&a->y;
  res += EXPECT(offsetof(mstruct,w)-offsetof(mstruct,y),diff);

  diff = (void*) &a->u -  (void*)&a->z;
  res += EXPECT(offsetof(mstruct,u)-offsetof(mstruct,z),diff);
  diff = (void*) &a->v -  (void*)&a->z;
  res += EXPECT(offsetof(mstruct,v)-offsetof(mstruct,z),diff);
  diff = (void*) &a->w -  (void*)&a->z;
  res += EXPECT(offsetof(mstruct,w)-offsetof(mstruct,z),diff);

  return res; /* expecting: 0 */
}
