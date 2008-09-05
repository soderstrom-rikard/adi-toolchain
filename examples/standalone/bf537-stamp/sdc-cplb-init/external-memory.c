/* Everything in this file will be placed into external memory by the
 * custom linker script.
 */

#include <blackfin.h>
#include <cdefBF534.h>

int data_in_external_memory = 15;

int func_in_external_memory(int arg)
{
#if 1
	data_in_external_memory += arg;
	return data_in_external_memory;
#else
	/* if you feel like implementing stdio primitives ... */
	printf("executing function %s\n", __func__);
	printf("  it's address is %p\n", func_in_external_memory);
	printf("  it was passed a value of %i\n", arg);

	printf("external data is at address %p\n", &data_in_external_memory);
	printf("  it had a value of %i\n", data_in_external_memory);

	data_in_external_memory += arg;
	printf("  it now has a value of %i\n", data_in_external_memory);

	return data_in_external_memory;
#endif
}
