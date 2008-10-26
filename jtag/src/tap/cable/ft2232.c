/*
 * $Id: ft2232.c 1101 2008-02-26 22:31:07Z arniml $
 *
 * Generic cable driver for FTDI's FT2232C chip in MPSSE mode.
 * Copyright (C) 2007 A. Laeuger
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Written by Arnim Laeuger, 2007-2008.
 * Support for JTAGkey submitted by Laurent Gauch, 2008.
 *
 */

#include <stdlib.h>
#include <string.h>

#include "sysdep.h"

#include <cable.h>
#include <chain.h>
#include <cmd.h>

#include "generic.h"
#include "generic_usbconn.h"

#include "usbconn.h"
#include "usbconn/libftdx.h"

#include "cmd_xfer.h"

/* Maximum TCK frequency of FT2232 */
#define FT2232_MAX_TCK_FREQ 6000000

/* The default driver if not specified otherwise during connect */
#ifdef ENABLE_LOWLEVEL_FTD2XX
#define DEFAULT_DRIVER "ftd2xx-mpsse"
#else
#define DEFAULT_DRIVER "ftdi-mpsse"
#endif


/* repeat the definitions for MPSSE command processor here
	 since we cannot rely on the existence of ftdih. even though
	 they're defined there */

/* Shifting commands IN MPSSE Mode*/
#define MPSSE_WRITE_NEG 0x01   /* Write TDI/DO on negative TCK/SK edge*/
#define MPSSE_BITMODE   0x02   /* Write bits, not bytes */
#define MPSSE_READ_NEG  0x04   /* Sample TDO/DI on negative TCK/SK edge */
#define MPSSE_LSB       0x08   /* LSB first */
#define MPSSE_DO_WRITE  0x10   /* Write TDI/DO */
#define MPSSE_DO_READ   0x20   /* Read TDO/DI */
#define MPSSE_WRITE_TMS 0x40   /* Write TMS/CS */

/* FTDI MPSSE commands */
#define SET_BITS_LOW   0x80
/*BYTE DATA*/
/*BYTE Direction*/
#define SET_BITS_HIGH  0x82
/*BYTE DATA*/
/*BYTE Direction*/
#define GET_BITS_LOW   0x81
#define GET_BITS_HIGH  0x83
#define LOOPBACK_START 0x84
#define LOOPBACK_END   0x85
#define TCK_DIVISOR    0x86
#define SEND_IMMEDIATE 0x87


/* bit and bitmask definitions for GPIO commands */
#define BIT_TCK 0
#define BIT_TDI 1
#define BIT_TDO 2
#define BIT_TMS 3
#define BITMASK_TDO (1 << BIT_TDO)
#define BITMASK_TDI (1 << BIT_TDI)
#define BITMASK_TCK (1 << BIT_TCK)
#define BITMASK_TMS (1 << BIT_TMS)

/* bit and bitmask definitions for Amontec JTAGkey */
#define BIT_JTAGKEY_nOE 4
#define BIT_JTAGKEY_TRST_N_OUT 0
#define BIT_JTAGKEY_SRST_N_OUT 1
#define BIT_JTAGKEY_TRST_N_OE_N 2
#define BIT_JTAGKEY_SRST_N_OE_N 3
#define BITMASK_JTAGKEY_nOE (1 << BIT_JTAGKEY_nOE)
#define BITMASK_JTAGKEY_TRST_N_OUT (1 << BIT_JTAGKEY_TRST_N_OUT)
#define BITMASK_JTAGKEY_SRST_N_OUT (1 << BIT_JTAGKEY_SRST_N_OUT)
#define BITMASK_JTAGKEY_TRST_N_OE_N (1 << BIT_JTAGKEY_TRST_N_OE_N)
#define BITMASK_JTAGKEY_SRST_N_OE_N (1 << BIT_JTAGKEY_SRST_N_OE_N)
/* bit and bitmask definitions for Olimex ARM-USB-OCD */
#define BIT_ARMUSBOCD_nOE 4
#define BIT_ARMUSBOCD_nTRST 0
#define BIT_ARMUSBOCD_nTSRST 1
#define BIT_ARMUSBOCD_nTRST_nOE 2
#define BIT_ARMUSBOCD_RED_LED 3
#define BITMASK_ARMUSBOCD_nOE (1 << BIT_ARMUSBOCD_nOE)
#define BITMASK_ARMUSBOCD_nTRST (1 << BIT_ARMUSBOCD_nTRST)
#define BITMASK_ARMUSBOCD_nTSRST (1 << BIT_ARMUSBOCD_nTRST)
#define BITMASK_ARMUSBOCD_nTRST_nOE (1 << BIT_ARMUSBOCD_nTRST_nOE)
#define BITMASK_ARMUSBOCD_RED_LED (1 << BIT_ARMUSBOCD_RED_LED)
/* bit and bitmask definitions for Blackfin gnICE */
#define BIT_GNICE_nTRST 1
#define BIT_GNICE_nLED 3 
#define BITMASK_GNICE_nTRST (1 << BIT_GNICE_nTRST)
#define BITMASK_GNICE_nLED (1 << BIT_GNICE_nLED)
/* bit and bitmask definitions for OOCDLink-s */
#define BIT_OOCDLINKS_nTRST_nOE 0
#define BIT_OOCDLINKS_nTRST 1
#define BIT_OOCDLINKS_nSRST_nOE 2
#define BIT_OOCDLINKS_nSRST 3
#define BITMASK_OOCDLINKS_nTRST_nOE (1 << BIT_OOCDLINKS_nTRST_nOE)
#define BITMASK_OOCDLINKS_nTRST (1 << BIT_OOCDLINKS_nTRST)
#define BITMASK_OOCDLINKS_nSRST_nOE (1 << BIT_OOCDLINKS_nSRST_nOE)
#define BITMASK_OOCDLINKS_nSRST (1 << BIT_OOCDLINKS_nSRST)
/* bit and bitmask definitions for Turtelizer 2 */
#define BIT_TURTELIZER2_nJTAGOE 4
#define BIT_TURTELIZER2_RST 6
#define BIT_TURTELIZER2_nTX1LED 2
#define BIT_TURTELIZER2_nRX1LED 3
#define BITMASK_TURTELIZER2_nJTAGOE (1 << BIT_TURTELIZER2_nJTAGOE)
#define BITMASK_TURTELIZER2_RST (1 << BIT_TURTELIZER2_RST)
#define BITMASK_TURTELIZER2_nTX1LED (1 << BIT_TURTELIZER2_nTX1LED)
#define BITMASK_TURTELIZER2_nRX1LED (1 << BIT_TURTELIZER2_nRX1LED)
/* bit and bitmask definitions for USB to JTAG Interface */
#define BIT_USBTOJTAGIF_nTRST 4
#define BIT_USBTOJTAGIF_RST 6
#define BIT_USBTOJTAGIF_DBGRQ 7
#define BIT_USBTOJTAGIF_nRxLED 2
#define BIT_USBTOJTAGIF_nTxLED 3
#define BITMASK_USBTOJTAGIF_nTRST (1 << BIT_USBTOJTAGIF_nTRST)
#define BITMASK_USBTOJTAGIF_RST (1 << BIT_USBTOJTAGIF_RST)
#define BITMASK_USBTOJTAGIF_DBGRQ (1 << BIT_USBTOJTAGIF_DBGRQ)
#define BITMASK_USBTOJTAGIF_nRxLED (1 << BIT_USBTOJTAGIF_nRxLED)
#define BITMASK_USBTOJTAGIF_nTxLED (1 << BIT_USBTOJTAGIF_nTxLED)
/* bit and bitmask definitions for Xverve DT-USB-ST Signalyzer Tool */
#define BIT_SIGNALYZER_nTRST 4
#define BIT_SIGNALYZER_nSRST 5
#define BITMASK_SIGNALYZER_nTRST (1 << BIT_SIGNALYZER_nTRST)
#define BITMASK_SIGNALYZER_nSRST (1 << BIT_SIGNALYZER_nSRST)



