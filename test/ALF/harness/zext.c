volatile int out = 0;
void fail() {
    while(out);
}

#include <stdint.h>
int x = 254;
uint32_t demo_value() {    
    return x*x;
}
uint16_t zext(uint8_t arg) {
    return arg;
}
uint32_t zext32(uint16_t arg) {
    return arg;
}
int main(int argc, char**argv) {
    uint32_t arg = demo_value();
    uint32_t r = zext((uint8_t) arg);
    uint32_t s = zext32((uint16_t) arg);
    if(r != 4 || s != 64516) fail();
    return 0;
}