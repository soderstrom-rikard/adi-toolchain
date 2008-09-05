/* Setup the CPLB tables and enable cache support.  Handle resulting misses. */

#include <blackfin.h>
#include <cdefBF534.h>

#include <stdint.h>
#include <stdlib.h>

#include "funcs.h"

static uint32_t get_seqstat(void)
{
	uint32_t ret;
	asm("%0 = seqstat;" : "=d"(ret));
	return ret;
}

static size_t rr_dcplb = 0;
static size_t rr_icplb = 0;

/* When a CPLB miss occurs, update the CPLB table as need be.  Note that we
 * assume the stack lives in a locked CPLB.  We can make that assumption here
 * because our application is simple.  If your supervisor stack may bounce
 * around and cannot be guaranteed to be covered by a CPLB, you must rewrite
 * this code in assembly, else you may cause a double exception -> bad!.  See
 * these pages for more information:
 * http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:nmi
 * http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:exceptions
 */
__attribute__((exception_handler))
static void exception_handler(void)
{
	uint32_t excause = (get_seqstat() & 0x3f);
	size_t i;

	/* Only handle CPLB misses ... everything else -> hang.
	 * Note that the way the MMR's for DCPLBs and ICPLBs are
	 * designed, you could glue these code bases together so
	 * you only need one handler ...
	 */
	switch (excause) {
		case 0x26: /* DCPLB miss */

			/* first try to find a CPLB that is marked as invalid */
			for (i = 0; i < 16; ++i)
				if (!(pDCPLB_DATA0[i] & 0x1))
					break;

			/* all CPLB's are valid, so evict the next unlocked round robin one */
			if (i == 16) {
				do {
					i = rr_dcplb++ % 16;
				} while (pDCPLB_DATA0[i] & 0x2);
			}

			/* find the address causing this fault and then get the 4k page
			 * that it is in as the CPLB table needs to be aligned according
			 * to the page size in the corresponding CPLB data field
			 */
			uint32_t new_dcplb_addr = (uint32_t)(*pDCPLB_FAULT_ADDR) & ~(4 * 1024 - 1);
			uint32_t new_dcplb_data =
				(1 << 16) | /* 4k page */
				(1 << 15) | /* alloc on read/write */
				(1 << 14) | /* write through mode */
				(1 <<  4) | /* allow supervisor mode write */
				(1 <<  3) | /* allow user mode write */
				(1 <<  2) | /* allow user mode read */
				(1 <<  0);  /* this CPLB is valid */

			/* do not enable caching for async memory banks */
			if (new_dcplb_addr < 0x20000000)
				new_dcplb_data |= (1 << 12);

			/* disable data CPLBs, insert the new CPLB (aligned to 4k),
			 * and then enable data CPLBs */
			*pDMEM_CONTROL &= ~(0x2);
			pDCPLB_ADDR0[i] = (void *)new_dcplb_addr;
			pDCPLB_DATA0[i] = new_dcplb_data;
			*pDMEM_CONTROL |= 0x2;
			__builtin_bfin_ssync();

			break;

		case 0x2c: /* ICPLB miss */

			/* first try to find a CPLB that is marked as invalid */
			for (i = 0; i < 16; ++i)
				if (!(pICPLB_DATA0[i] & 0x1))
					break;

			/* all CPLB's are valid, so evict the next unlocked round robin one */
			if (i == 16) {
				do {
					i = rr_icplb++ % 16;
				} while (pICPLB_DATA0[i] & 0x2);
			}

			/* find the address causing this fault and then get the 4k page
			 * that it is in as the CPLB table needs to be aligned according
			 * to the page size in the corresponding CPLB data field
			 */
			uint32_t new_icplb_addr = (uint32_t)(*pICPLB_FAULT_ADDR) & ~(4 * 1024 - 1);
			uint32_t new_icplb_data =
				(1 << 16) | /* 4k page */
				(1 <<  2) | /* allow user mode read */
				(1 <<  0);  /* this CPLB is valid */

			/* do not enable caching for async memory banks */
			if (new_icplb_addr < 0x20000000)
				new_icplb_data |= (1 << 12);

			/* disable instruction CPLBs, insert the new CPLB (aligned to 4k),
			 * and then enable instruction CPLBs */
			*pIMEM_CONTROL &= ~(0x2);
			pICPLB_ADDR0[i] = (void *)new_icplb_addr;
			pICPLB_DATA0[i] = new_icplb_data;
			*pIMEM_CONTROL |= 0x2;
			__builtin_bfin_ssync();

			break;

		default:
			hang();
	}
}

/* Set exception vector to our own handler */
void exception_init(void)
{
	*pEVT3 = exception_handler;
}

/* Setup initial CPLB tables and turn on cache/protection support */
void cache_init(void)
{
	size_t i;

	/* Make sure L1 is covered with a locked entry */
	pDCPLB_ADDR0[0] = (void *)0xFF800000;
	pDCPLB_DATA0[0] =
		(1 << 16) | /* 4k page */
		(1 << 15) | /* alloc on read/write */
		(1 << 14) | /* write through mode */
		(1 <<  4) | /* allow supervisor mode write */
		(1 <<  3) | /* allow user mode write */
		(1 <<  2) | /* allow user mode read */
		(1 <<  1) | /* keep this locked in */
		(1 <<  0);  /* this CPLB is valid */
	pICPLB_ADDR0[0] = (void *)0xFFA00000;
	pICPLB_DATA0[0] =
		(1 << 16) | /* 4k page */
		(1 <<  2) | /* allow user mode read */
		(1 <<  1) | /* keep this locked in */
		(1 <<  0);  /* this CPLB is valid */

	/* Mark remaining CPLB entries as invalid -- entries will get
	 * populated by the CPLB miss handler in the exception handler.
	 */
	for (i = 1; i < 16; ++i) {
		pICPLB_DATA0[i] = 0;
		pDCPLB_DATA0[i] = 0;
	}

	/* Now turn on I and D cache and CPLB checking */
	*pIMEM_CONTROL = 0x4 | 0x2; /* IMC | ENICPLB */
	*pDMEM_CONTROL = 0x1000 | 0xC | 0x2; /* ~PORT_PREF1 | PORT_PREF0 | DMC | ENDCPLB */
}
