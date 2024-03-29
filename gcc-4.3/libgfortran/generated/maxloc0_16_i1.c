/* Implementation of the MAXLOC intrinsic
   Copyright 2002, 2007 Free Software Foundation, Inc.
   Contributed by Paul Brook <paul@nowt.org>

This file is part of the GNU Fortran 95 runtime library (libgfortran).

Libgfortran is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

In addition to the permissions in the GNU General Public License, the
Free Software Foundation gives you unlimited permission to link the
compiled version of this file into combinations with other programs,
and to distribute those combinations without any restriction coming
from the use of this file.  (The General Public License restrictions
do apply in other respects; for example, they cover modification of
the file, and distribution when not linked into a combine
executable.)

Libgfortran is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with libgfortran; see the file COPYING.  If not,
write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
Boston, MA 02110-1301, USA.  */

#include "libgfortran.h"
#include <stdlib.h>
#include <assert.h>
#include <limits.h>


#if defined (HAVE_GFC_INTEGER_1) && defined (HAVE_GFC_INTEGER_16)


extern void maxloc0_16_i1 (gfc_array_i16 * const restrict retarray, 
	gfc_array_i1 * const restrict array);
export_proto(maxloc0_16_i1);

void
maxloc0_16_i1 (gfc_array_i16 * const restrict retarray, 
	gfc_array_i1 * const restrict array)
{
  index_type count[GFC_MAX_DIMENSIONS];
  index_type extent[GFC_MAX_DIMENSIONS];
  index_type sstride[GFC_MAX_DIMENSIONS];
  index_type dstride;
  const GFC_INTEGER_1 *base;
  GFC_INTEGER_16 *dest;
  index_type rank;
  index_type n;

  rank = GFC_DESCRIPTOR_RANK (array);
  if (rank <= 0)
    runtime_error ("Rank of array needs to be > 0");

  if (retarray->data == NULL)
    {
      retarray->dim[0].lbound = 0;
      retarray->dim[0].ubound = rank-1;
      retarray->dim[0].stride = 1;
      retarray->dtype = (retarray->dtype & ~GFC_DTYPE_RANK_MASK) | 1;
      retarray->offset = 0;
      retarray->data = internal_malloc_size (sizeof (GFC_INTEGER_16) * rank);
    }
  else
    {
      if (compile_options.bounds_check)
	{
	  int ret_rank;
	  index_type ret_extent;

	  ret_rank = GFC_DESCRIPTOR_RANK (retarray);
	  if (ret_rank != 1)
	    runtime_error ("rank of return array in MAXLOC intrinsic"
			   " should be 1, is %ld", (long int) ret_rank);

	  ret_extent = retarray->dim[0].ubound + 1 - retarray->dim[0].lbound;
	  if (ret_extent != rank)
	    runtime_error ("Incorrect extent in return value of"
			   " MAXLOC intrinsic: is %ld, should be %ld",
			   (long int) ret_extent, (long int) rank);
	}
    }

  dstride = retarray->dim[0].stride;
  dest = retarray->data;
  for (n = 0; n < rank; n++)
    {
      sstride[n] = array->dim[n].stride;
      extent[n] = array->dim[n].ubound + 1 - array->dim[n].lbound;
      count[n] = 0;
      if (extent[n] <= 0)
	{
	  /* Set the return value.  */
	  for (n = 0; n < rank; n++)
	    dest[n * dstride] = 0;
	  return;
	}
    }

  base = array->data;

  /* Initialize the return value.  */
  for (n = 0; n < rank; n++)
    dest[n * dstride] = 0;
  {

  GFC_INTEGER_1 maxval;

  maxval = (-GFC_INTEGER_1_HUGE-1);

  while (base)
    {
      {
        /* Implementation start.  */

  if (*base > maxval || !dest[0])
    {
      maxval = *base;
      for (n = 0; n < rank; n++)
        dest[n * dstride] = count[n] + 1;
    }
        /* Implementation end.  */
      }
      /* Advance to the next element.  */
      count[0]++;
      base += sstride[0];
      n = 0;
      while (count[n] == extent[n])
        {
          /* When we get to the end of a dimension, reset it and increment
             the next dimension.  */
          count[n] = 0;
          /* We could precalculate these products, but this is a less
             frequently used path so probably not worth it.  */
          base -= sstride[n] * extent[n];
          n++;
          if (n == rank)
            {
              /* Break out of the loop.  */
              base = NULL;
              break;
            }
          else
            {
              count[n]++;
              base += sstride[n];
            }
        }
    }
  }
}


