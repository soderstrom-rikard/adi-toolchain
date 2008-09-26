// { dg-do assemble { target bfin-*-* } }
// { dg-options "--mcpu=bf579" }

	.text
_csqu:
	R1.L = CSQU(R0);
	R1.H = CSQU(R0);
	R1.L = CSQU(R0) (T);
	R1 = CSQU(R0);
	A0 = CSQU(R0);
	A0 += CSQU(R0);
	A0 += CSQU(R0) (IS);
	R1 = (A1 = CSQU(R0));
	R0 = (A0 -= CSQU(R1));
	R1.L = (A0 += CSQU(R0)) (T);