typedef struct {
  uint32_t mpsse_frequency;

  /* this driver issues several "Set Data Bits Low Byte" commands
     here is the place where cable specific values can be stored
     that are used each time this command is issued */
  uint8_t low_byte_value;
  uint8_t low_byte_dir;

  /* this driver supports TRST control on high byte only
     set the variables below with value/direction for active and inactive TRST line
     static settings for other high byte signals must be entered here as well */
  uint8_t high_byte_value_trst_active;
  uint8_t high_byte_value_trst_inactive;
  uint8_t high_byte_dir;

  /* variables to save last TDO value
     this acts as a cache to prevent multiple "Read Data Bits Low" transfer
     over USB for ft2232_get_tdo */
  unsigned int last_tdo_valid;
  unsigned int last_tdo;

  cx_cmd_root_t cmd_root;
} params_t;


static const uint8_t  imm_buf[1] = {SEND_IMMEDIATE};
static const cx_cmd_t imm_cmd    = {NULL, 1, 1, (uint8_t *)imm_buf, 0};


static void
ft2232_set_frequency( cable_t *cable, uint32_t new_frequency )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (!new_frequency || new_frequency > FT2232_MAX_TCK_FREQ)
    new_frequency = FT2232_MAX_TCK_FREQ;

  cable->frequency = new_frequency;

  /* update ft2232 frequency if cable setting changed */
  if (new_frequency != params->mpsse_frequency)
  {
    uint32_t div;

    div = FT2232_MAX_TCK_FREQ / new_frequency;
    if (FT2232_MAX_TCK_FREQ % new_frequency)
      div++;

    if (div >= (1 << 16))
    {
      div = (1 << 16) - 1;
      printf( _("Warning: Setting lowest supported frequency for FT2232: %d\n"), FT2232_MAX_TCK_FREQ/div );
    }

    /* send new divisor to device */
    div -= 1;
    cx_cmd_queue( cmd_root, 0 );
    cx_cmd_push( cmd_root, TCK_DIVISOR );
    cx_cmd_push( cmd_root, div & 0xff );
    cx_cmd_push( cmd_root, (div >> 8) & 0xff );

    cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

    params->mpsse_frequency = FT2232_MAX_TCK_FREQ / (div + 1);
  }
}


static int
ft2232_generic_init( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (usbconn_open( cable->link.usb )) return -1;

  /* safe default values */
  params->low_byte_value = 0;
  params->low_byte_dir   = 0;

  /* Set Data Bits Low Byte
     TCK = 0, TMS = 1, TDI = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | BITMASK_TMS );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );

  /* Set Data Bits High Byte */
  params->high_byte_value_trst_active   = 0;
  params->high_byte_value_trst_inactive = 0;
  params->high_byte_dir                 = 0;
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );

  ft2232_set_frequency( cable, FT2232_MAX_TCK_FREQ );

  params->last_tdo_valid = 0;

  return 0;
}

static int
ft2232_jtagkey_init( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (usbconn_open( cable->link.usb )) return -1;

  /* static low byte value and direction:
     set nOE to '0' -> activate output enables */
  params->low_byte_value = 0;
  params->low_byte_dir   = BITMASK_JTAGKEY_nOE;

  /* Set Data Bits Low Byte
     TCK = 0, TMS = 1, TDI = 0, nOE = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | BITMASK_TMS );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );

  /* Set Data Bits High Byte
     default:
     TRST_N_OUT = 1
     TRST_N_OE_N = 0
     SRST_N_OUT = 1
     SRST_N_OE_N = 0 */
  params->high_byte_value_trst_active   = BITMASK_JTAGKEY_SRST_N_OUT;
  params->high_byte_value_trst_inactive = BITMASK_JTAGKEY_TRST_N_OUT | BITMASK_JTAGKEY_SRST_N_OUT;
  params->high_byte_dir                 = BITMASK_JTAGKEY_TRST_N_OUT
    | BITMASK_JTAGKEY_TRST_N_OE_N
    | BITMASK_JTAGKEY_SRST_N_OUT
    | BITMASK_JTAGKEY_SRST_N_OE_N;
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );

  ft2232_set_frequency( cable, FT2232_MAX_TCK_FREQ );

  params->last_tdo_valid = 0;

  return 0;
}


static int
ft2232_armusbocd_init( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (usbconn_open( cable->link.usb )) return -1;

  /* static low byte value and direction:
     set nOE to '0' -> activate output enables */
  params->low_byte_value = 0;
  params->low_byte_dir   = BITMASK_ARMUSBOCD_nOE;

  /* Set Data Bits Low Byte
     TCK = 0, TMS = 1, TDI = 0, nOE = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | BITMASK_TMS );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );

  /* Set Data Bits High Byte
     default:
     TRST = 1
     TRST buffer enable = 0
     TSRST = 1
     RED LED on */
  params->high_byte_value_trst_active   = BITMASK_ARMUSBOCD_nTSRST
    | BITMASK_ARMUSBOCD_RED_LED;
  params->high_byte_value_trst_inactive = BITMASK_ARMUSBOCD_nTRST
    | BITMASK_ARMUSBOCD_nTSRST
    | BITMASK_ARMUSBOCD_RED_LED;
  params->high_byte_dir                 = BITMASK_ARMUSBOCD_nTRST
    | BITMASK_ARMUSBOCD_nTRST_nOE
    | BITMASK_ARMUSBOCD_nTSRST
    | BITMASK_ARMUSBOCD_RED_LED;
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );

  ft2232_set_frequency( cable, FT2232_MAX_TCK_FREQ );

  params->last_tdo_valid = 0;

  return 0;
}