extern void mmaxloc0_16_i1 (gfc_array_i16 * const restrict, 
	gfc_array_i1 * const restrict, gfc_array_l1 * const restrict);
export_proto(mmaxloc0_16_i1);

void
mmaxloc0_16_i1 (gfc_array_i16 * const restrict retarray, 
	gfc_array_i1 * const restrict array,
	gfc_array_l1 * const restrict mask)
{
  index_type count[GFC_MAX_DIMENSIONS];
  index_type extent[GFC_MAX_DIMENSIONS];
  index_type sstride[GFC_MAX_DIMENSIONS];
  index_type mstride[GFC_MAX_DIMENSIONS];
  index_type dstride;
  GFC_INTEGER_16 *dest;
  const GFC_INTEGER_1 *base;
  GFC_LOGICAL_1 *mbase;
  int rank;
  index_type n;
  int mask_kind;

  rank = GFC_DESCRIPTOR_RANK (array);
  if (rank <= 0)
    runtime_error ("Rank of array needs to be > 0");

  if (retarray->data == NULL)
    {
      retarray->dim[0].lbound = 0;
      retarray->dim[0].ubound = rank-1;
      retarray->dim[0].stride = 1;
      retarray->dtype = (retarray->dtype & ~GFC_DTYPE_RANK_MASK) | 1;
      retarray->offset = 0;
      retarray->data = internal_malloc_size (sizeof (GFC_INTEGER_16) * rank);
    }
  else
    {
      if (compile_options.bounds_check)
	{
	  int ret_rank, mask_rank;
	  index_type ret_extent;
	  int n;
	  index_type array_extent, mask_extent;

	  ret_rank = GFC_DESCRIPTOR_RANK (retarray);
	  if (ret_rank != 1)
	    runtime_error ("rank of return array in MAXLOC intrinsic"
			   " should be 1, is %ld", (long int) ret_rank);

	  ret_extent = retarray->dim[0].ubound + 1 - retarray->dim[0].lbound;
	  if (ret_extent != rank)
	    runtime_error ("Incorrect extent in return value of"
			   " MAXLOC intrinsic: is %ld, should be %ld",
			   (long int) ret_extent, (long int) rank);
	
	  mask_rank = GFC_DESCRIPTOR_RANK (mask);
	  if (rank != mask_rank)
	    runtime_error ("rank of MASK argument in MAXLOC intrinsic"
	                   "should be %ld, is %ld", (long int) rank,
			   (long int) mask_rank);

	  for (n=0; n<rank; n++)
	    {
	      array_extent = array->dim[n].ubound + 1 - array->dim[n].lbound;
	      mask_extent = mask->dim[n].ubound + 1 - mask->dim[n].lbound;
	      if (array_extent != mask_extent)
		runtime_error ("Incorrect extent in MASK argument of"
			       " MAXLOC intrinsic in dimension %ld:"
			       " is %ld, should be %ld", (long int) n + 1,
			       (long int) mask_extent, (long int) array_extent);
	    }
	}
    }

  mask_kind = GFC_DESCRIPTOR_SIZE (mask);

  mbase = mask->data;

  if (mask_kind == 1 || mask_kind == 2 || mask_kind == 4 || mask_kind == 8
#ifdef HAVE_GFC_LOGICAL_16
      || mask_kind == 16
#endif
      )
    mbase = GFOR_POINTER_TO_L1 (mbase, mask_kind);
  else
    runtime_error ("Funny sized logical array");

  dstride = retarray->dim[0].stride;
  dest = retarray->data;
  for (n = 0; n < rank; n++)
    {
      sstride[n] = array->dim[n].stride;
      mstride[n] = mask->dim[n].stride * mask_kind;
      extent[n] = array->dim[n].ubound + 1 - array->dim[n].lbound;
      count[n] = 0;
      if (extent[n] <= 0)
	{
	  /* Set the return value.  */
	  for (n = 0; n < rank; n++)
	    dest[n * dstride] = 0;
	  return;
	}
    }

  base = array->data;

  /* Initialize the return value.  */
  for (n = 0; n < rank; n++)
    dest[n * dstride] = 0;
  {

  GFC_INTEGER_1 maxval;

  maxval = (-GFC_INTEGER_1_HUGE-1);

  while (base)
    {
      {
        /* Implementation start.  */

  if (*mbase && (*base > maxval || !dest[0]))
    {
      maxval = *base;
      for (n = 0; n < rank; n++)
        dest[n * dstride] = count[n] + 1;
    }
        /* Implementation end.  */
      }
      /* Advance to the next element.  */
      count[0]++;
      base += sstride[0];
      mbase += mstride[0];
      n = 0;
      while (count[n] == extent[n])
        {
          /* When we get to the end of a dimension, reset it and increment
             the next dimension.  */
          count[n] = 0;
          /* We could precalculate these products, but this is a less
             frequently used path so probably not worth it.  */
          base -= sstride[n] * extent[n];
          mbase -= mstride[n] * extent[n];
          n++;
          if (n == rank)
            {
              /* Break out of the loop.  */
              base = NULL;
              break;
            }
          else
            {
              count[n]++;
              base += sstride[n];
              mbase += mstride[n];
            }
        }
    }
  }
}


