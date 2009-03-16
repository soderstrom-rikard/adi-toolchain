/* { dg-do compile { target bfin-*-* } } */
/* { dg-options "-O2" } */
/* { dg-final { scan-assembler "LSETUP" } } */

void test(unsigned int start, unsigned int end)
{
  unsigned int count;
  start = start & -32;
  end = end & -32;
  for (count = (end - start); count; count -= 32)
    __asm__ __volatile__("FLUSH[%0++];" :
			 "+p"(start));
}