static int
ft2232_gnice_init( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (usbconn_open( cable->link.usb )) return -1;

  /* safe default values */
  params->low_byte_value = 0;
  params->low_byte_dir   = 0;

  /* Set Data Bits Low Byte
     TCK = 0, TMS = 1, TDI = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | BITMASK_TMS );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );

  /* Set Data Bits High Byte */
  params->high_byte_value_trst_active   = 0;
  params->high_byte_value_trst_inactive = BITMASK_GNICE_nTRST;
  params->high_byte_dir                 = BITMASK_GNICE_nTRST | BITMASK_GNICE_nLED;
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );

  ft2232_set_frequency( cable, FT2232_MAX_TCK_FREQ );

  params->last_tdo_valid = 0;

  return 0;
}


static int
ft2232_oocdlinks_init( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (usbconn_open( cable->link.usb )) return -1;

  /* static low byte value and direction */
  params->low_byte_value = 0;
  params->low_byte_dir   = 0;

  /* Set Data Bits Low Byte
     TCK = 0, TMS = 1, TDI = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | BITMASK_TMS );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );

  /* Set Data Bits High Byte
     default:
     TRST = 1
     TRST buffer enable = 0
     SRST = 1
     SRST buffer enable = 0 */
  params->high_byte_value_trst_active   = BITMASK_OOCDLINKS_nSRST;
  params->high_byte_value_trst_inactive = BITMASK_OOCDLINKS_nTRST
    | BITMASK_OOCDLINKS_nSRST;
  params->high_byte_dir                 = BITMASK_OOCDLINKS_nTRST
    | BITMASK_OOCDLINKS_nTRST_nOE
    | BITMASK_OOCDLINKS_nSRST
    | BITMASK_OOCDLINKS_nSRST_nOE;
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );

  ft2232_set_frequency( cable, FT2232_MAX_TCK_FREQ );

  params->last_tdo_valid = 0;

  return 0;
}


static int
ft2232_turtelizer2_init( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (usbconn_open( cable->link.usb )) return -1;

  /* static low byte value and direction:
     set nJTAGOE to '0' -> activate output enables
     set RST to 0 -> inactive nSRST */
  params->low_byte_value = 0;
  params->low_byte_dir   = BITMASK_TURTELIZER2_nJTAGOE | BITMASK_TURTELIZER2_RST;

  /* Set Data Bits Low Byte
     TCK = 0, TMS = 1, TDI = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | BITMASK_TMS );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );

  /* Set Data Bits High Byte
     default:
     TX1LED on
     RX1LED on */
  params->high_byte_value_trst_active   = 0;
  params->high_byte_value_trst_inactive = 0;
  params->high_byte_dir                 = BITMASK_TURTELIZER2_nTX1LED | BITMASK_TURTELIZER2_nRX1LED;
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );

  ft2232_set_frequency( cable, FT2232_MAX_TCK_FREQ );

  params->last_tdo_valid = 0;

  return 0;
}


static int
ft2232_usbtojtagif_init( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (usbconn_open( cable->link.usb )) return -1;

  /* static low byte value and direction:
     nTRST = 1, RST = 1, DBGRQ = 0 */
  params->low_byte_value = BITMASK_USBTOJTAGIF_nTRST | BITMASK_USBTOJTAGIF_RST;
  params->low_byte_dir   = BITMASK_USBTOJTAGIF_nTRST | BITMASK_USBTOJTAGIF_RST | BITMASK_USBTOJTAGIF_DBGRQ;

  /* Set Data Bits Low Byte
     TCK = 0, TMS = 1, TDI = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | BITMASK_TMS );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );

  /* Set Data Bits High Byte
     default:
     RxLED on
     TxLED on */
  params->high_byte_value_trst_active   = 0;
  params->high_byte_value_trst_inactive = 0;
  params->high_byte_dir                 = BITMASK_USBTOJTAGIF_nRxLED | BITMASK_USBTOJTAGIF_nTxLED;
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );

  /* I-couplers can only work up to 3 MHz
     ref. http://www.hs-augsburg.de/~hhoegl/proj/usbjtag/usbjtag.html */
  ft2232_set_frequency( cable, FT2232_MAX_TCK_FREQ/2 );

  params->last_tdo_valid = 0;

  return 0;
}


static int
ft2232_signalyzer_init( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  if (usbconn_open( cable->link.usb )) return -1;

  /* static low byte value and direction:
     nTRST = 1, RST = 1, DBGRQ = 0 */
  params->low_byte_value = BITMASK_SIGNALYZER_nTRST | BITMASK_SIGNALYZER_nSRST;
  params->low_byte_dir   = BITMASK_SIGNALYZER_nTRST | BITMASK_SIGNALYZER_nSRST;

  /* Set Data Bits Low Byte
     TCK = 0, TMS = 1, TDI = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | BITMASK_TMS );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );

  /* Set Data Bits High Byte */
  params->high_byte_value_trst_active   = 0;
  params->high_byte_value_trst_inactive = 0;
  params->high_byte_dir                 = 0;
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );

  ft2232_set_frequency( cable, FT2232_MAX_TCK_FREQ );

  params->last_tdo_valid = 0;

  return 0;
}


