/* { dg-do compile { target bfin-*-* } } */
/* { dg-options "-O2" } */
/* { dg-final { scan-assembler-times "LSETUP" 6 } } */

#define SIZE 1024

int foo (int (*x)[SIZE])
{
    int i, sum = 0;

    for  (i = 0; i < SIZE; i++) {
	int j;
	for (j = 0; j < SIZE; j++)
		sum += x[i][j];	
    }

    return sum;
}

int bar (int **x)
{
    int i, sum = 0;

    for  (i = 0; i < SIZE; i++) {
	int j;
	for (j = 0; j < SIZE; j++)
		sum += x[i][j];	
    }

    return sum;
}

int baz ()
{
    int i, sum = 0;
    int x[SIZE][SIZE];
    fill(x);
    for  (i = 0; i < SIZE; i++) {
	int j;
	for (j = 0; j < SIZE; j++)
		sum += x[i][j];	
    }

    return sum;
}
