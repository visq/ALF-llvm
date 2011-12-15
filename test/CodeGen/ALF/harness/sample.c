#include <stdio.h> /* function and globals (stdout) imports */
#include <stdint.h>
/* A tricky type with unions and alignment requirements */
typedef struct {    
    char a;
    short b;
    int c;
    long d;
    char e;
    union {
        char a;
        int c;
    } f;
    char g;
} comp_t;

/* global export */
volatile int input = 2;
const int64_t seeds[] = { 17, 23, 64 };
int64_t oseeds[3] = {} ; // avoid tentative definitions
const int64_t mdim_array[2][2] = { {0, 1}, {1, 0} };
/* internal global */
static int fcalls = 0;
static comp_t my_struct = { .f.a = 3, .g = 4 };
// compute x**y
int64_t f (int64_t x,unsigned y) {
    int64_t r = 1;    
    while(y > 0) {
        r *= x;
        --y;
    }
    ++fcalls;
    ++my_struct.g;
    return r;
}
int main(int argc, char** argv) {
    int i;
    for(i = 0; i < 3; i++) {
        oseeds[i] = seeds[i] * input;
    }
    if(f(input,oseeds[1]>>8) != 1) return 1;
    return 0;
}
