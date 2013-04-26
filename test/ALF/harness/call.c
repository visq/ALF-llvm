int a(int);
int b(int);

int a(int x) {
    return b(x) * 7;
}
int b(int x) {
    return x >> 1;
}
int main() {
    int r;
    r = b(12);
    if(r != 42) return 1;
    return 0;
}
