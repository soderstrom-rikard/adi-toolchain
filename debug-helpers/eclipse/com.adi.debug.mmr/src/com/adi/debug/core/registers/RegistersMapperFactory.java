/*
 * Created on 05/11/2003
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.adi.debug.core.registers;

import java.io.FileReader;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.internal.ui.DebugUIPlugin;
import org.eclipse.ui.IMemento;
import org.eclipse.ui.XMLMemento;

/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class RegistersMapperFactory
{
	public static final String ELEMENT_TOP 		= "module";
	public static final String ELEMENT_GROUP 	= "group";
	public static final String ELEMENT_SUB 		= "sub";
	public static final String ELEMENT_TOTAL 	= "total";
	public static final String ELEMENT_REGISTER 	= "register";
	
	public static final String FIELD_TYPE 		= "type";
	public static final String FIELD_NAME 		= "name";
	public static final String FIELD_ADD_TOTAL 	= "addTotal";
	public static final String FIELD_SIZE 		= "size";
	public static final String FIELD_INDEX 		= "index";

	ModuleRegisterMapper mapper;
	
	protected RegistersMapperFactory()
	{
	}
	
	/**
	 * Create a new registers mapper from a given xml file
	 * 
	 * @param location			path for the file
	 * @throws CoreException
	 */
	public IModuleRegistersMapper createRegistersMapper(String location) throws DebugException
	{		
		XMLMemento reader = null;
		try 
		{
			reader =
				XMLMemento.createReadRoot(new FileReader(location));
		} catch (Exception e) 
		{
			DebugUIPlugin.getDefault().logErrorMessage("Failed loading registers from " + location);
		} 	
		
		
		String moduleType = reader.getString(FIELD_TYPE);
		if (moduleType == null)
			DebugUIPlugin.getDefault().logErrorMessage("Failed loading registers from " + location + " module type field missing");
		
		mapper = new ModuleRegisterMapper(moduleType);
		
		IMemento[] groups = reader.getChildren(ELEMENT_GROUP);
		for (int ind=0; ind < groups.length; ind++)
			loadGroup(groups[ind]);
		
		return mapper;
	}
	
	
	/**
	 * Load data for a specific group, given the group memento
	 * @param group	The group memnto
	 */
	private void loadGroup(IMemento group)
	{
		RegistersGroupData groupData = new RegistersGroupData();
		
		// get group name
		String groupName = group.getString(FIELD_NAME);
		if (groupName == null)
			return;
		
		// get group size
		IMemento mem = group.getChild(ELEMENT_TOTAL);
		if (mem == null)
			return;
		
		Integer tempInt = mem.getInteger(FIELD_SIZE);
		if (tempInt == null)
			return;
		
		groupData.totalSize = tempInt.intValue();
		
		// check add total field
		groupData.addTotalField = true;
		String tempStr = mem.getString(FIELD_ADD_TOTAL);
		if (tempStr != null && tempStr.equalsIgnoreCase("false"))
			groupData.addTotalField = false;
		
		// get sub-division
		IMemento[] mems = group.getChildren(ELEMENT_SUB);
		groupData.indicies = new int[mems.length];
		groupData.sizes = new int[mems.length];
		groupData.names = new String[mems.length];
		
		for (int ind=0; ind < mems.length; ind++)
		{
			tempInt = mems[ind].getInteger(FIELD_INDEX);
			if (tempInt == null)
				return;
			groupData.indicies[ind] = tempInt.intValue();

			tempInt = mems[ind].getInteger(FIELD_SIZE);
			if (tempInt == null)
				return;
			groupData.sizes[ind] = tempInt.intValue();

			groupData.names[ind] = mems[ind].getString(FIELD_NAME);
			if (groupData.names[ind] == null)
				return;		
		}
		
		// add group data
		mapper.addGroup(groupName/*, groupData*/);
		
		mems = group.getChildren(ELEMENT_REGISTER);
		String[] register = new String[mems.length];
		
		for (int ind=0; ind < mems.length; ind++)
			register[ind] = mems[ind].getString(FIELD_NAME);
	
		// add registers
		mapper.addRegisters(groupName, register);
	}
}
