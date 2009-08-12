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

import java.util.ArrayList;

public class RegisterDefinition
{
	public String 	name;
	public String 	group;
	public String 	type;
	public String 	description;
	public String 	parent;
	public boolean child;
	public int		bitSize;
	public int 		bitPos;
	public String		mask;
	public boolean		memoryMapped;
	public String		readAddr;
	public String 		writeAddr;

	ArrayList				children;
	public RegisterDefinition()
	{
		name = new String();
		group = new String();
		type = new String();
		description = new String();
		parent = new String();
		child = false;
		bitSize = 0;
		bitPos = -1;
		mask = new String("FFFFFFFF");
		memoryMapped = false;
		readAddr = new String();
		writeAddr = new String();

		children = new ArrayList();
	}

}
