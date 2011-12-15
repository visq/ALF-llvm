typedef struct {
    char a;
    int b;
} s;
typedef struct {
    char a;
    int b;
} t;
int z[20];
int f(s x, t y) {
    char* a = &(x.a);
    int*  b = &(y.b);
    int*  c = &z[1];
    return (*a) + (*b) + (*c);
}