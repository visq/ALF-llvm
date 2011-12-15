/* Testing temporary variables */
unsigned int nondet_uint()
{
    volatile unsigned int x = 0;
    return x;
}

int a(unsigned int x)
{
    unsigned int i;
    i = x + 1;
    if(i <= 3) goto l;
    i = 3;
l:
    return i;
}
int main(int argc, char **argv)
{
    unsigned int r;
    unsigned int v = nondet_uint();
    r = a(v) + a(v+1); /* [3,6] */

#ifdef DEBUG
    printf("a(v) + a(v+1) = %u | v = %u\n",r,v);
#endif

    if(r < 3) return 255;
    if(r > 6) return 255;

#ifdef DEBUG
    return 0;
#endif

    return r;
}