static void
ft2232_generic_done( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Set Data Bits Low Byte
     set all to input */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, 0 );

  /* Set Data Bits High Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, 0 );
  cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

  generic_usbconn_done( cable );
}


static void
ft2232_jtagkey_done( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Set Data Bits Low Byte
     disable output drivers */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, BITMASK_JTAGKEY_nOE );
  cx_cmd_push( cmd_root, BITMASK_JTAGKEY_nOE );

  /* Set Data Bits Low Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, BITMASK_JTAGKEY_nOE );
  cx_cmd_push( cmd_root, 0 );

  /* Set Data Bits High Byte
     disable output drivers */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root,
               BITMASK_JTAGKEY_TRST_N_OUT
               | BITMASK_JTAGKEY_TRST_N_OE_N
               | BITMASK_JTAGKEY_SRST_N_OUT
               | BITMASK_JTAGKEY_SRST_N_OE_N );
  cx_cmd_push( cmd_root,
               BITMASK_JTAGKEY_TRST_N_OUT
               | BITMASK_JTAGKEY_TRST_N_OE_N
               | BITMASK_JTAGKEY_SRST_N_OUT
               | BITMASK_JTAGKEY_SRST_N_OE_N );

  /* Set Data Bits High Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root,
               BITMASK_JTAGKEY_TRST_N_OUT
               | BITMASK_JTAGKEY_TRST_N_OE_N
               | BITMASK_JTAGKEY_SRST_N_OUT
               | BITMASK_JTAGKEY_SRST_N_OE_N );
  cx_cmd_push( cmd_root, 0 );
  cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

  generic_usbconn_done( cable );
}


static void
ft2232_armusbocd_done( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Set Data Bits Low Byte
     disable output drivers */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, BITMASK_ARMUSBOCD_nOE );
  cx_cmd_push( cmd_root, BITMASK_ARMUSBOCD_nOE );

  /* Set Data Bits Low Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, BITMASK_ARMUSBOCD_nOE );
  cx_cmd_push( cmd_root, 0 );

  /* Set Data Bits High Byte
     disable output drivers */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root,
               BITMASK_ARMUSBOCD_nTRST
               | BITMASK_ARMUSBOCD_nTRST_nOE
               | BITMASK_ARMUSBOCD_nTSRST );
  cx_cmd_push( cmd_root,
               BITMASK_ARMUSBOCD_nTRST
               | BITMASK_ARMUSBOCD_nTRST_nOE
               | BITMASK_ARMUSBOCD_nTSRST
               | BITMASK_ARMUSBOCD_RED_LED );

  /* Set Data Bits High Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root,
               BITMASK_ARMUSBOCD_nTRST
               | BITMASK_ARMUSBOCD_nTRST_nOE
               | BITMASK_ARMUSBOCD_nTSRST );
  cx_cmd_push( cmd_root, 0 );
  cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

  generic_usbconn_done( cable );
}

static void
ft2232_gnice_done( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Set Data Bits Low Byte
     disable output drivers */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, 0 );

  /* Set Data Bits High Byte
     disable output drivers */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, BITMASK_GNICE_nTRST | BITMASK_GNICE_nLED);
  cx_cmd_push( cmd_root, BITMASK_GNICE_nTRST | BITMASK_GNICE_nLED);

  /* Set Data Bits High Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, BITMASK_GNICE_nTRST);
  cx_cmd_push( cmd_root, 0 );
  cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

  generic_usbconn_done( cable );
}

static void
ft2232_oocdlinks_done( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Set Data Bits Low Byte
     set all to input */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, 0 );

  /* Set Data Bits High Byte
     disable output drivers */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root,
               BITMASK_OOCDLINKS_nTRST
               | BITMASK_OOCDLINKS_nTRST_nOE
               | BITMASK_OOCDLINKS_nSRST
               | BITMASK_OOCDLINKS_nSRST_nOE );
  cx_cmd_push( cmd_root,
               BITMASK_OOCDLINKS_nTRST
               | BITMASK_OOCDLINKS_nTRST_nOE
               | BITMASK_OOCDLINKS_nSRST
               | BITMASK_OOCDLINKS_nSRST_nOE );

  /* Set Data Bits High Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root,
               BITMASK_OOCDLINKS_nTRST
               | BITMASK_OOCDLINKS_nTRST_nOE
               | BITMASK_OOCDLINKS_nSRST
               | BITMASK_OOCDLINKS_nSRST_nOE );
  cx_cmd_push( cmd_root, 0 );
  cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

  generic_usbconn_done( cable );
}


static void
ft2232_turtelizer2_done( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Set Data Bits Low Byte
     disable output drivers */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, BITMASK_TURTELIZER2_nJTAGOE );
  cx_cmd_push( cmd_root, BITMASK_TURTELIZER2_nJTAGOE );

  /* Set Data Bits Low Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, BITMASK_TURTELIZER2_nJTAGOE );
  cx_cmd_push( cmd_root, 0 );

  /* Set Data Bits High Byte
     switch off LEDs */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, BITMASK_TURTELIZER2_nTX1LED | BITMASK_TURTELIZER2_nRX1LED );
  cx_cmd_push( cmd_root, BITMASK_TURTELIZER2_nTX1LED | BITMASK_TURTELIZER2_nRX1LED );

  /* Set Data Bits High Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, 0 );
  cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

  generic_usbconn_done( cable );
}


static void
ft2232_usbtojtagif_done( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Set Data Bits Low Byte
     set all to input */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, BITMASK_USBTOJTAGIF_nTRST | BITMASK_USBTOJTAGIF_RST );
  cx_cmd_push( cmd_root, 0 );

  /* Set Data Bits High Byte
     disable output drivers */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, BITMASK_USBTOJTAGIF_nRxLED | BITMASK_USBTOJTAGIF_nTxLED );
  cx_cmd_push( cmd_root, BITMASK_USBTOJTAGIF_nRxLED | BITMASK_USBTOJTAGIF_nTxLED );

  /* Set Data Bits High Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, BITMASK_USBTOJTAGIF_nRxLED | BITMASK_USBTOJTAGIF_nTxLED );
  cx_cmd_push( cmd_root, 0 );
  cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

  generic_usbconn_done( cable );
}


static void
ft2232_signalyzer_done( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Set Data Bits Low Byte
     set all to input */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, BITMASK_SIGNALYZER_nTRST | BITMASK_SIGNALYZER_nSRST );
  cx_cmd_push( cmd_root, 0 );

  /* Set Data Bits High Byte
     disable output drivers */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, BITMASK_SIGNALYZER_nTRST | BITMASK_SIGNALYZER_nSRST );
  cx_cmd_push( cmd_root, BITMASK_SIGNALYZER_nTRST | BITMASK_SIGNALYZER_nSRST );

  /* Set Data Bits High Byte
     set all to input */
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root, 0 );
  cx_cmd_push( cmd_root, 0 );
  cx_xfer( cmd_root, &imm_cmd, cable, COMPLETELY );

  generic_usbconn_done( cable );
}


