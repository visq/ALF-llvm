volatile int out;

int x[4] = { 1,2,3,4 };

int deref(int* array) {
    return array[1] + array[3];
}

int read_x(int i) {
    return x[i % 4];
}

int main(int argc, char** argv) {
    int r = x[0] + x[2]; /* Dereference global variable (r = 4) */
    int q = deref(&x[0]); /* Derefence local variables (q = 6) */
    int s = read_x(4) + read_x(5); /* Dereference using unknown index (s = 3) */
    int t1 = (r&1) + (r&(~1));  /* 4 */
    int t2 = (q&1) + (q&(~1));  /* 6 */
    int t3 = (s&1) + (s&(~1));  /* 3 */
    if(t1 + t2 + t3 != 13) {
        return -1;
    }
    return read_x(4) - 1;
}