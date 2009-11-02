/* { dg-do compile } */
/* { dg-final { scan-assembler "\[\t\]csync" } } */

int main (void)
{
  __builtin_bfin_csync ();
  return 0;
}
