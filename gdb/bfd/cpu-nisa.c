/*
 * BFD support for the Analog Device's NISA architecture.
 * Copyright (c) 2000, 2001 Analog Devices Inc.,
 * Copyright (c) 2000, 2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Ported for Blackfin Architecture by 
 *             Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *            Tony Kou       <tony.ko@arcturusnetworks.com>
 */


#include "bfd.h"
#include "sysdep.h"
#include "libbfd.h"

const bfd_arch_info_type bfd_nisa_arch =
  {
    16,     		/* bits in a word */
    32,  		/* bits in an address */
    8,     		/* bits in a byte */
    bfd_arch_nisa,
    0,                	/* only 1 machine */
    "nisa",        	/* arch name */
    "nisa",        	/* arch printable name */
    4,                	/* section align power */
    TRUE,             	/* the one and only */
    bfd_default_compatible, 
    bfd_default_scan ,
    0,
  };
