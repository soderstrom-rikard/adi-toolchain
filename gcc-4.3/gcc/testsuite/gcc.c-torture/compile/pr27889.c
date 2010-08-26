/* { dg-skip-if "Mark as unsupported until Bug 5827 is fixed." { bfin-*-* } } */
void h(void (*)(void));
_Complex int g (void)
{
  _Complex int x;
  void f(void)
  {
     x = x + x;
  }
  h(f);
  return x;
}
