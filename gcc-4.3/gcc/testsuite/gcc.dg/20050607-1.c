/* { dg-do compile } */
/* { dg-options "-Wpadded" }
/* The struct internally constructed for the nested function should
   not result in a warning from -Wpadded. */
/* { dg-skip-if "Mark as unsupported until Bug 5827 is fixed." { bfin-*-* } } */
extern int baz(int (*) (int));
int foo(void)
{
  int k = 3;
  int bar(int x) {
    return x + k;
  }
  return baz(bar);
}
