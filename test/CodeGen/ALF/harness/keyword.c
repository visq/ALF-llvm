/* check that keyword (select) is ok for both lrefs and frefs */
__attribute__((noinline))
int select(int select) {
    return (select > 0) ? 7 : 13;
}
int main(int argc, char**argv) {
  int i;
  int r = 0;
  for(i = 0 ; i < 1117; i++) {
      r += select(i);
  }
  if(r != 7825) return 1;
  return 0;
}