static void
ft2232_clock_schedule( cable_t *cable, int tms, int tdi, int n )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  tms = tms ? 0x7f : 0;
  tdi = tdi ? 1 << 7 : 0;

  cx_cmd_queue( cmd_root, 0 );
  while (n > 0)
  {
    /* Clock Data to TMS/CS Pin (no Read) */
    cx_cmd_push( cmd_root, MPSSE_WRITE_TMS |
                 MPSSE_LSB | MPSSE_BITMODE | MPSSE_WRITE_NEG );
    if (n <= 7)
    {
      cx_cmd_push( cmd_root, n-1 );
      n = 0;
    }
    else
    {
      cx_cmd_push( cmd_root, 7-1 );
      n -= 7;
    }
    cx_cmd_push( cmd_root, tdi | tms );
  }
}


static void
ft2232_clock( cable_t *cable, int tms, int tdi, int n )
{
  params_t *params = (params_t *)cable->params;

  ft2232_clock_schedule( cable, tms, tdi, n );
  cx_xfer( &(params->cmd_root), &imm_cmd, cable, COMPLETELY );
  params->last_tdo_valid = 0;
}


static void
ft2232_get_tdo_schedule( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  /* Read Data Bits Low Byte */
  cx_cmd_queue( cmd_root, 1 );
  cx_cmd_push( cmd_root, GET_BITS_LOW );
}


static int
ft2232_get_tdo_finish( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;
  int value;

  value = ( cx_xfer_recv( cable ) & BITMASK_TDO) ? 1 : 0;

  params->last_tdo = value;
  params->last_tdo_valid = 1;

  return value;
}


static int
ft2232_get_tdo( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;

  ft2232_get_tdo_schedule( cable );
  cx_xfer( &(params->cmd_root), &imm_cmd, cable, COMPLETELY );
  return ft2232_get_tdo_finish( cable );
}


static void
ft2232_set_trst_schedule( params_t *params, int trst )
{
  cx_cmd_root_t *cmd_root = &(params->cmd_root);

  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_HIGH );
  cx_cmd_push( cmd_root,
               trst == 0 ? params->high_byte_value_trst_active : params->high_byte_value_trst_inactive );
  cx_cmd_push( cmd_root, params->high_byte_dir );
}

static int
ft2232_set_trst( cable_t *cable, int trst )
{
  params_t *params = (params_t *)cable->params;

  ft2232_set_trst_schedule( params, trst );
  cx_xfer( &(params->cmd_root), &imm_cmd, cable, COMPLETELY );
  params->last_tdo_valid = 0;

  return trst;
}


static void
ft2232_transfer_schedule( cable_t *cable, int len, char *in, char *out )
{
  params_t *params = (params_t *)cable->params;
  cx_cmd_root_t *cmd_root = &(params->cmd_root);
  int in_offset = 0;
  int bitwise_len;
  int chunkbytes;

  /* Set Data Bits Low Byte to lower TMS for transfer
     TCK = 0, TMS = 0, TDI = 0, nOE = 0 */
  cx_cmd_queue( cmd_root, 0 );
  cx_cmd_push( cmd_root, SET_BITS_LOW );
  cx_cmd_push( cmd_root, params->low_byte_value | 0 );
  cx_cmd_push( cmd_root, params->low_byte_dir | BITMASK_TCK | BITMASK_TDI | BITMASK_TMS );


  chunkbytes = len >> 3;
  while (chunkbytes > 0)
  {
    int byte_idx;

    /* reduce chunkbytes to the maximum amount we can receive in one step */
    if (out && chunkbytes > FTDX_MAXRECV)
      chunkbytes = FTDX_MAXRECV;
    /* restrict chunkbytes to the maximum amount that can be transferred
       for one single operation */
    if (chunkbytes > (1 << 16))
      chunkbytes = 1 << 16;

    /***********************************************************************
     * Step 1:
     * Determine data shifting command (bytewise).
     * Either with or without read
     ***********************************************************************/
    if (out)
    {
      cx_cmd_queue( cmd_root, chunkbytes );
      /* Clock Data Bytes In and Out LSB First
         out on negative edge, in on positive edge */
      cx_cmd_push( cmd_root, MPSSE_DO_READ | MPSSE_DO_WRITE |
                   MPSSE_LSB | MPSSE_WRITE_NEG );
    }
    else
    {
      cx_cmd_queue( cmd_root, 0 );
      /* Clock Data Bytes Out on -ve Clock Edge LSB First (no Read) */
      cx_cmd_push( cmd_root, MPSSE_DO_WRITE |
                   MPSSE_LSB | MPSSE_WRITE_NEG );
    }
    /* set byte count */
    cx_cmd_push( cmd_root, (chunkbytes - 1) & 0xff );
    cx_cmd_push( cmd_root, ((chunkbytes - 1) >> 8) & 0xff );

    /*********************************************************************
     * Step 2:
     * Write TDI data in bundles of 8 bits.
     *********************************************************************/
    for (byte_idx = 0; byte_idx < chunkbytes; byte_idx++)
    {
      int bit_idx;
      unsigned char b = 0;

      for (bit_idx = 1; bit_idx < 256; bit_idx <<= 1)
        if (in[in_offset++])
          b |= bit_idx;
      cx_cmd_push( cmd_root, b );
    }

    /* recalc chunkbytes for next round */
    chunkbytes = (len - in_offset) >> 3;
  }

  /* determine bitwise shift amount */
  bitwise_len = (len - in_offset) % 8;
  if (bitwise_len > 0)
  {
    /***********************************************************************
     * Step 3:
     * Determine data shifting command (bitwise).
     * Either with or without read
     ***********************************************************************/
    if (out)
    {
      cx_cmd_queue( cmd_root, 1 );
      /* Clock Data Bytes In and Out LSB First
         out on negative edge, in on positive edge */
      cx_cmd_push( cmd_root, MPSSE_DO_READ | MPSSE_DO_WRITE |
                   MPSSE_LSB | MPSSE_BITMODE | MPSSE_WRITE_NEG );
    }
    else
    {
      cx_cmd_queue( cmd_root, 0 );
      /* Clock Data Bytes Out on -ve Clock Edge LSB First (no Read) */
      cx_cmd_push( cmd_root, MPSSE_DO_WRITE |
                   MPSSE_LSB | MPSSE_BITMODE | MPSSE_WRITE_NEG );
    }
    /* determine bit count */
    cx_cmd_push( cmd_root, bitwise_len - 1 );

    /***********************************************************************
     * Step 4:
     * Write TDI data bitwise
     ***********************************************************************/
    {
      int bit_idx;
      unsigned char b = 0;
      for (bit_idx = 1; bit_idx < 1 << bitwise_len; bit_idx <<= 1)
      {
        if (in[in_offset++])
          b |= bit_idx;
      }
      cx_cmd_push( cmd_root, b );
    }
  }

  if (out)
  {
    /* Read Data Bits Low Byte to get current TDO,
       Do this only if we'll read out data nonetheless */
    cx_cmd_queue( cmd_root, 1 );
    cx_cmd_push( cmd_root, GET_BITS_LOW );
    params->last_tdo_valid = 1;
  }
  else
    params->last_tdo_valid = 0;
}


