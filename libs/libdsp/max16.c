// Copyright (C) 2000, 2001 Analog Devices Inc., All Rights Reserved.
// This contains Development IP as defined in the ADI/Intel
// Collaboration Agreement (ADI/Intel Confidential)

/**********************************************************************
   File Name      : max.c

   Description    : Returning the larger of two fractional numbers

**********************************************************************/

#pragma file_attr("libGroup =fract.h")
#pragma file_attr("libGroup =fract_math.h")
#pragma file_attr("libGroup =math_bf.h")
#pragma file_attr("libGroup =math.h")
#pragma file_attr("libFunc  =__fmax_fr16")
#pragma file_attr("libFunc  =max_fr16")     //from math_bf.h

#pragma file_attr("libName =libdsp")
#pragma file_attr("prefersMem =internal")
#pragma file_attr("prefersMemNum =30")

#include <fract.h>
#include <math.h>

fract16 _fmax_fr16(fract16 param1,fract16 param2)
{
    fract16 result = param2;

    /*{ if param1 > param2, result = x }*/
    if (param1 > param2)
    {
        result = param1;
    }

    /*{ return result }*/
    return result;
}
/*end of file*/
