/* test dynamic size alloca and memset with non-constant argument (lowered) */
#include <stdio.h>

#include <string.h>
#include <stdio.h>
unsigned int f(int n)
{
    int i;
    unsigned int sum = 0;
    unsigned int array[n];

    memset(&array[0], 3, n*sizeof(unsigned int));
    for(i = 0; i < n; i++) {
        array[i] = array[i] & 0xff;
    }
    for(i = 1; i < n; i++) {
        array[i] += array[i-1];
    }
    for(i = 0; i < n; i++) {
        sum += array[i];
    }
    return sum;
}

int main(int argc, char** argv)
{
    unsigned int sum;
    sum = f(3) + f(7) + f(15);
#ifdef DEBUG
    printf("%d\n",sum);
#endif
    return 0;
}
