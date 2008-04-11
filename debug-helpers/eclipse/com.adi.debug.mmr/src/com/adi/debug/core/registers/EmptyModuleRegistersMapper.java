/*
 * Created on Aug 17, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.adi.debug.core.registers;

/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class EmptyModuleRegistersMapper implements IModuleRegistersMapper 
{
	String moduleType;
	
	protected EmptyModuleRegistersMapper(String moduleType)
	{
		this.moduleType = moduleType;
	}

	/* (non-Javadoc)
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
		return new String[0];
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.core.registers.IModuleRegistersMapper#getRegisters(java.lang.String)
	 */
	public String[] getRegisters(String groupName) 
	{
		return new String[0];
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.core.registers.IModuleRegistersMapper#getGroupData(java.lang.String)
	 */
	public RegistersGroupData getGroupData(String groupName) 
	{
		return null;
	}

	public RegisterDefinition getRegisterDefinition(String regName) {
		// TODO Auto-generated method stub
		return null;
	}

}
