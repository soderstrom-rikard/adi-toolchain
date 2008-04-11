/*
 * Created on 05/11/2003
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.adi.debug.core.registers;

import java.io.File;
import java.io.FileReader;
import java.io.FilenameFilter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;

import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.internal.ui.DebugUIPlugin;
import org.eclipse.ui.XMLMemento;

import com.adi.debug.IDSPDebugGeneralConstants;

/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class RegistersMappersManager 
{
	// TODO temporary replacement for VDSP:
	VDSPRegistersMapperFactory factory;
	
	// this manager saves only one project type registeres mapping
	String lastLocation;
	
	HashMap 	mappers;
	String[]	partNumbersArray;
	
	// a list of part numbers:
	HashMap	partNumbers;
	
	static RegistersMappersManager instance = null;
	
	/**
	 * private constructor to maintain singletone behavior
	 */
	private RegistersMappersManager() 
	{
		mappers = new HashMap();
		partNumbers = new HashMap();
		
		// TODO temporary replacement for VDSP:
		factory = new VDSPRegistersMapperFactory();
		lastLocation = "";
	}
	
	/**
	 * Getting the single tone instance
	 * @return	the single tone instance
	 */
	public static RegistersMappersManager getInstance()
	{
		if (instance == null)
			instance = new RegistersMappersManager();
		
		return instance;
	}
	
	/**
	 * Loads all relevant registers mapper according to the given
	 * folder path (which contains the xml file descriptors)
	 * @param folderPath	The folder path
	 * 
	 */
	public void loadMappers(String folderPath)
	{
		if (lastLocation.equalsIgnoreCase(folderPath))
			return;
		
		lastLocation = folderPath;
		mappers.clear();
				
		// get all xml descriptor files found in the registers folder
		IPath path = Path.ROOT;
		path = path.append(folderPath);
		path = path.append(IDSPDebugGeneralConstants.CONF_REGISTERS_PATH);

		File folder = new File(path.toOSString());
	
		if (!folder.exists() || !folder.isDirectory())
			return;
	
		// filtering the relevant xml files
		FilenameFilter filter = new FilenameFilter()
		{
			public boolean accept(File dir, String name) 
			{
				return name.toLowerCase().endsWith("proc.xml");
			}
		};
		

		// go over all files descriptors and map them
		String[] files = folder.list(filter);
		for (int ind=0; ind < files.length; ind++)
			addPartNumber(path.append(files[ind]).toString());
		
		partNumbersArray = new String[partNumbers.size()]; 
		int i = 0;
		for(Iterator it = partNumbers.entrySet().iterator(); it.hasNext();)
		{
			Map.Entry e = (Map.Entry)it.next();
			partNumbersArray[i++] = (String)e.getKey();
		}
		
	}

	protected void addPartNumber(String procDefXML)
	{
		XMLMemento reader = null;
		try 
		{
			reader =
				XMLMemento.createReadRoot(new FileReader(procDefXML));
		} catch (Exception e) 
		{
			DebugUIPlugin.getDefault().logErrorMessage("Failed reading from " + procDefXML);
		} 	
		
		// get processor family:
		String fileName = reader.getString(VDSPRegistersMapperFactory.FIELD_NAME);
		int tailIndex = fileName.indexOf(VDSPRegistersMapperFactory.FILENAME_TAIL);
		if(tailIndex == -1)
		{
			DebugUIPlugin.getDefault().logErrorMessage("Wrong format VDSP xml file " + procDefXML);
			return;
		}
		
		String partNumber = fileName.substring(0, tailIndex);
		partNumbers.put(partNumber, procDefXML);

	}
	/**
	 * Adds a register mapper for a specific module type
	 * @param mapper		The new mapper
	 * @param moduleType	The module type
	 */
	protected void addRegisterMapper(IModuleRegistersMapper mapper)
	{
		mappers.put(mapper.getModuleType(), mapper);
	}
	
	public String[] getPartNumbers()
	{
		return partNumbersArray;
	}
	
	/**
	 * Returns a register mapper for a specific device number
	 * @param moduleType	The module type
	 * @return	register mapper (or empty mapper if non was found)
	 */
	public IModuleRegistersMapper getRegisterMapper(String moduleType)
	{
		if (!mappers.containsKey(moduleType))
		{
			// produce the location:
			IModuleRegistersMapper mapper = null;
			String location = (String)partNumbers.get(moduleType);
			try
			{
				mapper = factory.createRegistersMapper(location); 
			}
			catch (DebugException e)
			{
				DebugUIPlugin.getDefault().logErrorMessage("Failed reading from " + location);
				mapper = new EmptyModuleRegistersMapper(moduleType);
			}
			addRegisterMapper(mapper);
			return mapper;
		}
		else
			return (IModuleRegistersMapper)mappers.get(moduleType);
	}
	
	/**
	 * Checks if the given module type has a register mapper 
	 * @param moduleType	The module type
	 * @return	true if mapper is found
	 */
	public boolean isRegistersSupported(String moduleType)
	{
		return mappers.containsKey(moduleType);
	}
}
