volatile int out = 1;

typedef struct sB {
    char a;
    unsigned long b;  
} tB;

typedef struct {
    char a;
    tB b[3][4];
    char c;
} tA;

tA global = {
    .a = 50,
    .b = {
        { { .a =  2, .b = 28 } , { .a = 3, .b = 27 }, { .a = 4, .b = 26 }, { .a = 5, .b = 25 } },
        { { .a =  6, .b = 24 } , { .a = 7, .b = 23 }, { .a = 8, .b = 22 }, { .a = 9, .b = 21 } },
        { { .a = 10, .b = 20 } , { .a = 11, .b = 19 }, { .a = 12, .b = 18 }, { .a = 13, .b = 17 } }
    },
    .c = 100
};

int deref_direct() {
    unsigned x = (unsigned)global.a + (unsigned)global.c;
    if(x != 150) {
        return x;
    }
    int i,j;
    for(i = 0; i < 3; i++) {
        for(j = 0; j < 4; j++) {
            if(global.b[i][j].a + global.b[i][j].b != 30) {
                return global.b[i][j].a + global.b[i][j].b;
            }
        }
    }
    return 0;
}

int main(int argc, char** argv) {
    /* Direct deref */
    int r = deref_direct();
    if(r == 0) return 0;
    else       return 1;
}
