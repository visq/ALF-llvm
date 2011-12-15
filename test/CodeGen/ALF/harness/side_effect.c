volatile int out;

int x[4] = { 4,3,2,1 };

int main(int argc, char** argv) {
    int r = x[1] + x[3]; /* Dereference global variable (r = 4) */  
    x[1] = 2;
    int t1 = (r&1) + (r&(~1));  /* 4 */   
    if(t1 != 4) return 1;
    return 0;
}
