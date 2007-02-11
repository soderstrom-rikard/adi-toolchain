/*
 * defBF566.h
 *
 * Copyright (C) 2007 Analog Devices, Inc.
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */

#ifndef _DEFBF566_H
#define _DEFBF566_H

#include <sys/XML_defBF566.h>

/* legacy names from def_LPBlackfin.h */
#define SRAM_BASE_ADDRESS 0xFFE00000 /* alternate name for SRAM_BASE_ADDR */
#define DCPLB_FAULT_STATUS     0xFFE00008  /* alternate name for DCPLB_STATUS */
#define CODE_FAULT_STATUS      0xFFE01008  /* alternate name for ICPLB_STATUS */
#define CODE_FAULT_ADDR        0xFFE0100C  /* alternate name for ICPLB_FAULT_ADDR */

/* bit definitions from def_LPBlackfin.h */

#define MK_BMSK_( x ) (1<<x)    /* Make a bit mask from a bit position */

/*********************************************************************************** */
/* System Register Bits */
/*********************************************************************************** */

/*************************************************** */
/*   ASTAT register */
/*************************************************** */

/* definitions of ASTAT bit positions */
#define ASTAT_AZ_P         0x00000000                  /* Result of last ALU0 or shifter operation is zero */
#define ASTAT_AN_P         0x00000001                  /* Result of last ALU0 or shifter operation is negative */
#define ASTAT_CC_P         0x00000005                  /* Condition Code, used for holding comparison results */
#define ASTAT_AQ_P         0x00000006                  /* Quotient Bit */
#define ASTAT_RND_MOD_P    0x00000008                  /* Rounding mode, set for biased, clear for unbiased */
#define ASTAT_AC0_P        0x0000000C                  /* Result of last ALU0 operation generated a carry */
#define ASTAT_AC0_COPY_P   0x00000002                  /* Result of last ALU0 operation generated a carry */
#define ASTAT_AC1_P        0x0000000D                  /* Result of last ALU1 operation generated a carry */
#define ASTAT_AV0_P        0x00000010                  /* Result of last ALU0 or MAC0 operation overflowed, sticky for MAC */
#define ASTAT_AV0S_P       0x00000011                  /* Sticky version of ASTAT_AV0  */
#define ASTAT_AV1_P        0x00000012                  /* Result of last MAC1 operation overflowed, sticky for MAC */
#define ASTAT_AV1S_P       0x00000013                  /* Sticky version of ASTAT_AV1  */
#define ASTAT_V_P          0x00000018		       /* Result of last ALU0 or MAC0 operation overflowed */
#define ASTAT_V_COPY_P     0x00000003                  /* Result of last ALU0 or MAC0 operation overflowed */
#define ASTAT_VS_P         0x00000019		       /* Sticky version of ASTAT_V */

/* ** Masks */
#define ASTAT_AZ           MK_BMSK_(ASTAT_AZ_P)        /* Result of last ALU0 or shifter operation is zero */
#define ASTAT_AN           MK_BMSK_(ASTAT_AN_P)        /* Result of last ALU0 or shifter operation is negative */
#define ASTAT_AC0          MK_BMSK_(ASTAT_AC0_P)       /* Result of last ALU0 operation generated a carry */
#define ASTAT_AC0_COPY     MK_BMSK_(ASTAT_AC0_COPY_P)  /* Result of last ALU0 operation generated a carry */
#define ASTAT_AC1          MK_BMSK_(ASTAT_AC1_P)       /* Result of last ALU0 operation generated a carry */
#define ASTAT_AV0          MK_BMSK_(ASTAT_AV0_P)       /* Result of last ALU0 or MAC0 operation overflowed, sticky for MAC */
#define ASTAT_AV1          MK_BMSK_(ASTAT_AV1_P)       /* Result of last MAC1 operation overflowed, sticky for MAC */
#define ASTAT_CC           MK_BMSK_(ASTAT_CC_P)        /* Condition Code, used for holding comparison results */
#define ASTAT_AQ           MK_BMSK_(ASTAT_AQ_P)        /* Quotient Bit */
#define ASTAT_RND_MOD      MK_BMSK_(ASTAT_RND_MOD_P)   /* Rounding mode, set for biased, clear for unbiased */
#define ASTAT_V            MK_BMSK_(ASTAT_V_P)         /* Overflow Bit */
#define ASTAT_V_COPY       MK_BMSK_(ASTAT_V_COPY_P)    /* Overflow Bit */

