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
package com.analog.gnu.debug.ui.views.mmr;

import java.math.BigInteger;

import org.eclipse.core.runtime.Assert;

import com.analog.gnu.debug.IDSPDebugGeneralConstants;
import com.analog.gnu.debug.core.registers.IRegisterAccessor;
import com.analog.gnu.debug.core.registers.RegistersGroupData;
import com.analog.gnu.debug.ui.views.ValueViewUtils;

/**
 * @author odcohen
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class DSPRegTableRow
{
	/**
	 * The name of the register
	 */
	String 	registerName;

	/**
	 * The starting indicies of the partial values of the register
	 */
	int[]	indicies;

	/**
	 * The sizes (in bits) of the  partial values of the register
	 */
	int[] 	sizes;

	/**
	 * determine the status of the value of the register
	 * REGSTATUS_OK ; // register value was red and is valid
	 * REGSTATUS_X_VALUE ; // register value was red and is undefined( xxxxxx )
	 * REGSTATUS_NOT_IN_PLATFORM ; // register does not exist in platform
	 */
	int registerValueStatus;

	/**
	 * The total size of the register (in bits)
	 */
	int 	totalSize;

	/**
	 * The size of the register in 32 bits units.
	 */
	int numberOf32bits;

	/**
	 * The total value of the register
	 */
	BigInteger	totalValue;

	/**
	 * Flag to determine whether a total value column is needed
	 */
	boolean 	totalFieldExists;

	/**
	 * The radiz base for displaying the values
	 */
	int base = ValueViewUtils.HEXA;


	/**
	 *  The access to the register - get/set
	 */
	IRegisterAccessor	accessor;
	/**
	  * The contructor
	  * @param registerName		The register name
	  * @param desc				The register description
	  */
	public DSPRegTableRow(String registerName, RegistersGroupData desc, IRegisterAccessor access)
	{
		this.registerName 	= registerName;
		this.totalSize = desc.totalSize;
		this.sizes		= desc.sizes;
		this.indicies 	= desc.indicies;
		this.totalFieldExists = desc.addTotalField;
		this.numberOf32bits = totalSize / 32;

		if (totalSize % 32 > 0)
			this.numberOf32bits++;

		totalValue = BigInteger.valueOf(0);
		this.registerValueStatus = IDSPDebugGeneralConstants.REGSTATUS_X_VALUE;
		this.accessor = access;
	}

	/**
	 * Sets the toal value of the register
	 * @param value	The new value
	 * return	true if there was a change in value
	 */
	private boolean setTotalValue(BigInteger value)
	{
		BigInteger oldValue = totalValue;

		totalValue = value;

		return oldValue.compareTo(totalValue) != 0;
	}

	/**
	 * Sets the toal value of the register
	 * @param value	The new value
	 * return	true if there was a change in value
	 */
	public boolean setTotalValue(long[] value)
	{
		BigInteger oldValue = totalValue;
		totalValue = BigInteger.valueOf(0);

		for (int ind=0; ind < value.length; ind++)
		{
			totalValue = totalValue.or(
						BigInteger.valueOf(value[ind] & 0xFFFFFFFFL).shiftLeft(32*ind));
		}

		return oldValue.compareTo(totalValue) != 0;
	}

	/**
	 * Gets the total value of the register (as long array)
	 * @return The total value
	 */
	public long[] getTotalValue()
	{
		long[] value = new long[numberOf32bits];
		BigInteger temp = totalValue;

		for (int ind=0; ind < value.length; ind++)
		{
			value[ind] = temp.and(BigInteger.valueOf(0xFFFFFFFF)).longValue();
			temp = temp.shiftRight(32);
		}

		return value;
	}

	/**
	 * Gets the total value as a BigInteger
	 * @return	The value as a BigInteger
	 */
	public BigInteger getBigTotalValue()
	{
		return totalValue;
	}

	/**
	 * Return the partial value for a given column index
	 * @param index	The column index
	 * @return	The partial value
	 */
	private long getPartialValue(int index)
	{
		// We create the new number bit by bit
		BigInteger partial = BigInteger.valueOf(0);
		for (int ind=0; ind < sizes[index]; ind++)
		{
			if (totalValue.testBit(indicies[index] + ind))
				partial = partial.setBit(ind);
		}

		return partial.longValue();
	}

	/**
	 * Sets the partial value of the register according to a given column
	 * @param index		The column index of the partial value
	 * @param value		The new partial value
	 */
	private void setPartialValue(int index, long value)
	{
		// Create the new partial value (mask high values)
		BigInteger partial = BigInteger.valueOf(value);
		int bitLength = partial.bitLength();
		if (bitLength > sizes[index])
		{
			for (int ind = sizes[index]; ind < bitLength; ind++)
				partial = partial.clearBit(ind);
		}

		// Shift it to its right location
		partial = partial.shiftLeft(indicies[index]);

		// Clear its window in the original value
		for (int ind=indicies[index]; ind < (sizes[index]+indicies[index]); ind++)
			totalValue = totalValue.clearBit(ind);

		// Set the new window
		totalValue = totalValue.or(partial);
	}

	/**
	 * Set the row value in a particulat data column. If the given
	 * index is equal or less than 0 sets the total value of the row
	 *
	 * @param index	The column number
	 * @param str	The data
	 * @return	True if the value was changed successfully
	 */
	public boolean setPartialValue(int index, String str)
	{
		int size = index < 0 || sizes.length == 0 ? totalSize : sizes[index];
		BigInteger newValue = null;
		try
		{
			newValue = ValueViewUtils.getValue(str,size, base);
		} catch (NumberFormatException e)
		{
			return false;
		}

		if (index >= sizes.length || index < 0)
			setTotalValue(newValue);
		else
			setPartialValue(index, newValue.longValue());

		return true;
	}

	/**
	 * Returns the display string of a given column
	 * @param index The coulmn number
	 * @return The display string
	 */
	public String getColumnText(int index)
	{
		if (index == 0)
			return registerName;

		if (totalFieldExists)
			index-=2;
		else
			index-=1;

		int size = index < 0 || sizes.length == 0 ? totalSize : sizes[index];

		// calculating view size
		int viewSize = ValueViewUtils.translateBits2Digits(size, base);

		switch ( getRegisterValueStatus() ) {
			case IDSPDebugGeneralConstants.REGSTATUS_NOT_IN_PLATFORM:
				StringBuffer ndef = new StringBuffer();
				for (int ind=0; ind < viewSize; ind++)
					ndef.append("-");
				return ndef.toString();

			case IDSPDebugGeneralConstants.REGSTATUS_X_VALUE:
				StringBuffer val = new StringBuffer();
				for (int ind=0; ind < viewSize; ind++)
					val.append("X");
				return val.toString();

			case IDSPDebugGeneralConstants.REGSTATUS_OK:
				if (size == totalSize)
					return ValueViewUtils.getFormatedString(totalValue, base, size, false);
				else
					return ValueViewUtils.getFormatedString((int)getPartialValue(index), base, size, false);

			default: // should never happen. However, 'never' sometime comes...
				Assert.isTrue( false, "reached default is switch" ) ;
				return "" ;
		}
	}

	/**
	 * Sets the diaply radix mode of the row
	 * @param base	The new radix base
	 */
	public void setBase(int base)
	{
		this.base = base;
	}

	/**
	 * Returns the size of the register in 32 bits units
	 * @return	The number of 32 bits units
	 */
	public int getNumberOf32bits()
	{
		return numberOf32bits;
	}

	/**
	 * Returns a string properties values for a given number of columns.
	 * @param columns	The number of columns required
	 * @return	an array of string properties
	 */
	public static String[] getProperties(int columns)
	{
		String[] properties = new String[columns];

		for (int ind=0; ind < columns; ind++)
			properties[ind] = String.valueOf(ind);

		return properties;
	}

	/**
	 * convert a property string name to a column number
	 * @param property	The property name
	 * @return	the column number (-1 if property is not valid)
	 */
	public int propertyToColumn(String property)
	{
		int column = -1;
		try
		{
			column = Integer.parseInt(property, 10);
		} catch (NumberFormatException e)
		{
		}

		return column;
	}

	protected boolean updateItem()
	{
		if(accessor == null)
			return false;

		long[]	value = new long[getNumberOf32bits()];
		long 	partialValue;
		int res = accessor.GetValue(value);

		boolean change = false;
		if (res == IDSPDebugGeneralConstants.REGSTATUS_OK)
			change = setTotalValue(value);

		// whatever the status is, we just copy it to the row so the viewer will deal with it.
		setRegisterValueStatus( res );
		return change;
	}

	protected boolean modifyItem()
	{
		if(accessor != null)
			return accessor.SetValue(getTotalValue()) == IDSPDebugGeneralConstants.REGSTATUS_OK;
		else
			return false;
	}


	/**
	 * return the string valud of a specific column in the row, according
	 * to the property name of the column.
	 *
	 * @param property	The property name of the column
	 * @return	the string value (or null if property is not valid)
	 */
	public int propertyToDataColumn(String property)
	{
		return propertyToColumn(property) - (totalFieldExists ? 2 : 1);
	}

	/**
	 * returns the number of data columns
	 * @return	the number
	 */
	public int getDataColumns()
	{
		return sizes.length + (totalFieldExists ? 1:0);
	}
	/**
	 * @return
	 */
	public int getRegisterValueStatus() {
		return registerValueStatus;
	}

	/**
	 * @param i
	 */
	public void setRegisterValueStatus(int i) {
		registerValueStatus = i;
	}

	/*
	 *  (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString()
	{
		return getColumnText(0);
	}


	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object obj)
	{
		return 	(obj instanceof DSPRegTableRow) &&
				(toString().equalsIgnoreCase(obj.toString()));
	}

}
