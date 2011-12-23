/* Taken from: http://git.uclibc.org/uClibc/tree/libc/string/memcpy.c
 * Copyright (C) 2002     Manuel Novoa III
 * Copyright (C) 2000-2005 Erik Andersen <andersen@uclibc.org>
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */

void *memcpy(void * __restrict s1, const void * __restrict s2, size_t n)
{
    register char *r1 = s1;
    register const char *r2 = s2;

    while (n) {
        *r1++ = *r2++;
        --n;
    }
    
    return s1;
}

/*
 * Taken from http://git.uclibc.org/uClibc/tree/libc/string/memmove.c
 * Copyright (C) 2002     Manuel Novoa III
 * Copyright (C) 2000-2005 Erik Andersen <andersen@uclibc.org>
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */

void *memmove(void *s1, const void *s2, size_t n)
{
	register char *s = (char *) s1;
	register const char *p = (const char *) s2;

	if (p >= s) {
		while (n) {
			*s++ = *p++;
			--n;
		}
	} else {
		while (n) {
			--n;
			s[n] = p[n];
		}
	}

	return s1;
}

/*
 * Taken from http://git.uclibc.org/uClibc/tree/libc/string/memmove.c
 * Copyright (C) 2002     Manuel Novoa III
 * Copyright (C) 2000-2005 Erik Andersen <andersen@uclibc.org>
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */

void *memset(void *s, int c, size_t n)
{
	register unsigned char *p = (unsigned char *) s;

	while (n) {
		*p++ = (unsigned char) c;
		--n;
	}

	return s;
}

/* stubs */
double atan(double x)
{
    volatile double _tmp = 0.0;
    return _tmp;
}
double cos(double x)
{
    volatile double _tmp = 0.0;
    return _tmp;
}
double exp(double x)
{
    volatile double _tmp = 0.0;
    return _tmp;
}
double log(double x)
{
    volatile double _tmp = 0.0;
    return _tmp;
}
double sin(double x)
{
    volatile double _tmp = 0.0;
    return _tmp;
}
double sqrt(double x)
{
    volatile double _tmp = 0.0;
    return _tmp;
}
double frexp(double x, int *exp)
{
    volatile double _tmp = 0.0;
    return _tmp;
}
float frexpf(float x, int *exp)
{
    volatile float _tmp = 0.0;
    return _tmp;
}
long double frexpl(long double x, int *exp)
{
    volatile long double _tmp = 0.0;
    return _tmp;
}
double ldexp(double x, int exp)
{
    volatile double _tmp = 0.0;
    return _tmp;
}
float ldexpf(float x, int exp)
{
    volatile float _tmp = 0.0;
    return _tmp;
}
long double ldexpl(long double x, int exp)
{
    volatile long double _tmp = 0.0;
    return _tmp;
}
