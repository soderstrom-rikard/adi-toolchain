	.text

	p0.H = 0x12345678;
	P0.l = 0x12345678;

	CC = R3 < 4;
	CC = R3 < 7;
	CC = R3 < 8;
	CC = R3 <= 4;
	CC = R3 <= 7;
	CC = R3 <= 8;

	A1 -= M2.h * R3.L, A0 -= M2.l * R3.L;

	R1.H = (A1=R7.L*R5.L) , A0 += R1.L*R0.L (IS);

	a0 += R2.L * R3.L (IU);
	a0 += R2.L * R3.L (T);
	a0 += R2.L * R3.L (TFU);
	a0 += R2.L * R3.L (S2RND);
	a0 += R2.L * R3.L (ISS2);
	a0 += R2.L * R3.L (IH);
