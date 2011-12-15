/* testcase for restrictions, from Linus Kaellberg */

#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

int vint_init = 9;
volatile int* vint_ptr = &vint_init;

int tmp;

int nondet_int() {
  return *vint_ptr;
}

int main()
{
    int i;
    i = nondet_int(); /* Returns the top value */
    if (0 <= i && i <10) /* i Becomes [0 .. 9] */
    {
        do
        {
            ++i;
            tmp = i;
        }
        while (tmp != 10);
    }
    else
    {
        i=10;
    }
    return i-10;
}
