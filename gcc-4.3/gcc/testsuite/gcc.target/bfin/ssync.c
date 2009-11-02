/* { dg-do compile } */
/* { dg-final { scan-assembler "\[\t\]ssync" } } */

int main (void)
{
  __builtin_bfin_ssync ();
  return 0;
}
