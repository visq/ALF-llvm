/* compare pointers from different frames */
/* NOTE: as of now, it is an error in ALF to compare pointers
   from different frames, so it is expected that this test fails
   as long as the ALF translator does not replace the subtraction
   by TOP */
/* Expected (undefined result): [0..1] */
int a;
int main() {
    int b = 3;
    if(&a - &b == sizeof(a)) return 1;
    else                     return 0;
}
