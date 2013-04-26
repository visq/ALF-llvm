int x;
void f() {
    x = 1 + x << 2;
}
int main() {
    f();
    return 0;
}