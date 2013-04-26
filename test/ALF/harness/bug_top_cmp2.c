/* compare pointers from different frames */
/* Expected: [0..1] */
int a;
int main() {
    int b = 3;
    if(&a - &b == sizeof(a)) return 1;
    else                     return 0;
}
