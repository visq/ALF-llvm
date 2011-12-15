/* simple test for floating point numbers */
float  pif = 3.1415927;
double pid = 3.141592653589793;

int main() {
  float  pifl = 3.1415926, pifu = 3.1415929;
  double pidl = 3.141592653589792, pidu = 3.141592653589794;
  int r = 6;
  if(pifl < pif) r--;
  if(pifl < pid) r--;
  if(pidl < pid) r--;
  if(pifu > pif) r--;
  if(pifu > pid) r--;
  if(pidu > pid) r--;
  return r;
}
