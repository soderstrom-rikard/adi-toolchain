#include "test.h"


        /* Evaluate given a signed integer dividend and divisor */

        r0 <<= 1;       /* Left shift dividend by 1 needed for integer division */
        p0 = 15;        /* Evaluate the quotient to 16 bits. */
        divs (r0, r1);  /* Evaluate quotient MSB. Initialize AQ status bit and dividend for the DIVQ loop. */

        loop .Lfoo lc0=p0;      /* Evaluate DIVQ p0=15 times. */
loop_begin .Lfoo;
        divq (r0, r1);
loop_end .Lfoo;
        r0 = r0.l (x);          /* Sign extend the 16-bit quotient to 32bits.  */
                                /* r0 contains the quotient (70/5 = 14)        */