extern void smaxloc0_16_i1 (gfc_array_i16 * const restrict, 
	gfc_array_i1 * const restrict, GFC_LOGICAL_4 *);
export_proto(smaxloc0_16_i1);

void
smaxloc0_16_i1 (gfc_array_i16 * const restrict retarray, 
	gfc_array_i1 * const restrict array,
	GFC_LOGICAL_4 * mask)
{
  index_type rank;
  index_type dstride;
  index_type n;
  GFC_INTEGER_16 *dest;

  if (*mask)
    {
      maxloc0_16_i1 (retarray, array);
      return;
    }

  rank = GFC_DESCRIPTOR_RANK (array);

  if (rank <= 0)
    runtime_error ("Rank of array needs to be > 0");

  if (retarray->data == NULL)
    {
      retarray->dim[0].lbound = 0;
      retarray->dim[0].ubound = rank-1;
      retarray->dim[0].stride = 1;
      retarray->dtype = (retarray->dtype & ~GFC_DTYPE_RANK_MASK) | 1;
      retarray->offset = 0;
      retarray->data = internal_malloc_size (sizeof (GFC_INTEGER_16) * rank);
    }
  else
    {
      if (compile_options.bounds_check)
	{
	  int ret_rank;
	  index_type ret_extent;

	  ret_rank = GFC_DESCRIPTOR_RANK (retarray);
	  if (ret_rank != 1)
	    runtime_error ("rank of return array in MAXLOC intrinsic"
			   " should be 1, is %ld", (long int) ret_rank);

	  ret_extent = retarray->dim[0].ubound + 1 - retarray->dim[0].lbound;
	    if (ret_extent != rank)
	      runtime_error ("dimension of return array incorrect");
	}
    }

  dstride = retarray->dim[0].stride;
  dest = retarray->data;
  for (n = 0; n<rank; n++)
    dest[n * dstride] = 0 ;
}
#endif
