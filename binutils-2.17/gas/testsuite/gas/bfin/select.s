// { dg-do assemble { target bfin-*-* } }
// { dg-options "--mcpu=bf579" }

	.text
_select:
	(R1,R3) = SEARCH R2 (LT);
	(R0,R2) = SELECT (R1,R3) (LT);
	(R1,R3) = SEARCH (R2,R4) (GE);
	(R0,R2) = SELECT (R1,R3) (GE);
