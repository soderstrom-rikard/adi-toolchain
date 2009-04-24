/* { dg-do compile { target bfin-*-* } } */
/* { dg-options "-O2" } */
/* { dg-final { scan-assembler "LSETUP" } } */


int foo(short b[], long int n, long int f)
{
 int i;

 for (i = n - 2; i >= 0; i--) {
  f -= b[i];
 }
 return f;
}

