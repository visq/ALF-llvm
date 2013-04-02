/* union4: unions to convert between structurally equivalent types */
#include <stdint.h>

struct Rational {
  uint32_t Numer;
  uint32_t Denom;
};

union TIFF_value {		/* don't know the type of the     */
  uint8_t UChar;		/* data value(s) in advance       */
  uint16_t UShort;
  uint32_t ULong;
  struct Rational Rat;

  uint8_t *UCharArray;
  uint16_t *UShortArray;
  uint32_t *ULongArray;
  struct Rational *RatArray;
};
enum TIFF_value_tag { tiff_char, tiff_short, tiff_long, tiff_rat, tiff_chars, tiff_shorts, tiff_longs, tiff_rats };
struct Value {
  enum TIFF_value_tag tag;
  union TIFF_value value;
};
__attribute__((noinline))
uint32_t* load_long_array(struct Value *v) {
  switch(v->tag) {
  case tiff_longs: return v->value.ULongArray; break;
  default: return (uint32_t*)0;
  }
}
__attribute__((noinline))
void store(struct Value* v, enum TIFF_value_tag tag, union TIFF_value value) {
  v->tag = tag;
  v->value = value;
}
int main(int argc, char **argv) {
  struct Rational ratarray[2] = { { .Numer = 99, .Denom = 100 }, { .Numer = 101, .Denom = 102 }};
  union TIFF_value tv;
  struct Value v;
  /*  */
  tv.RatArray = &ratarray[0];
  store(&v, tiff_rats,tv);
  v.tag = tiff_longs;
  if(load_long_array(&v)[0] != 99) return 1;
  return 0;
}
