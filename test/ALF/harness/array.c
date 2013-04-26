volatile int out;

int x[4] = { 1,2,3,4 };

int deref(int* array) {
    return array[1] + array[3];
}

void modify(int *array) {
    array[0] = 1;
    array[1] = 2;
}

int read_x(int i) {
    return x[i % 4];
}

void loop() {
    while(x[0]) modify(&x[0]);
}

int main(int argc, char** argv) {
    x[0] = 4;
    x[1] = read_x(6);
    x[2] = 2;
    x[3] = 1;
    int r = x[1] + x[3]; /* Dereference global variable (r = 4) */
 
    x[3] = 3;
    int q = deref(&x[0]); /* Derefence local variables (q = 6) */
 
    modify(&x[0]);
    int s = read_x(4) + read_x(5); /* Dereference using unknown index (s = 3) */
    
    int t1 = (r&1) + (r&(~1));  /* 4 */
    int t2 = (q&1) + (q&(~1));  /* 6 */
    int t3 = (s&1) + (s&(~1));  /* 3 */

    if(t1 != 4) return 1;
    if(t2 != 6) return 1;
    if(t3 != 3) return 1;
    return 0;
}
