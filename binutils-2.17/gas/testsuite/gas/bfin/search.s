// { dg-do assemble { target bfin-*-* } }

	.text
_search:
	(r1,r0) = search r2 (le) ;