/*************************************************** */
/*   SEQSTAT register */
/*************************************************** */

/* ** Bit Positions */
#define SEQSTAT_EXCAUSE0_P      0x00000000     /* Last exception cause bit 0 */
#define SEQSTAT_EXCAUSE1_P      0x00000001  /* Last exception cause bit 1 */
#define SEQSTAT_EXCAUSE2_P      0x00000002  /* Last exception cause bit 2 */
#define SEQSTAT_EXCAUSE3_P      0x00000003  /* Last exception cause bit 3 */
#define SEQSTAT_EXCAUSE4_P      0x00000004  /* Last exception cause bit 4 */
#define SEQSTAT_EXCAUSE5_P      0x00000005  /* Last exception cause bit 5 */
#define SEQSTAT_IDLE_REQ_P      0x0000000C  /* Pending idle mode request, set by IDLE instruction */
#define SEQSTAT_SFTRESET_P      0x0000000D  /* Indicates whether the last reset was a software reset (=1) */
#define SEQSTAT_HWERRCAUSE0_P   0x0000000E  /* Last hw error cause bit 0 */
#define SEQSTAT_HWERRCAUSE1_P   0x0000000F  /* Last hw error cause bit 1 */
#define SEQSTAT_HWERRCAUSE2_P   0x00000010  /* Last hw error cause bit 2 */
#define SEQSTAT_HWERRCAUSE3_P   0x00000011  /* Last hw error cause bit 3 */
#define SEQSTAT_HWERRCAUSE4_P   0x00000012  /* Last hw error cause bit 4 */
#define SEQSTAT_HWERRCAUSE5_P   0x00000013  /* Last hw error cause bit 5 */
#define SEQSTAT_HWERRCAUSE6_P   0x00000014  /* Last hw error cause bit 6 */
#define SEQSTAT_HWERRCAUSE7_P   0x00000015  /* Last hw error cause bit 7 */
/* ** Masks */
/* Exception cause */
#define SEQSTAT_EXCAUSE        MK_BMSK_(SEQSTAT_EXCAUSE0_P ) | \
                               MK_BMSK_(SEQSTAT_EXCAUSE1_P ) | \
                               MK_BMSK_(SEQSTAT_EXCAUSE2_P ) | \
                               MK_BMSK_(SEQSTAT_EXCAUSE3_P ) | \
                               MK_BMSK_(SEQSTAT_EXCAUSE4_P ) | \
                               MK_BMSK_(SEQSTAT_EXCAUSE5_P ) | \
                               0

/* Indicates whether the last reset was a software reset (=1) */
#define SEQSTAT_SFTRESET       MK_BMSK_(SEQSTAT_SFTRESET_P )

/* Last hw error cause */
#define SEQSTAT_HWERRCAUSE     MK_BMSK_(SEQSTAT_HWERRCAUSE0_P ) | \
                               MK_BMSK_(SEQSTAT_HWERRCAUSE1_P ) | \
                               MK_BMSK_(SEQSTAT_HWERRCAUSE2_P ) | \
                               MK_BMSK_(SEQSTAT_HWERRCAUSE3_P ) | \
                               MK_BMSK_(SEQSTAT_HWERRCAUSE4_P ) | \
                               0

/*************************************************** */
/*   SYSCFG register */
/*************************************************** */

/* ** Bit Positions */
#define SYSCFG_SSSTEP_P         0x00000000              /* Supervisor single step, when set it forces an exception for each instruction executed */
#define SYSCFG_CCEN_P           0x00000001              /* Enable cycle counter (=1) */
#define SYSCFG_SNEN_P           0x00000002              /* Self nesting Interrupt Enable */

/* ** Masks */
#define SYSCFG_SSSTEP         MK_BMSK_(SYSCFG_SSSTEP_P )   /* Supervisor single step, when set it forces an exception for each instruction executed */
#define SYSCFG_CCEN           MK_BMSK_(SYSCFG_CCEN_P )     /* Enable cycle counter (=1) */
#define SYSCFG_SNEN	       MK_BMSK_(SYSCFG_SNEN_P)      /* Self Nesting Interrupt Enable */
/* Backward-compatibility for typos in prior releases */
#define SYSCFG_SSSSTEP         SYSCFG_SSSTEP
#define SYSCFG_CCCEN           SYSCFG_CCEN

