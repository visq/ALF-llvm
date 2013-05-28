/* union2: use of unions to truncate from larger to smaller integer types */
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
uint8_t load_char(struct Value* v) {
  switch(v->tag) {
  case tiff_char: return v->value.UChar; break;
  default: return 0;
  }
}
__attribute__((noinline))
void store(struct Value* v, enum TIFF_value_tag tag, union TIFF_value value) {
  v->tag = tag;
  v->value = value;
}
int main(int argc, char **argv) {
  union TIFF_value tv;
  struct Value v;
  /* long -> char (depends on little/big endian) */
  tv.ULong = 0x3F4F5F3F;
  store(&v, tiff_long, tv);
  v.tag = tiff_char;
  if(load_char(&v) != 0x3F) return 1;
  return 0;
}
