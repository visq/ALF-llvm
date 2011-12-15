#include <stdint.h>
#include <stdio.h>

struct s { int a; char b; };
int8_t data[1024];
int8_t* p = &data[0];

void* myalloc(int bytes) {
    int8_t* chunk = p;
    p += bytes;
    return chunk;
}
struct s* f() {
    struct s* x = myalloc(sizeof(struct s));
    struct s* y = myalloc(sizeof(struct s));
    x->a = 2;
    y->a = 3;
    y->b = x->a;
    return y;
}
int main() {
    struct s* x = f();
    return x->a - x->b - 1;    
}