/*********************************************************************************** */
/* Core MMR Register Bits */
/*********************************************************************************** */

/*************************************************** */
/*   EVT registers (ILAT, IMASK, and IPEND). */
/*************************************************** */

/* ** Bit Positions */
#define EVT_EMU_P            0x00000000  /* Emulator interrupt bit position */
#define EVT_RST_P            0x00000001  /* Reset interrupt bit position */
#define EVT_NMI_P            0x00000002  /* Non Maskable interrupt bit position */
#define EVT_EVX_P            0x00000003  /* Exception bit position */
#define EVT_IRPTEN_P         0x00000004  /* Global interrupt enable bit position */
#define EVT_IVHW_P           0x00000005  /* Hardware Error interrupt bit position */
#define EVT_IVTMR_P          0x00000006  /* Timer interrupt bit position */
#define EVT_IVG7_P           0x00000007  /* IVG7 interrupt bit position */
#define EVT_IVG8_P           0x00000008  /* IVG8 interrupt bit position */
#define EVT_IVG9_P           0x00000009  /* IVG9 interrupt bit position */
#define EVT_IVG10_P          0x0000000a  /* IVG10 interrupt bit position */
#define EVT_IVG11_P          0x0000000b  /* IVG11 interrupt bit position */
#define EVT_IVG12_P          0x0000000c  /* IVG12 interrupt bit position */
#define EVT_IVG13_P          0x0000000d  /* IVG13 interrupt bit position */
#define EVT_IVG14_P          0x0000000e  /* IVG14 interrupt bit position */
#define EVT_IVG15_P          0x0000000f  /* IVG15 interrupt bit position */

/* ** Masks */
#define EVT_EMU              MK_BMSK_(EVT_EMU_P   ) /* Emulator interrupt mask */
#define EVT_RST              MK_BMSK_(EVT_RST_P   ) /* Reset interrupt mask */
#define EVT_NMI              MK_BMSK_(EVT_NMI_P   ) /* Non Maskable interrupt mask */
#define EVT_EVX              MK_BMSK_(EVT_EVX_P   ) /* Exception mask */
#define EVT_IRPTEN           MK_BMSK_(EVT_IRPTEN_P) /* Global interrupt enable mask */
#define EVT_IVHW             MK_BMSK_(EVT_IVHW_P  ) /* Hardware Error interrupt mask */
#define EVT_IVTMR            MK_BMSK_(EVT_IVTMR_P ) /* Timer interrupt mask */
#define EVT_IVG7             MK_BMSK_(EVT_IVG7_P  ) /* IVG7 interrupt mask */
#define EVT_IVG8             MK_BMSK_(EVT_IVG8_P  ) /* IVG8 interrupt mask */
#define EVT_IVG9             MK_BMSK_(EVT_IVG9_P  ) /* IVG9 interrupt mask */
#define EVT_IVG10            MK_BMSK_(EVT_IVG10_P ) /* IVG10 interrupt mask */
#define EVT_IVG11            MK_BMSK_(EVT_IVG11_P ) /* IVG11 interrupt mask */
#define EVT_IVG12            MK_BMSK_(EVT_IVG12_P ) /* IVG12 interrupt mask */
#define EVT_IVG13            MK_BMSK_(EVT_IVG13_P ) /* IVG13 interrupt mask */
#define EVT_IVG14            MK_BMSK_(EVT_IVG14_P ) /* IVG14 interrupt mask */
#define EVT_IVG15            MK_BMSK_(EVT_IVG15_P ) /* IVG15 interrupt mask */

/*************************************************** */
/*   DMEM_CONTROL Register */
/*************************************************** */
/* ** Bit Positions */
#define ENDM_P						 0x00			/* (doesn't really exist) Enable Data Memory L1 */
#define DMCTL_ENDM_P				 ENDM_P		/* "" (older define) */

