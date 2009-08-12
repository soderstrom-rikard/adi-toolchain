/*******************************************************************************
 *  Copyright (c) 2009 Analog Devices, Inc.
 *  All rights reserved. This program and the accompanying materials
 *  are made available under the terms of the Eclipse Public License v1.0
 *  which accompanies this distribution, and is available at
 *  http://www.eclipse.org/legal/epl-v10.html
 *
 *  Contributors:
 *     Analog Devices, Inc. - Initial implementation
 *******************************************************************************/
package com.analog.gnu.debug.utils;

import java.util.Arrays;
import java.util.Comparator;

/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class Sorter
{
	/**
	 * Sort a given array of object according to the default comparator
	 * in ascending order. Basiclly calls sort(objs, true)
	 *
	 * @param objs			The array to sort
	 */
	public static void sort(Object[] objs)
	{
		sort(objs, true);
	}

	/**
	 * Sort a given array of object according to the default comparator
	 * in a given order (ascending/descending).
	 *
	 * @param objs			The array to sort
	 * @param acsending		The direction of the sort (ascending/descending)
	 */
	public static void sort(Object[] objs, final boolean ascending)
	{
		sort(	objs,
				new Comparator()
				{
					public int compare(Object o1, Object o2)
					{
						if (ascending)
							return o1.toString().compareTo(o2.toString());
						else
							return o2.toString().compareTo(o1.toString());
					}
				});
	}

	/**
	 * Sort a given array of object according to the given comparator.
	 *
	 * @param objs			The array to sort
	 * @param comparator	The comparator to sort accoridng to
	 */
	public static void sort(Object[] objs, Comparator comparator)
	{
		Arrays.sort(objs, comparator);
	}


}
