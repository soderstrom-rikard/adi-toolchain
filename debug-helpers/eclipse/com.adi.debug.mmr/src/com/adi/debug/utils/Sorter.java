package com.adi.debug.utils;
/*
 * Created on 14/03/2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

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
