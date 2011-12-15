volatile int out = 1;
void fail() {
    while(out);
}

#include <stdint.h>
int x = 66;
int32_t demo_value() {    
    return -(x*x);
}
int16_t zext(int8_t arg) {
    return arg;
}
int32_t zext32(int16_t arg) {
    return arg;
}
int main(int argc, char**argv) {
    int32_t arg = demo_value();
    int32_t r = zext((int8_t) arg);
    int32_t s = zext32((int16_t) arg);
    if(r != -4 || s != -4356) fail();
    return 0;
}