static int
ft2232_transfer_finish( cable_t *cable, int len, char *out )
{
  params_t *params = (params_t *)cable->params;
  int bitwise_len;
  int chunkbytes;
  int out_offset = 0;

  chunkbytes = len >> 3;
  bitwise_len = len % 8;

  if (out)
  {
    if (chunkbytes > 0)
    {
      uint32_t xferred;

      /*********************************************************************
       * Step 5:
       * Read TDO data in bundles of 8 bits if read is requested.
       *********************************************************************/
      xferred = chunkbytes;
      for (; xferred > 0; xferred--)
      {
        int bit_idx;
        unsigned char b;

        b = cx_xfer_recv( cable );
        for (bit_idx = 1; bit_idx < 256; bit_idx <<= 1)
          out[out_offset++] = (b & bit_idx) ? 1 : 0;
      }
    }

    if (bitwise_len > 0)
    {
      /***********************************************************************
       * Step 6:
       * Read TDO data bitwise if read is requested.
       ***********************************************************************/
      int bit_idx;
      unsigned char b;

      b = cx_xfer_recv( cable );

      for (bit_idx = (1 << (8 - bitwise_len)); bit_idx < 256; bit_idx <<= 1)
        out[out_offset++] = (b & bit_idx) ? 1 : 0;
    }

    /* gather current TDO */
    params->last_tdo = ( cx_xfer_recv( cable ) & BITMASK_TDO) ? 1 : 0;
    params->last_tdo_valid = 1;
  }
  else
    params->last_tdo_valid = 0;

  return 0;
}


static int
ft2232_transfer( cable_t *cable, int len, char *in, char *out )
{
  params_t *params = (params_t *)cable->params;

  ft2232_transfer_schedule( cable, len, in, out );
  cx_xfer( &(params->cmd_root), &imm_cmd, cable, COMPLETELY );
  return ft2232_transfer_finish( cable, len, out );
}


static void
ft2232_flush( cable_t *cable, cable_flush_amount_t how_much )
{
  params_t *params = (params_t *)cable->params;

  if (how_much == OPTIONALLY) return;

  if (cable->todo.num_items == 0)
    cx_xfer( &(params->cmd_root), &imm_cmd, cable, how_much );

  while (cable->todo.num_items > 0)
  {
    int i, j, n;
    int last_tdo_valid_schedule = params->last_tdo_valid;
    int last_tdo_valid_finish = params->last_tdo_valid;

    for (j = i = cable->todo.next_item, n = 0; n < cable->todo.num_items; n++)
    {

      switch (cable->todo.data[i].action)
      {
      case CABLE_CLOCK:
        ft2232_clock_schedule( cable,
                               cable->todo.data[i].arg.clock.tms,
                               cable->todo.data[i].arg.clock.tdi,
                               cable->todo.data[i].arg.clock.n );
        last_tdo_valid_schedule = 0;
        break;

      case CABLE_GET_TDO:
        if (!last_tdo_valid_schedule)
        {
          ft2232_get_tdo_schedule( cable );
          last_tdo_valid_schedule = 1;
        }
        break;

      case CABLE_SET_TRST:
        ft2232_set_trst_schedule( params, cable->todo.data[i].arg.value.trst );
        last_tdo_valid_schedule = 0;
        break;

      case CABLE_TRANSFER:
        ft2232_transfer_schedule( cable,
                                  cable->todo.data[i].arg.transfer.len,
                                  cable->todo.data[i].arg.transfer.in,
                                  cable->todo.data[i].arg.transfer.out );
        last_tdo_valid_schedule = params->last_tdo_valid;
        break;

      default:
        break;
      }

      i++;
      if (i >= cable->todo.max_items)
        i = 0;
    }

    cx_xfer( &(params->cmd_root), &imm_cmd, cable, how_much );

    while (j != i)
    {
      switch (cable->todo.data[j].action)
      {
      case CABLE_CLOCK:
        params->last_tdo_valid = last_tdo_valid_finish = 0;
        break;
      case CABLE_GET_TDO:
        {
          int tdo;
          int m;
          if (last_tdo_valid_finish)
            tdo = params->last_tdo;
          else
            tdo = ft2232_get_tdo_finish( cable );
          last_tdo_valid_finish = params->last_tdo_valid;
          m = cable_add_queue_item( cable, &(cable->done) );
          cable->done.data[m].action = CABLE_GET_TDO;
          cable->done.data[m].arg.value.tdo = tdo;
          break;
        }
      case CABLE_SET_TRST:
        {
          int m = cable_add_queue_item( cable, &(cable->done) );
          cable->done.data[m].action = CABLE_SET_TRST;
          cable->done.data[m].arg.value.trst = cable->done.data[j].arg.value.trst;
          params->last_tdo_valid = last_tdo_valid_finish = 0;
        }
      case CABLE_GET_TRST:
        {
          int m = cable_add_queue_item( cable, &(cable->done) );
          cable->done.data[m].action = CABLE_GET_TRST;
          cable->done.data[m].arg.value.trst = 1;
          break;
        }
      case CABLE_TRANSFER:
        {
          int  r = ft2232_transfer_finish( cable,
                                           cable->todo.data[j].arg.transfer.len,
                                           cable->todo.data[j].arg.transfer.out );
          last_tdo_valid_finish = params->last_tdo_valid;
          free( cable->todo.data[j].arg.transfer.in );
          if (cable->todo.data[j].arg.transfer.out)
          {
            int m = cable_add_queue_item( cable, &(cable->done) );
            if (m < 0)
              printf("out of memory!\n");
            cable->done.data[m].action = CABLE_TRANSFER;
            cable->done.data[m].arg.xferred.len = cable->todo.data[j].arg.transfer.len;
            cable->done.data[m].arg.xferred.res = r;
            cable->done.data[m].arg.xferred.out = cable->todo.data[j].arg.transfer.out;
          }
        }
      default:
        break;
      }

      j++;
      if (j >= cable->todo.max_items)
        j = 0;
      cable->todo.num_items--;
    }

    cable->todo.next_item = i;
  }
}


