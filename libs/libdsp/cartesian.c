/***************************************************************************
 *
 * cartesianf.c
 *
 * Copyright (C) 2003 Analog Devices, Inc.
 * This file is subject to the terms and conditions of the GNU Lesser
 * General Public License. See the file COPYING.LIB for more details.
 *
 * Non-LGPL License is also available as part of VisualDSP++
 * from Analog Devices, Inc.
 *
 ***************************************************************************/

/* This function converts a complex number 
   from cartesian to polar notation. 
 */

#pragma file_attr("libGroup =complex.h")
#pragma file_attr("libFunc  =cartesianf")       //from complex.h
#pragma file_attr("libFunc  =__cartesianf")
#pragma file_attr("libFunc  =cartesian")        //from complex.h

#pragma file_attr("libName =libdsp")
#pragma file_attr("prefersMem =internal")
#pragma file_attr("prefersMemNum =30")

#include <complex.h>

float _cartesianf( complex_float a, float* phase )
{
   *phase = argf(a);      /* compute phase     */
   return( cabsf(a) );    /* compute magnitude */
}

