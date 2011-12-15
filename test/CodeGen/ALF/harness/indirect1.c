/* test for indirect jumps/branches 1 */
#include <stdint.h>
#ifdef DEBUG
#include <stdio.h>
#endif

typedef int16_t (*fun)(int16_t);
int16_t f(int16_t arg) {
    return arg*2;
}
fun fp = &f;
int main()
{
    int16_t r;
    r = fp(8);
#ifdef DEBUG
    printf("%d\n",r);
#endif
    if(r != 16) return 1;
    return 0;
}
