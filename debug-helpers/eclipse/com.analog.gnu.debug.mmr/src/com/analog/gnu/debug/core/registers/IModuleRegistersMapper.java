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

/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public interface IModuleRegistersMapper
{
	/**
	 * Returns the module type to which this mapper belongs (e.g. RhineDsp)
	 * @return	The module type
	 */
	public String getModuleType();

	/**
	 * Getting register group names for a specific module
	 * @return string array of all register groups
	 * 			(or empty array if non was found)
	 */
	public String[] getRegisterGroups();

	/**
	 * Getting registers names for a given group in a given module
	 * @param groupName		The group name
	 * @return string array of all registers names
	 * 			(or empty array if non was found)
	 */
	public String[] getRegisters(String groupName);

	/**
	 * Getting the properties of a given registers gruop in a given module
	 * @param groupName		The group name
	 * @return a RegistersGroupData (or null if non was found)
	 */
	public RegistersGroupData getGroupData(String groupName);

	/**
	 * Getting the architectural(not a part) register definition by name
	 * @param regName	a register's name
	 * @return complete register definition
	 */
	public RegisterDefinition getRegisterDefinition(String regName);

}
