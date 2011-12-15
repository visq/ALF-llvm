/* -----------------------------------------------------
 * ALF Backend testsuite
 * Author: Benedikt Huber <benedikt@vmars.tuwien.ac.at>
 *
 * pointer1: Pointer Initialization
 * -----------------------------------------------------
 */

struct s1_sub {
  short lo;
  short hi;
};

struct s1 {
    char a;
    short b;
    int c;
    long d;
    long long e;
    long f;
    struct s1_sub g;
    short h;
    char i;
};

struct s2 {
    char* a;
    short* b;
    int* c;
    long* d;
    long long* e;
    long* f;
    struct s1_sub* g;
    short* h;
    char* i;
};

char v1 = 1;
short v2 = 2;
int v3 = 3;
long v4 = 4;
long long v5 = 5;
long v6 = 6;
struct s1_sub v7 = {7,7};
short v8 = 8;
char v9 = 9;

struct s1 w1 = { 1, 2, 3, 4, 5, 6 , {7,7} , 8, 9 };
struct s2 w2 = { &v1, &v2, &v3, &v4, &v5, &v6, &v7, &v8, &v9 };
struct s1 w3;

int main() {
    if(w1.a != *w2.a) return 1;
    if(w1.b != *w2.b) return 1;
    if(w1.c != *w2.c) return 1;
    if(w1.d != *w2.d) return 1;
    if(w1.e != *w2.e) return 1;
    if(w1.f != *w2.f) return 1;
    if(w1.g.lo != w2.g->lo || w1.g.hi != w2.g->hi) return 1;
    if(w1.h != *w2.h) return 1;
    if(w1.i != *w2.i) return 1;
    if(w3.a + w3.b + w3.c + w3.d + w3.e + w3.f + w3.g.lo + w3.g.hi + w3.h + w3.i != 0) return 1;
    return 0;
}
