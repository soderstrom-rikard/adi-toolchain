
#include <stdio.h>
#include <math_bf.h>

int main()
{
	fract16 fr16 = 0x0;
	
	fr16 = atan_fr16(0x1234);
	printf("atan_fr16(0x1234): 0x%hx (should be 0x1215)\n", fr16);

	printf("Finished\n");
	return 0;
}

