/*
 * Created on Aug 17, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.adi.debug.core.registers;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;

/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ModuleRegisterMapper implements IModuleRegistersMapper 
{
	String moduleType;
	
	// groups:
	HashSet groups;
	HashMap registersMap;
	HashMap dataMap;

	// registers
	HashMap allRegsByName;
	
	public ModuleRegisterMapper(String moduleType)
	{
		this.moduleType = moduleType;
		registersMap 	= new HashMap(); 
		dataMap			= new HashMap();
		groups 			= new HashSet();
		allRegsByName = new HashMap();
	}

	/*
	 *  (non-Javadoc)
	 * @see com.adi.dsp.debug.core.registers.IModuleRegistersMapper#getModuleType()
	 */
	public String getModuleType()
	{
		return moduleType;
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.core.registers.IModuleRegistersMapper#getRegisterGroups()
	 */
	public String[] getRegisterGroups() 
	{
		return (String[])groups.toArray(new String[groups.size()]);
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.core.registers.IModuleRegistersMapper#getRegisters(java.lang.String)
	 */
	public String[] getRegisters(String groupName) 
	{
		if (!registersMap.containsKey(groupName)) 
			return new String[0];
		
		return (String[])registersMap.get(groupName);
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.core.registers.IModuleRegistersMapper#getGroupData(java.lang.String)
	 */
	public RegistersGroupData getGroupData(String registerName) 
	{
		if (!allRegsByName.containsKey(registerName)) 
			return null;
		
		RegisterDefinition reg = (RegisterDefinition)allRegsByName.get(registerName);
		RegistersGroupData regGroupData = new RegistersGroupData();
		regGroupData.totalSize = reg.bitSize;
		regGroupData.addTotalField = true;
		int numChildren = reg.children.size();
		
		Collections.sort(reg.children, new Comparator()
		{
			public int compare(Object o1, Object o2)
			{
				return ((RegisterDefinition)o2).bitPos - ((RegisterDefinition)o1).bitPos; 
			}
		});
		
		regGroupData.names = new String[numChildren];
		regGroupData.indicies = new int[numChildren];
		regGroupData.sizes = new int[numChildren];
		int j = 0;
		for(Iterator i = reg.children.iterator(); i.hasNext();)
		{
			RegisterDefinition child = (RegisterDefinition)i.next();
			regGroupData.names[j] = child.name+'('+ Integer.toString(child.bitSize)+ ')';
			regGroupData.indicies[j] = child.bitPos;
			regGroupData.sizes[j] = child.bitSize;
			j++;
		}
		return regGroupData;
	}

	public RegisterDefinition getRegisterDefinition(String regName)
	{
		if(!allRegsByName.containsKey(regName))
			return null;
		return (RegisterDefinition)allRegsByName.get(regName);
	}

	
	protected boolean addGroup(String groupName/*, RegistersGroupData groupData*/)
	{
		if (dataMap.containsKey(groupName))
			return false;
			
		// add group data
		groups.add(groupName);
		///dataMap.put(groupName, groupData);
		return true;
	}
	
	protected boolean addRegisters(String groupName, String[] registers)
	{
		if (!groups.contains(groupName))
			return false;
		
		registersMap.put(groupName, registers);
		return true;
	}

	protected void addRegisterDefinitions(RegisterDefinition[] regDefs)
	{
		for(int i = 0; i < regDefs.length; i++)
		{
			if(!regDefs[i].child)
				allRegsByName.put(regDefs[i].name, regDefs[i]);
		}
	}

}
