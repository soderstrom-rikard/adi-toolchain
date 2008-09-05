/* We don't actually handle hardware errors, but we should abort when
 * they occur ...
 */

#include <blackfin.h>
#include <cdefBF534.h>

#include "funcs.h"

__attribute__((interrupt_handler))
static void hardware_error_handler(void)
{
	hang();
}

void interrupts_init(void)
{
	*pEVT5 = hardware_error_handler;
	asm("sti %0;" : : "d"(0x3f));
}
