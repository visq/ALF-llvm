/* floating point to char conversion bug in SWEET */
double z1d =  0.99999998; /* one as 32-bit float */

int main() {
  if((char)z1d==0) return 0;
  return 1;
}
