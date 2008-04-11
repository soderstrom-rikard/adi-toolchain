package com.adi.debug.core.registers;


/**
 * @author Igoryok
 *	interface for abstracting a register access:
 */
public interface IRegisterAccessor
{
	/**
	 * Get the register's value.
	 * @param val the result. the length of val should match the register's size
	 * @return 		REGSTATUS_... 
	 * @see IDSPDebugGeneralConstants
	 */
	public int GetValue(long[] val);
	/**
	 * Sets the register's value
	 * @param val - the value to be set
	 * @return 		REGSTATUS_...
	 * @see IDSPDebugGeneralConstants
	 */
	public int SetValue(long[] val);
	/**
	 * query if the regsiter can be modified
	 * @return true if can be modified
	 */
	public boolean CanModify();
	
}
