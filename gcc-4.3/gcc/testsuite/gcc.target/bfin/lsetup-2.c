/* { dg-do compile { target bfin-*-* } } */
/* { dg-options "-O2" } */
/* { dg-final { scan-assembler-times "LSETUP" 2 } } */

#include <stdlib.h>
#include <stdio.h>

#define SIZE 1024

void foo ()
{
    int index, sum = 0, *x;

    x = malloc (SIZE);

    for  (index = 0; index < SIZE ; index++) {
	sum += x[index];
    }

    printf("%i",sum);
}

void bar ()
{
    int index, sum = 0, x[SIZE];

    for  (index = 0; index < SIZE ; index++) {
	sum += x[index];
    }

    printf("%i",sum);
}

