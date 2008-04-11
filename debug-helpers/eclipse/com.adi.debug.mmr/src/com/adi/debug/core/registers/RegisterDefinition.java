package com.adi.debug.core.registers;

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
