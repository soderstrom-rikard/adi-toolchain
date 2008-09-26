// { dg-do assemble { target bfin-*-* } }
// { dg-options "--mcpu=bf579" }

	.text
_search:
	(r1,r0) = search r2 (le) ;
	( R6 , R5 ) = SEARCH ( R4 , R3 ) ( LT );
