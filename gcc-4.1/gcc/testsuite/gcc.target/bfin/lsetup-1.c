/* { dg-do compile { target bfin-*-* } } */
/* { dg-options "-O2" } */
/* { dg-final { scan-assembler-times "LSETUP" 4 } } */

#include <stdio.h>

int main(){

  int k;
  unsigned c[288];

  for (k = 0; k < 144; k++)
    c[k] = 8;
  for (; k < 256; k++)
    c[k] = 9;
  for (; k < 280; k++)
    c[k] = 7;
  for (; k < 288; k++)
    c[k] = 8;

  for (k = 0; k < 288; k++)
    printf("%i ",c[k]);
  return 0;
}
