/* Check that long call  */
/* { dg-do run { target bfin-*-* } } */
/* { dg-options "-O2 -mlong-calls" } */

extern void abort (void);

int __attribute__((longcall, noinline))
foo (int a, int b)
{
  return a * 2 + b * 3;
}

int __attribute__((shortcall, noinline))
bar (int a, int b)
{
  return a * 3 + b * 7;
}

int __attribute__((noinline))
baz (int a, int b)
{
  return a * 2 + b * 5;
}

int __attribute__((noinline))
t1 ()
{
  if (foo (1, 3) != 1 * 2 + 3 * 3)
    abort ();
  if (bar (1, 3) != 1 * 3 + 3 * 7)
    abort ();
  if (baz (1, 3) != 1 * 2 + 3 * 5)
    abort ();

  return 4;
}

int __attribute__((noinline))
t2 (int a, int b)
{
  return foo (a, b);
}

int __attribute__((noinline))
t3 (int a, int b)
{
  return bar (a, b);
}

int __attribute__((noinline))
t4 (int a, int b)
{
  return baz (a, b);
}

int main ()
{
  if (t1 () != 4)
    abort ();
  if (t2 (2, 9) != 2 * 2 + 9 * 3)
    abort ();
  if (t3 (2, 9) != 2 * 3 + 9 * 7)
    abort ();
  if (t4 (2, 9) != 2 * 2 + 9 * 5)
    abort ();

  return 0;
}
