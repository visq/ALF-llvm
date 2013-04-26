/* union1: correct use of unions with tagging */
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
uint8_t* load_char_array(struct Value *v) {
  switch(v->tag) {
  case tiff_chars: return v->value.UCharArray; break;
  default: return (uint8_t*)0;
  }
}
__attribute__((noinline))
void store(struct Value* v, enum TIFF_value_tag tag, union TIFF_value value) {
  v->tag = tag;
  v->value = value;
}
int main(int argc, char **argv) {
  uint8_t chararray[2] = { 99, 100 };
  union TIFF_value tv;
  struct Value v;
  /* 1 */
  tv.UChar = 99;
  store(&v, tiff_char,tv);
  if(load_char(&v) != 99) return 1;
  /* 2 */
  tv.UCharArray = &chararray[0];
  store(&v, tiff_chars, tv);
  if(load_char_array(&v)[1] != 100) return 1;
  return 0;
}
