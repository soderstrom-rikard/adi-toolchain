
#include <stdio.h>
#include <stats.h>
#include <math_bf.h>

int main()
{
	float in_f[6] = {-0.2, -0.1, 0, 0.1, 0.2, 0.3}, f;

	fract16 in_fr16[6] = {0xe667, 0xf334, 0, 0xccc, 0x1999, 0x2666}, fr16;

	printf("rmsf:");
	f = rmsf(in_f, 6);
	printf("%f (should be 0.177951)\n", f);
	
	printf("rms_fr16\n");
	fr16 = rms_fr16(in_fr16, 6);
	printf("0x%hx (should be 0x16c6)\n", fr16);
		
	
	printf("meanf:");
	f = meanf(in_f, 6);
	printf("%f (should be 0x050000)\n", f);
	
	printf("mean_fr16\n");
	fr16 = mean_fr16(in_fr16, 6);
	printf("0x%hx (should be 0x666)\n", fr16);

	printf("Finished\n");
	return 0;
}

