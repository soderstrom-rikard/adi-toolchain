/* Blackfin External Bus Interface Unit (EBIU) SDRAM Controller (SDC) Model.

   Copyright (C) 2010 Free Software Foundation, Inc.
   Contributed by Analog Devices, Inc.

   This file is part of simulators.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

#ifndef DV_BFIN_EBIU_SDC_H
#define DV_BFIN_EBIU_SDC_H

#define BFIN_COREMMR_EBIU_SDC_BASE	0xFFC00A10
#define BFIN_COREMMR_EBIU_SDC_SIZE	(4 * 4)

/* EBIU_SDBCTL Masks */
#define EBE			0x0001		/* Enable SDRAM External Bank */
#define EBSZ_16		0x0000		/* SDRAM External Bank Size = 16MB */
#define EBSZ_32		0x0002		/* SDRAM External Bank Size = 32MB */
#define EBSZ_64		0x0004		/* SDRAM External Bank Size = 64MB */
#define EBSZ_128	0x0006		/* SDRAM External Bank Size = 128MB */
#define EBSZ_256	0x0008		/* SDRAM External Bank Size = 256MB */
#define EBSZ_512	0x000A		/* SDRAM External Bank Size = 512MB */
#define EBCAW_8		0x0000		/* SDRAM External Bank Column Address Width = 8 Bits */
#define EBCAW_9		0x0010		/* SDRAM External Bank Column Address Width = 9 Bits */
#define EBCAW_10	0x0020		/* SDRAM External Bank Column Address Width = 10 Bits */
#define EBCAW_11	0x0030		/* SDRAM External Bank Column Address Width = 11 Bits */

#endif