static int
ft2232_connect( char *params[], cable_t *cable )
{
  params_t *cable_params;
  int result;

  /* perform generic_usbconn_connect */
  if ( ( result = generic_usbconn_connect( params, cable ) ) != 0 )
    return result;

  cable_params = (params_t *)malloc( sizeof(params_t) );
  if (!cable_params) {
    printf( _("%s(%d) malloc failed!\n"), __FILE__, __LINE__);
    /* NOTE:
     * Call the underlying usbport driver (*free) routine directly
     * not generic_usbconn_free() since it also free's cable->params
     * (which is not established) and cable (which the caller will do)
     */
    cable->link.usb->driver->free( cable->link.usb );
    return 4;
  }

    cable_params->mpsse_frequency = 0;
    cable_params->last_tdo_valid  = 0;

    cx_cmd_init( &(cable_params->cmd_root) );

    /* exchange generic cable parameters with our private parameter set */
    free( cable->params );
    cable->params = cable_params;

  return 0;
}


static void
ft2232_cable_free( cable_t *cable )
{
  params_t *params = (params_t *)cable->params;

  cx_cmd_deinit( &(params->cmd_root) );

  generic_usbconn_free( cable );
}


usbconn_cable_t usbconn_cable_ft2232_ftdi;
usbconn_cable_t usbconn_cable_armusbocd_ftdi;
usbconn_cable_t usbconn_cable_gnice_ftdi;
usbconn_cable_t usbconn_cable_jtagkey_ftdi;
usbconn_cable_t usbconn_cable_oocdlinks_ftdi;
usbconn_cable_t usbconn_cable_turtelizer2_ftdi;
usbconn_cable_t usbconn_cable_usbtojtagif_ftdi;
usbconn_cable_t usbconn_cable_signalyzer_ftdi;

static void
ft2232_usbcable_help( const char *cablename )
{
  usbconn_cable_t *conn;

  conn = &usbconn_cable_armusbocd_ftdi;
  if (strcasecmp( conn->name, cablename ) == 0)
    goto found;
  conn = &usbconn_cable_gnice_ftdi;
  if (strcasecmp( conn->name, cablename ) == 0)
    goto found;
  conn = &usbconn_cable_jtagkey_ftdi;
  if (strcasecmp( conn->name, cablename ) == 0)
    goto found;
  conn = &usbconn_cable_oocdlinks_ftdi;
  if (strcasecmp( conn->name, cablename ) == 0)
    goto found;
  conn = &usbconn_cable_turtelizer2_ftdi;
  if (strcasecmp( conn->name, cablename ) == 0)
    goto found;
  conn = &usbconn_cable_usbtojtagif_ftdi;
  if (strcasecmp( conn->name, cablename ) == 0)
    goto found;
  conn = &usbconn_cable_signalyzer_ftdi;
  if (strcasecmp( conn->name, cablename ) == 0)
    goto found;
  conn = &usbconn_cable_ft2232_ftdi;
found:

  printf( _(
            "Usage: cable %s [vid=VID] [pid=PID] [desc=DESC] [driver=DRIVER]\n"
            "\n"
            "VID        vendor ID (hex), defaults to %04X\n"
            "PID        product ID (hex), defaults to %04X\n"
            "DESC       Some string to match in description or serial no.\n"
            "DRIVER     usbconn driver, either ftdi-mpsse or ftd2xx-mpsse\n"
            "           defaults to %s if not specified\n"
            "\n"
            ),
          cablename,
          conn->vid, conn->pid,
          DEFAULT_DRIVER
          );
}


cable_driver_t ft2232_cable_driver = {
  "FT2232",
  N_("Generic FTDI FT2232 Cable"),
  ft2232_connect,
  generic_disconnect,
  ft2232_cable_free,
  ft2232_generic_init,
  ft2232_generic_done,
  ft2232_set_frequency,
  ft2232_clock,
  ft2232_get_tdo,
  ft2232_transfer,
  ft2232_set_trst,
  generic_get_trst,
  ft2232_flush,
  ft2232_usbcable_help
};
usbconn_cable_t usbconn_cable_ft2232_ftdi = {
  "FT2232",           /* cable name */
  NULL,               /* string pattern, not used */
  "ftdi-mpsse",       /* default usbconn driver */
  0x0000,             /* VID */
  0x0000              /* PID */
};
usbconn_cable_t usbconn_cable_ft2232_ftd2xx = {
  "FT2232",           /* cable name */
  NULL,               /* string pattern, not used */
  "ftd2xx-mpsse",     /* default usbconn driver */
  0x0000,             /* VID */
  0x0000              /* PID */
};

cable_driver_t ft2232_armusbocd_cable_driver = {
  "ARM-USB-OCD",
  N_("Olimex ARM-USB-OCD (FT2232) Cable"),
  ft2232_connect,
  generic_disconnect,
  ft2232_cable_free,
  ft2232_armusbocd_init,
  ft2232_armusbocd_done,
  ft2232_set_frequency,
  ft2232_clock,
  ft2232_get_tdo,
  ft2232_transfer,
  ft2232_set_trst,
  generic_get_trst,
  ft2232_flush,
  ft2232_usbcable_help
};
usbconn_cable_t usbconn_cable_armusbocd_ftdi = {
  "ARM-USB-OCD",      /* cable name */
  NULL,               /* string pattern, not used */
  "ftdi-mpsse",       /* default usbconn driver */
  0x15BA,             /* VID */
  0x0003              /* PID */
};
usbconn_cable_t usbconn_cable_armusbocd_ftd2xx = {
  "ARM-USB-OCD",      /* cable name */
  NULL,               /* string pattern, not used */
  "ftd2xx-mpsse",     /* default usbconn driver */
  0x15BA,             /* VID */
  0x0003              /* PID */
};

cable_driver_t ft2232_gnice_cable_driver = {
  "gnICE",
  N_("Analog Devices Blackfin gnICE (FT2232) Cable (EXPERIMENTAL)"),
  ft2232_connect,
  generic_disconnect,
  ft2232_cable_free,
  ft2232_gnice_init,
  ft2232_gnice_done,
  ft2232_set_frequency,
  ft2232_clock,
  ft2232_get_tdo,
  ft2232_transfer,
  ft2232_set_trst,
  generic_get_trst,
  ft2232_flush,
  ft2232_usbcable_help
};
usbconn_cable_t usbconn_cable_gnice_ftdi = {
  "gnICE",            /* cable name */
  NULL,               /* string pattern, not used */
  "ftdi-mpsse",       /* default usbconn driver */
  0x0456,             /* VID */
  0xF000              /* PID */
};
usbconn_cable_t usbconn_cable_gnice_ftd2xx = {
  "gnICE",            /* cable name */
  NULL,               /* string pattern, not used */
  "ftd2xx-mpsse",     /* default usbconn driver */
  0x0456,             /* VID */
  0xF000              /* PID */
};

