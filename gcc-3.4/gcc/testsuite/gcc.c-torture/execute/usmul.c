int __attribute__ ((noinline)) foo (short x, unsigned short y)
{
  return x * y;
}

int main ()
{
  if (foo (-2, 0xffff) != -131070)
    abort ();
  if (foo (2, 0xffff) != 131070)
    abort ();
  if (foo (-32768, 0x8000) != -1073741824)
    abort ();
  if (foo (32767, 0x8000) != 1073709056)
    abort ();
  exit (0);
}

