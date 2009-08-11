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

import java.math.BigInteger;

import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.IMemoryBlockManager;
import org.eclipse.debug.core.model.IDebugTarget;
import org.eclipse.debug.core.model.IMemoryBlock;
import org.eclipse.debug.core.model.IMemoryBlockExtension;
import org.eclipse.debug.core.model.IMemoryBlockRetrieval;
import org.eclipse.debug.core.model.IMemoryBlockRetrievalExtension;
import org.eclipse.debug.core.model.MemoryByte;
import org.eclipse.debug.internal.ui.views.memory.MemoryViewUtil;
import org.eclipse.debug.ui.DebugUITools;

import com.analog.gnu.debug.IDSPDebugGeneralConstants;

public class MMRAccessor implements IRegisterAccessor
{
	static final int LongSIZE = 64;
	static final int ByteSIZE = 8;
	static final int BYTES_PER_LONG = LongSIZE / ByteSIZE;
	static final char ByteMask = 0x00ff;
	String name;
	String readAddr;
	String writeAddr;
	int bitSize;

	BigInteger readAddress;
	BigInteger writeAddress;
	int locationsPerRegister;
	int bytesPerRegister;
	BigInteger mask;

	//	if read and write addresses are the same, the blocks are the same
	IMemoryBlockExtension readMemBlock;
	IMemoryBlockExtension writeMemBlock;
	IMemoryBlock[] memArray;

	public MMRAccessor()
	{
	}

	protected void Init(RegisterDefinition regDef)
	{
		name = regDef.name;
		bitSize = regDef.bitSize;
		bytesPerRegister = regDef.bitSize/ByteSIZE;
		locationsPerRegister = bytesPerRegister;	// mostly-sane default in case Refresh() below bombs
		readAddr = regDef.readAddr;
		writeAddr = regDef.writeAddr;
		mask = new BigInteger(regDef.mask, 16);
		memArray = null;
	}

	public MMRAccessor(RegisterDefinition regDef)
	{
		Init(regDef);
		Refresh();
	}

	public void Refresh()
	{
		//DebugPlugin plugin = DebugPlugin.getDefault();
		//IMemoryBlockManager memBlockManager = plugin.getMemoryBlockManager();
		Object context = DebugUITools.getDebugContext();
		IMemoryBlockRetrieval retrieval = MemoryViewUtil.getMemoryBlockRetrieval(context);
		if(retrieval instanceof IMemoryBlockRetrievalExtension)
		{
			IMemoryBlockRetrievalExtension memRetrieval = (IMemoryBlockRetrievalExtension)retrieval;
			try
			{
				// get extended memory block with the expression entered
				readMemBlock = memRetrieval.getExtendedMemoryBlock(readAddr, context);

				if(readAddr.compareToIgnoreCase(writeAddr) == 0)
				{
					writeMemBlock = readMemBlock;
					if (readMemBlock != null)
						memArray = new IMemoryBlock[]{readMemBlock};

				}
				else
					writeMemBlock = memRetrieval.getExtendedMemoryBlock(writeAddr, context);

				readAddress = readMemBlock.getBigBaseAddress();
				writeAddress = writeMemBlock.getBigBaseAddress();
				// FIXME: this getAddressableSize() doesnt work with gnICE:
				//   gdb  99-data-read-memory 4290773504 x 1 1 100
				//   gdb  99^error,msg="Unable to read memory."
				//   ice  error:     bfin: [0] bad MMR size [0xFFC00200] size 0
				int size = readMemBlock.getAddressableSize();
				if(size != 0)
					locationsPerRegister = bitSize/(size*ByteSIZE);
				else
				{
					locationsPerRegister = 1;
					System.err.println("MEMORY SIZE is 0 for " + name);
				}

			}
			catch(DebugException e)
			{
				System.err.println("BAD MEMBLOCK FOR " + name);
			}
		}

	}

	public boolean CanModify()
	{
		return true;
	}

	public int GetValue(long[] val)
	{
		// TODO deal with the memory width !!!
		long numItems = locationsPerRegister;
		MemoryByte[] bytes = null;
		if(readMemBlock == null)
		{
			Refresh();
			if(readMemBlock == null)
				return IDSPDebugGeneralConstants.REGSTATUS_NOT_IN_PLATFORM;
		}

		try
		{
			bytes = readMemBlock.getBytesFromAddress(readAddress, numItems);
		}
		catch(DebugException e)
		{
			System.err.println("Could not read memory for " + name + "@0x" + readAddress.toString(16) + " (" + numItems + " blocks)");
		}

		if(bytes == null)
			return IDSPDebugGeneralConstants.REGSTATUS_NOT_IN_PLATFORM;

		int k = bytes.length - 1;
		for(int i = 0; i < val.length && k >= 0; i++)
		{
			val[i] = 0;
			for(int j = 0; j < BYTES_PER_LONG; j++)
			{
				char b = (char) ((char)(bytes[k--].getValue()) & ByteMask);
				val[i] = (val[i] << 8) | b;
				if(k < 0)
					break;
			}
		}
		// TODO Fix the applying of the mask;
		val[0] = val[0] & mask.longValue();
		return IDSPDebugGeneralConstants.REGSTATUS_OK;

	}

	public int SetValue(long[] val)
	{
		if(writeMemBlock == null)
		{
			Refresh();
			if(writeMemBlock == null)
				return IDSPDebugGeneralConstants.REGSTATUS_NOT_IN_PLATFORM;
		}

		byte bytes[] = new byte[bytesPerRegister];
		int k = 0;
		// TODO Fix applying mask.
		val[0] = val[0] & mask.longValue();
		for(int i = 0; i < val.length && k < bytesPerRegister; i++)
		{
			for(int j = 0; j < BYTES_PER_LONG; j++)
			{
				bytes[k++] = ((byte)(val[i] & 0xFF));
				val[i] >>= 8;
				if(k >= bytesPerRegister)
					break;
			}
		}
		try
		{
			// try to modify the value:
			writeMemBlock.setValue(BigInteger.ZERO/*offset*/, bytes);
		}
		catch(DebugException e)
		{
			System.err.println("Could not write memory for " + name + "@0x" + writeAddress.toString(16));
		}

		return IDSPDebugGeneralConstants.REGSTATUS_OK;
	}

}
