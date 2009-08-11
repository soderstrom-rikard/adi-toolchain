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
package com.analog.gnu.debug.core.registers;

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
