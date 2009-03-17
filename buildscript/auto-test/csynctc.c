
int foo (volatile int *a, volatile int *b)
{
    int x;
    for (; bar ();)
    {
	__builtin_bfin_csync ();
	baz (1, 2, 3, 4);
    }
    __builtin_bfin_csync ();

    if (__builtin_expect (bar (), 1))
	goto label;
    if (__builtin_expect (bar (), 0)) {
	__builtin_bfin_csync ();
	baz (1, 2, 4, 3);
    } else {
	__builtin_bfin_csync ();
	baz (1, 3, 4, 2);
    }

    if (__builtin_expect (bar (), 1)) {
	__builtin_bfin_csync ();
	baz (2, 1, 4, 3);
    } else {
	__builtin_bfin_csync ();
	baz (3, 1, 4, 2);
    }

    if (__builtin_expect (bar (), 0)) {
	x = *b;
	__builtin_bfin_csync ();
	baz (1, 2, 4, 3);
    } else {
	x = *a;
	__builtin_bfin_csync ();
	baz (1, 3, 4, 2);
    }

    if (__builtin_expect (bar (), 1)) {
	x = *a;
	__builtin_bfin_csync ();
	baz (2, 1, 4, 3);
    } else {
	x = *b;
	__builtin_bfin_csync ();
	baz (3, 1, 4, 2);
    }

    if (__builtin_expect (bar (), 0)) {
      label:
	__builtin_bfin_ssync ();
    }
    if (__builtin_expect (bar (), 1))
	goto label;
    return x;
}
