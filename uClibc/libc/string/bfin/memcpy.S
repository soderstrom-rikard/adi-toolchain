/* memcpy.S
 * Copyright (C) 2003-2007 Analog Devices Inc., All Rights Reserved.
 *
 * This file is subject to the terms and conditions of the GNU Library General
 * Public License. See the file "COPYING.LIB" in the main directory of this
 * archive for more details.
 *
 * Non-LGPL License also available as part of VisualDSP++
 * http://www.analog.com/processors/resources/crosscore/visualDspDevSoftware.html
 */

#include <sysdep.h>

/* void *memcpy(void *dest, const void *src, size_t n);
 * R0 = To Address (dest) (leave unchanged to form result)
 * R1 = From Address (src)
 * R2 = count
 *
 * Note: Favours word alignment
 */

.text

.align 2

/* We have to bypass the libc-symbols.h machinery to make sure we get
 * a weak symbol for memcpy (some crummy gcc tests want to redefine it).
 */
.global ___GI_memcpy
.type ___GI_memcpy, STT_FUNC
___GI_memcpy:
	CC = R2 <=  0;	/* length not positive? */
	IF CC JUMP .L_P1L2147483647;	/* Nothing to do */

	P0 = R0 ;	/* dst*/
	P1 = R1 ;	/* src*/
	P2 = R2 ;	/* length */

	/* check for overlapping data */
	CC = R1 < R0;	/* src < dst */
	IF !CC JUMP .Lno_overlap;
	R3 = R1 + R2;
	CC = R0 < R3;	/* and dst < src+len */
	IF CC JUMP .Lhas_overlap;

.Lno_overlap:
	/* Check for aligned data.*/

	R3 = R1 | R0;
	R0 = 0x3;
	R3 = R3 & R0;
	CC = R3;	/* low bits set on either address? */
	IF CC JUMP .Lnot_aligned;

	/* Both addresses are word-aligned, so we can copy
	at least part of the data using word copies.*/
	P2 = P2 >> 2;
	CC = P2 <= 2;
	IF !CC JUMP .Lmore_than_seven;
	/* less than eight bytes... */
	P2 = R2;
	LSETUP(.Lthree_start, .Lthree_end) LC0=P2;
	R0 = R1;	/* setup src address for return */
.Lthree_start:
	R3 = B[P1++] (X);
.Lthree_end:
	B[P0++] = R3;

	RTS;

.Lmore_than_seven:
	/* There's at least eight bytes to copy. */
	P2 += -1;	/* because we unroll one iteration */
	LSETUP(.Lword_loop, .Lword_loop) LC0=P2;
	R0 = R1;
	I1 = P1;
	R3 = [I1++];
.Lword_loop:
	MNOP || [P0++] = R3 || R3 = [I1++];

	[P0++] = R3;
	/* Any remaining bytes to copy? */
	R3 = 0x3;
	R3 = R2 & R3;
	CC = R3 == 0;
	P1 = I1;	/* in case there's something left, */
	IF !CC JUMP .Lbytes_left;
	RTS;
.Lbytes_left:	P2 = R3;
.Lnot_aligned:
	/* From here, we're copying byte-by-byte. */
	LSETUP (.Lbyte_start, .Lbyte_end) LC0=P2;
	R0 = R1;	/* Save src address for return */
.Lbyte_start:
	R1 = B[P1++] (X);
.Lbyte_end:
	B[P0++] = R1;

.L_P1L2147483647:
	RTS;

.Lhas_overlap:
	/* Need to reverse the copying, because the
	 * dst would clobber the src.
	 * Don't bother to work out alignment for
	 * the reverse case.
	 */
	R0 = R1;	/* save src for later. */
	P0 = P0 + P2;
	P0 += -1;
	P1 = P1 + P2;
	P1 += -1;
	LSETUP(.Lover_start, .Lover_end) LC0=P2;
.Lover_start:
	R1 = B[P1--] (X);
.Lover_end:
	B[P0--] = R1;

	RTS;
.size ___GI_memcpy,.-___GI_memcpy

.hidden ___GI_memcpy
.weak _memcpy
.set _memcpy,___GI_memcpy
