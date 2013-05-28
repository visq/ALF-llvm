/* RUN sweet -i=pow3.alf func=pow3 -ae  pu debug=trace
 */

#include <limits.h>

/* Minimal Loop example */
unsigned long long pow3(unsigned x) {
    if(x >= sizeof(unsigned long long) * 8) {
        return ULLONG_MAX; // two few bits to store result anyway
    }
    unsigned long long r = 1;
    while(x-- > 0) {
        r = r * 3;
    }
    return r;
}