cable_driver_t ft2232_jtagkey_cable_driver = {
  "JTAGkey",
  N_("Amontec JTAGkey (FT2232) Cable"),
  ft2232_connect,
  generic_disconnect,
  ft2232_cable_free,
  ft2232_jtagkey_init,
  ft2232_jtagkey_done,
  ft2232_set_frequency,
  ft2232_clock,
  ft2232_get_tdo,
  ft2232_transfer,
  ft2232_set_trst,
  generic_get_trst,
  ft2232_flush,
  ft2232_usbcable_help
};
usbconn_cable_t usbconn_cable_jtagkey_ftdi = {
  "JTAGkey",          /* cable name */
  NULL,               /* string pattern, not used */
  "ftdi-mpsse",       /* default usbconn driver */
  0x0403,             /* VID */
  0xCFF8              /* PID */
};
usbconn_cable_t usbconn_cable_jtagkey_ftd2xx = {
  "JTAGkey",          /* cable name */
  NULL,               /* string pattern, not used */
  "ftd2xx-mpsse",     /* default usbconn driver */
  0x0403,             /* VID */
  0xCFF8              /* PID */
};

cable_driver_t ft2232_oocdlinks_cable_driver = {
  "OOCDLink-s",
  N_("OOCDLink-s (FT2232) Cable (EXPERIMENTAL)"),
  ft2232_connect,
  generic_disconnect,
  ft2232_cable_free,
  ft2232_oocdlinks_init,
  ft2232_oocdlinks_done,
  ft2232_set_frequency,
  ft2232_clock,
  ft2232_get_tdo,
  ft2232_transfer,
  ft2232_set_trst,
  generic_get_trst,
  ft2232_flush,
  ft2232_usbcable_help
};
usbconn_cable_t usbconn_cable_oocdlinks_ftdi = {
  "OOCDLink-s",       /* cable name */
  NULL,               /* string pattern, not used */
  "ftdi-mpsse",       /* default usbconn driver */
  0x0403,             /* VID */
  0xbaf8              /* PID */
};
usbconn_cable_t usbconn_cable_oocdlinks_ftd2xx = {
  "OOCDLink-s",       /* cable name */
  NULL,               /* string pattern, not used */
  "ftd2xx-mpsse",     /* default usbconn driver */
  0x0403,             /* VID */
  0xbaf8              /* PID */
};

cable_driver_t ft2232_turtelizer2_cable_driver = {
  "Turtelizer2",
  N_("Turtelizer 2 Rev. B (FT2232) Cable (EXPERIMENTAL)"),
  ft2232_connect,
  generic_disconnect,
  ft2232_cable_free,
  ft2232_turtelizer2_init,
  ft2232_turtelizer2_done,
  ft2232_set_frequency,
  ft2232_clock,
  ft2232_get_tdo,
  ft2232_transfer,
  ft2232_set_trst,
  generic_get_trst,
  ft2232_flush,
  ft2232_usbcable_help
};
usbconn_cable_t usbconn_cable_turtelizer2_ftdi = {
  "Turtelizer2",      /* cable name */
  NULL,               /* string pattern, not used */
  "ftdi-mpsse",       /* default usbconn driver */
  0x0403,             /* VID */
  0xBDC8              /* PID */
};
usbconn_cable_t usbconn_cable_turtelizer2_ftd2xx = {
  "Turtelizer2",      /* cable name */
  NULL,               /* string pattern, not used */
  "ftd2xx-mpsse",     /* default usbconn driver */
  0x0403,             /* VID */
  0xBDC8              /* PID */
};

cable_driver_t ft2232_usbtojtagif_cable_driver = {
  "USB-to-JTAG-IF",
  N_("USB to JTAG Interface (FT2232) Cable (EXPERIMENTAL)"),
  ft2232_connect,
  generic_disconnect,
  ft2232_cable_free,
  ft2232_usbtojtagif_init,
  ft2232_usbtojtagif_done,
  ft2232_set_frequency,
  ft2232_clock,
  ft2232_get_tdo,
  ft2232_transfer,
  ft2232_set_trst,
  generic_get_trst,
  ft2232_flush,
  ft2232_usbcable_help
};
usbconn_cable_t usbconn_cable_usbtojtagif_ftdi = {
  "USB-to-JTAG-IF",   /* cable name */
  NULL,               /* string pattern, not used */
  "ftdi-mpsse",       /* default usbconn driver */
  0x0000,             /* VID */
  0x0000              /* PID */
};
usbconn_cable_t usbconn_cable_usbtojtagif_ftd2xx = {
  "USB-to-JTAG-IF",   /* cable name */
  NULL,               /* string pattern, not used */
  "ftd2xx-mpsse",     /* default usbconn driver */
  0x0000,             /* VID */
  0x0000              /* PID */
};

cable_driver_t ft2232_signalyzer_cable_driver = {
  "Signalyzer",
  N_("Xverve DT-USB-ST Signalyzer Tool (FT2232) Cable (EXPERIMENTAL)"),
  ft2232_connect,
  generic_disconnect,
  ft2232_cable_free,
  ft2232_signalyzer_init,
  ft2232_signalyzer_done,
  ft2232_set_frequency,
  ft2232_clock,
  ft2232_get_tdo,
  ft2232_transfer,
  ft2232_set_trst,
  generic_get_trst,
  ft2232_flush,
  ft2232_usbcable_help
};
usbconn_cable_t usbconn_cable_signalyzer_ftdi = {
  "Signalyzer",       /* cable name */
  NULL,               /* string pattern, not used */
  "ftdi-mpsse",       /* default usbconn driver */
  0x0000,             /* VID */
  0x0000              /* PID */
};
usbconn_cable_t usbconn_cable_signalyzer_ftd2xx = {
  "Signalyzer",       /* cable name */
  NULL,               /* string pattern, not used */
  "ftd2xx-mpsse",     /* default usbconn driver */
  0x0000,             /* VID */
  0x0000              /* PID */
};


/*
 Local Variables:
 mode:C
 c-default-style:gnu
 indent-tabs-mode:nil
 End:
*/
