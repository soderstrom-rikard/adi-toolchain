/*
 * Created on 05/11/2003
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.adi.debug.core.registers;

import java.util.Arrays;

/**
 * Class which basicly serves as a struct which hold the 
 * information about a certains register gruop: name, size, 
 * sub devision.
 * 
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class RegistersGroupData
{
	public int			totalSize;
	public boolean 		addTotalField;
	public int[] 		sizes;
	public int[]		indicies;
	public String[] 	names;
	public boolean equals(RegistersGroupData other)
	{
		boolean eq = totalSize == other.totalSize;
		eq = Arrays.equals(sizes,other.sizes) && eq;
		eq = Arrays.equals(indicies, other.indicies) && eq;	
		eq = Arrays.equals(names,other.names) && eq;
		return eq;
	}
}