#define ENDCPLB_P					 0x01			/* Enable DCPLBS */
#define DMCTL_ENDCPLB_P			 ENDCPLB_P  /* "" (older define) */
#define DMC0_P						 0x02			/* L1 Data Memory Configure bit 0 */
#define DMCTL_DMC0_P				 DMC0_P		/* "" (older define) */
#define DMC1_P						 0x03			/* L1 Data Memory Configure bit 1 */
#define DMCTL_DMC1_P				 DMC1_P		/* "" (older define) */
#define DCBS_P						 0x04			/* L1 Data Cache Bank Select */
#define PORT_PREF0_P				 0x12			/* DAG0 Port Preference */
#define PORT_PREF1_P				 0x13			/* DAG1 Port Preference */

/* ** Masks */
#define ENDM                   0x00000001   /* (doesn't really exist) Enable Data Memory L1 */
#define ENDCPLB                0x00000002   /* Enable DCPLB */
#define ASRAM_BSRAM            0x00000000	
#define ACACHE_BSRAM           0x00000008
#define ACACHE_BCACHE          0x0000000C  
#define DCBS                   0x00000010   /*  L1 Data Cache Bank Select */
#define PORT_PREF0			   0x00001000   /* DAG0 Port Preference */
#define PORT_PREF1			   0x00002000   /* DAG1 Port Preference */

/* IMEM_CONTROL Register */
/* ** Bit Positions ** */
#define ENIM_P						 0x00  /* Enable L1 Code Memory  */
#define IMCTL_ENIM_P                 0x00  /* "" (older define) */
#define ENICPLB_P					 0x01  /* Enable ICPLB */
#define IMCTL_ENICPLB_P				 0x01  /* "" (older define) */
#define IMC_P						 0x02  /* Enable  */
#define IMCTL_IMC_P					 0x02  /* Configure L1 code memory as cache (0=SRAM) */
#define ILOC0_P						 0x03  /* Lock Way 0 */
#define ILOC1_P						 0x04  /* Lock Way 1 */
#define ILOC2_P						 0x05  /* Lock Way 2 */
#define ILOC3_P						 0x06  /* Lock Way 3 */
#define LRUPRIORST_P				 0x0D  /* Least Recently Used Replacement Priority */
/* ** Masks */
#define ENIM                   0x00000001  /* Enable L1 Code Memory */
#define ENICPLB                0x00000002  /* Enable ICPLB */
#define IMC                    0x00000004  /* Configure L1 code memory as cache (0=SRAM) */
#define ILOC0				   0x00000008  /* Lock Way 0 */
#define ILOC1				   0x00000010  /* Lock Way 1 */
#define ILOC2				   0x00000020  /* Lock Way 2 */
#define ILOC3				   0x00000040  /* Lock Way 3 */
#define LRUPRIORST			   0x00002000  /* Least Recently Used Replacement Priority */

/* TCNTL Masks */
#define TMPWR                  0x00000001  /* Timer Low Power Control, 0=low power mode, 1=active state */
#define TMREN                  0x00000002  /* Timer enable, 0=disable, 1=enable */
#define TAUTORLD               0x00000004  /* Timer auto reload */
#define TINT                   0x00000008  /* Timer generated interrupt 0=no interrupt has been generated, 1=interrupt has been generated (sticky) */

/* TCNTL Bit Positions */
#define TMPWR_P                 0x00000000  /* Timer Low Power Control, 0=low power mode, 1=active state */
#define TMREN_P                 0x00000001  /* Timer enable, 0=disable, 1=enable */
#define TAUTORLD_P              0x00000002  /* Timer auto reload */
#define TINT_P                  0x00000003  /* Timer generated interrupt 0=no interrupt has been generated, 1=interrupt has been generated (sticky) */

/* DCPLB_DATA and ICPLB_DATA Registers */
/*** Masks */
#define CPLB_VALID             0x00000001  /* 0=invalid entry, 1=valid entry */
#define CPLB_LOCK              0x00000002  /* 0=entry may be replaced, 1=entry locked */
#define CPLB_USER_RD           0x00000004  /* 0=no read access, 1=read access allowed (user mode) */
#define CPLB_USER_WR           0x00000008  /* 0=no write access, 0=write access allowed (user mode) */
#define CPLB_SUPV_WR           0x00000010  /* 0=no write access, 0=write access allowed (supervisor mode) */
#define CPLB_L1SRAM            0x00000020  /* 1=SRAM mapped in L1, 0=SRAM not mapped to L1 */
#define CPLB_DA0ACC            0x00000040  /* 0=access allowed from either DAG, 1=access from DAG0 only */
#define CPLB_DIRTY             0x00000080  /* 1=dirty, 0=clean */
#define CPLB_L1_CHBL           0x00001000  /* 0=non-cacheable in L1, 1=cacheable in L1 */
#define CPLB_WT                0x00004000  /* 0=write-back, 1=write-through */

