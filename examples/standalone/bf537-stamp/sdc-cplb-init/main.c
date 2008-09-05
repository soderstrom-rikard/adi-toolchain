/* main code: just call other pieces to do our dirty work */

#include <blackfin.h>
#include <cdefBF534.h>

#include "funcs.h"

/* If we get here, something bad happened, so just try to signal the JTAG
 * ICE as hard as we can until someone notices.
 */
void hang(void)
{
	while (1)
		asm("emuexcpt;");
}

/* Setup exceptions, caches, interrupts, and then start calling a
 * function in external memory.  Let it update external memory before
 * we use the result to update data in L1.  Rinse and repeat!
 */
static int data_in_l1 = 1;
int main(void)
{
	exception_init();
	cache_init();
	interrupts_init();

	while (1) {
		asm("emuexcpt");
		data_in_l1 = func_in_external_memory(10);
	}

	hang();
}
