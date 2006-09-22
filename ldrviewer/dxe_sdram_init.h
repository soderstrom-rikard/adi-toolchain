/*
 * File:         dxe_sdram_init.h
 * Author:       Mike Frysinger <michael.frysinger@analog.com>
 *
 * Description:  Binary code for initializing SDRAM.
 * References:   See 6-56 in BF537 HRM for details.
 *               The EE-210 doc is helpful as well.
 *
 * Rev:          $Id$
 *
 * Modified:     Copyright 2006 Analog Devices Inc.
 *
 * Bugs:         Enter bugs at http://blackfin.uclinux.org/
 *
 * Licensed under the GPL-2, see the file COPYING in this dir
 */

#ifndef __DXE_SDRAM_INIT__
#define __DXE_SDRAM_INIT__

#include "blackfin_defines.h"

/* for debugging purposes:
 * $ bfin-uclinux-gcc -x assembler-with-cpp -c dxe_sdram_init.h -o dxe_sdram_init.o
 * $ bfin-uclinux-objdump -d dxe_sdram_init.o
 * $ bfin-uclinux-objcopy -I elf32-bfin -O binary dxe_sdram_init.o dxe_sdram_init.bin
 *
 * $ bfin-uclinux-gcc -x assembler-with-cpp -S -o - dxe_sdram_init.h
 */
# ifdef __ASSEMBLER__

/*
 * 1. Ensure the clock to the SDRAM is stable after the power has stabi-
 *    lized for the proper amount of time (typically 100 us).
 *
 * The SDRS bit of the SDRAM control status register can be checked to
 * determine the current state of the SDC. If this bit is set, the SDRAM
 * powerup sequence has not been initiated.
 */

	P0.L = LO(EBIU_SDSTAT);
	P0.H = HI(EBIU_SDSTAT);
.Lcheck_again:
	R0 = [P0];
	cc = BITTST(R0, SDRS_BITPOS);
	if cc jump .Lcheck_again;

/*
 * 2. Write to the SDRAM refresh rate control register (EBIU_SDRRC).
 */

	P1.L = LO(EBIU_SDRRC);
	P1.H = HI(EBIU_SDRRC);
	R1.L = mem_SDRRC;
	W[P1] = R1.L;

/*
 * 3. Write to the SDRAM memory bank control register (EBIU_SDBCTL).
 */

	P2.L = LO(EBIU_SDBCTL);
	P2.H = HI(EBIU_SDBCTL);
	R2.L = mem_SDBCTL;
	W[P2] = R2.L;

/*
 * 4. Write to and SDRAM memory global control register (EBIU_SDGCTL).
 */

	P3.L = LO(EBIU_SDGCTL);
	P3.H = HI(EBIU_SDGCTL);
	R3.L = LO(mem_SDGCTL);
	R3.H = HI(mem_SDGCTL);
	[P3] = R3;

/*
 * 5. Perform SDRAM access.
 */

	SSYNC;

/*
 * 6. Return to boot rom.
 */

	RTS;

# else

#define DXE_SDRAM_INIT_CODE_SIZE 64
static inline uint8_t *dxe_sdram_init_code(const uint16_t sdrrc, const uint16_t sdbctl, const uint32_t sdgctl)
{
	static uint8_t sdram_init_buf[DXE_SDRAM_INIT_CODE_SIZE] = {
		/* step 1 */
		[ 0] 0x08, [ 1] 0xE1, [ 2] 0xFF, [ 3] 0xFF,   /* P0.L = LO(EBIU_SDSTAT);        */
		[ 4] 0x48, [ 5] 0xE1, [ 6] 0xFF, [ 7] 0xFF,   /* P0.L = HI(EBIU_SDSTAT);        */
		[ 8] 0x00, [ 9] 0x91,                         /* .Lcheck_again: R0 = [P0];      */
		[10] 0x18, [11] 0x49,                         /* cc = BITTST(R0, SDRS_BITPOS);  */
		[12] 0xFE, [13] 0x1B,                         /* if cc jump .Lcheck_again;      */

		/* step 2 */
		[14] 0x09, [15] 0xE1, [16] 0xFF, [17] 0xFF,   /* P1.L = LO(EBIU_SDRRC);         */
		[18] 0x49, [19] 0xE1, [20] 0xFF, [21] 0xFF,   /* P1.H = HI(EBIU_SDRRC);         */
		[22] 0x01, [23] 0xE1, [24] 0x06, [25] 0x03,   /* R1.L = mem_SDRRC;              */
		[26] 0x49, [27] 0x8A,                         /* W[P1] = R1.L;                  */

		/* step 3 */
		[28] 0x0A, [29] 0xE1, [30] 0xFF, [31] 0xFF,   /* P2.L = LO(EBIU_SDBCTL);        */
		[32] 0x4A, [33] 0xE1, [34] 0xFF, [35] 0xFF,   /* P2.H = HI(EBIU_SDBCTL);        */
		[36] 0x02, [37] 0xE1, [38] 0xFF, [39] 0xFF,   /* R2.L = mem_SDBCTL;             */
		[40] 0x92, [41] 0x8A,                         /* W[P2] = R2.L;                  */

		/* step 4 */
		[42] 0x0B, [43] 0xE1, [44] 0xFF, [45] 0xFF,   /* P3.L = LO(EBIU_SDGCTL);        */
		[46] 0x4B, [47] 0xE1, [48] 0xFF, [49] 0xFF,   /* P3.H = HI(EBIU_SDGCTL);        */
		[50] 0x03, [51] 0xE1, [52] 0xFF, [53] 0xFF,   /* R3.L = LO(mem_SDGCTL);         */
		[54] 0x43, [55] 0xE1, [56] 0xFF, [57] 0xFF,   /* R3.H = HI(mem_SDGCTL);         */
		[58] 0x1B, [59] 0x93,                         /* [P3] = R3;                     */

		/* step 5 */
		[60] 0x24, [61] 0x00,                         /* SSYNC;                         */

		/* step 6 */
		[62] 0x10, [63] 0x00                          /* RTS;                           */
	};

	FILL_ADDR_32(sdram_init_buf, EBIU_SDSTAT, 2, 3, 6, 7);
	FILL_ADDR_32(sdram_init_buf, EBIU_SDRRC, 16, 17, 20, 21);
	FILL_ADDR_16(sdram_init_buf, sdrrc, 24, 25);
	FILL_ADDR_32(sdram_init_buf, EBIU_SDBCTL, 30, 31, 34, 35);
	FILL_ADDR_16(sdram_init_buf, sdbctl, 38, 39);
	FILL_ADDR_32(sdram_init_buf, EBIU_SDGCTL, 44, 45, 48, 49);
	FILL_ADDR_32(sdram_init_buf, sdgctl, 52, 53, 56, 57);

	return sdram_init_buf;
}

# endif

#endif