#define PAGE_SIZE_1KB          0x00000000  /* 1 KB page size */
#define PAGE_SIZE_4KB          0x00010000  /* 4 KB page size */
#define PAGE_SIZE_1MB          0x00020000  /* 1 MB page size */
#define PAGE_SIZE_4MB          0x00030000  /* 4 MB page size */

#define CPLB_PORTPRIO          0x00000200  /* 0=low priority port, 1= high priority port */
#define CPLB_LRUPRIO           0x00000100  /* 0=can be replaced by any line, 1=priority for non-replacement */
#define CPLB_L1_AOW            0x00008000  /* 0=do not allocate cache lines on write-through writes, 1= allocate cache lines on write-through writes. */

/*** Bit Positions */
#define CPLB_VALID_P           0x00000000  /* 0=invalid entry, 1=valid entry */
#define CPLB_LOCK_P            0x00000001  /* 0=entry may be replaced, 1=entry locked */
#define CPLB_USER_RD_P         0x00000002  /* 0=no read access, 1=read access allowed (user mode) */


/* ITEST_COMMAND and DTEST_COMMAND Registers */
/*** Masks */
#define TEST_READ			   0x00000000  /* Read Access */
#define TEST_WRITE			   0x00000002  /* Write Access */
#define TEST_TAG			   0x00000000  /* Access TAG */
#define TEST_DATA			   0x00000004  /* Access DATA */
#define TEST_DW0			   0x00000000  /* Select Double Word 0 */
#define TEST_DW1			   0x00000008  /* Select Double Word 1 */
#define TEST_DW2			   0x00000010  /* Select Double Word 2 */
#define TEST_DW3			   0x00000018  /* Select Double Word 3 */
#define TEST_MB0			   0x00000000  /* Select Mini-Bank 0 */
#define TEST_MB1			   0x00010000  /* Select Mini-Bank 1 */
#define TEST_MB2			   0x00020000  /* Select Mini-Bank 2 */
#define TEST_MB3			   0x00030000  /* Select Mini-Bank 3 */
#define TEST_SET(x)		       ((x << 5) & 0x03E0)  /* Set Index 0->31 */
#define TEST_WAY0			   0x00000000  /* Access Way0 */
#define TEST_WAY1			   0x04000000  /* Access Way1 */
/*** ITEST_COMMAND only */
#define TEST_WAY2			   0x08000000  /* Access Way2 */
#define TEST_WAY3			   0x0C000000  /* Access Way3 */
/*** DTEST_COMMAND only */
#define TEST_BNKSELA		   0x00000000  /* Access SuperBank A */
#define TEST_BNKSELB		   0x00800000  /* Access SuperBank B */

/* **********  DMA CONTROLLER MASKS  *********************8 */

/*//DMAx_CONFIG, MDMA_yy_CONFIG Masks */
#define DMAEN	        0x00000001  /* Channel Enable */
#define WNR	   	0x00000002  /* Channel Direction (W/R*) */
#define WDSIZE_8	0x00000000  /* Word Size 8 bits */
#define WDSIZE_16	0x00000004  /* Word Size 16 bits */
#define WDSIZE_32	0x00000008  /* Word Size 32 bits */
#define DMA2D	        0x00000010  /* 2D/1D* Mode */
#define RESTART         0x00000020  /* Restart */
#define DI_SEL	        0x00000040  /* Data Interrupt Select */
#define DI_EN	        0x00000080  /* Data Interrupt Enable */
#define NDSIZE	        0x00000900  /* Next Descriptor Size */
#define FLOW	        0x00007000  /* Flow Control */


#define DMAEN_P	            	0  /* Channel Enable */
#define WNR_P	            	1  /* Channel Direction (W/R*) */
#define DMA2D_P	        	4  /* 2D/1D* Mode */
#define RESTART_P	      	5  /* Restart */
#define DI_SEL_P	     	6  /* Data Interrupt Select */
#define DI_EN_P	            	7  /* Data Interrupt Enable */

#endif /* _DEFBF566_H */
