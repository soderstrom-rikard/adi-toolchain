/*
 * Created on Sep 13, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.adi.debug.core.registers;

import java.io.FileReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.Path;
import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.internal.ui.DebugUIPlugin;
import org.eclipse.ui.IMemento;
import org.eclipse.ui.XMLMemento;


/**
 * @author Igoryok
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class VDSPRegistersMapperFactory {
	
	public static final String FILENAME_TAIL = "-proc.xml";
	/** The structure of the VDSP proc XML file */
	/// the name of the file with core registers description:
	public static final String ELEMENT_THIS_FILE = "visualdsp-proc-xml";	
	public static final String ELEMENT_CORE_FILE = "register-core-file";  
	public static final String ELEMENT_CORE_DEF = "register-core-definitions";
	public static final String ELEMENT_EXTENDED_FILE = "register-extended-file";
	public static final String ELEMENT_EXTENDED_DEF = "register-extended-definitions";
	/// register description:
	public static final String ELEMENT_REGISTER 	= "register";
	/// register Fields:
	public static final String FIELD_NAME 		= "name";
	public static final String FIELD_GROUP		= "group";
	public static final String FIELD_READADDR	= "read-address";
	public static final String FIELD_WRITEADDR	= "write-address";
	public static final String FIELD_MASK	= 	  "mask";
	public static final String FIELD_TYPE 		= "type";
	public static final String FIELD_DESCRIPTION 	= "description";
	public static final String FIELD_SIZE 		= "bit-size";
	public static final String FIELD_PARENT		= "parent";
	public static final String FIELD_POS		="bit-position";

	ModuleRegisterMapper mapper;
	
	HashMap				 VDSPGroups;
	
	
		
	protected VDSPRegistersMapperFactory()
	{
		VDSPGroups = new HashMap();
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
			DebugUIPlugin.getDefault().logErrorMessage("Failed reading from " + location);
		} 	
		
		// get processor family:
		String fileName = reader.getString(FIELD_NAME);
		int tailIndex = fileName.indexOf(FILENAME_TAIL);
		if(tailIndex == -1)
		{
			DebugUIPlugin.getDefault().logErrorMessage("Wrong format VDSP xml file " + location);
			return null;
		}
		
		String moduleType = fileName.substring(0, tailIndex); 
			
		mapper = new ModuleRegisterMapper(moduleType);
		
		// get the path from the location:
		Path xmlPath = new Path(location);
		String pathString = xmlPath.removeLastSegments(1).toOSString() + Path.SEPARATOR;
		
		
		// read core registers definitions:
		String coreRegsFileName = pathString + reader.getChild(ELEMENT_CORE_FILE).getString(FIELD_NAME);
		LoadRegistersDefinitions(coreRegsFileName, ELEMENT_CORE_DEF);
		
		// read extended registers definitions:
		String extendedRegsFileName = pathString + reader.getChild(ELEMENT_EXTENDED_FILE).getString(FIELD_NAME);
		LoadRegistersDefinitions(extendedRegsFileName, ELEMENT_EXTENDED_DEF);

		return mapper;
	}

	/**
	 * Helper for reading registers definitions from a VDSP xml 
	 * @param fileName XML VDSP file name
	 * @param key registers definition tag
	 * @throws DebugException
	 */
	private void LoadRegistersDefinitions(String fileName, String key) throws DebugException
	{
		XMLMemento reader = null;
		try
		{
			reader = XMLMemento.createReadRoot(new FileReader(fileName));
		}catch (Exception e)
		{
			DebugUIPlugin.getDefault().logErrorMessage("Failed loading registers from " + fileName);
		}
		
		IMemento defsRoot = reader.getChild(key);
		IMemento[] xmlDefs = defsRoot.getChildren(ELEMENT_REGISTER);
		int numRegs = xmlDefs.length;
		RegisterDefinition[] defs = new RegisterDefinition[numRegs];
  		for(int i = 0; i < numRegs; i++)
		{
  			defs[i] = new RegisterDefinition();
			defs[i].name = xmlDefs[i].getString(FIELD_NAME);
			defs[i].type = xmlDefs[i].getString(FIELD_TYPE);
			defs[i].description = xmlDefs[i].getString(FIELD_DESCRIPTION);
			defs[i].bitSize = xmlDefs[i].getInteger(FIELD_SIZE).intValue();

			// optional:
  			String tmp = xmlDefs[i].getString(FIELD_PARENT);
			if(tmp != null)
			{
				defs[i].parent = tmp; 
				defs[i].child = true;
			}
			
			tmp = xmlDefs[i].getString(FIELD_GROUP);
			if(tmp != null)
				defs[i].group = tmp;
			
			Integer tmpInt = xmlDefs[i].getInteger(FIELD_POS);
			if(tmpInt != null)
				defs[i].bitPos = tmpInt.intValue();
			

 			/// Not using masks for now.
			tmpInt = xmlDefs[i].getInteger(FIELD_MASK);
			if(tmpInt != null)
				defs[i].mask = tmp;

			tmp = xmlDefs[i].getString(FIELD_READADDR);
			if(tmp != null)
				defs[i].readAddr = tmp;

			tmp = xmlDefs[i].getString(FIELD_WRITEADDR);
			if(tmp != null)
				defs[i].writeAddr = tmp;	
			
			defs[i].memoryMapped = (defs[i].writeAddr.length() != 0 || defs[i].readAddr.length() != 0);

			if(!defs[i].child && defs[i].group.length() == 0)
				defs[i].group = defs[i].name;

			
			AddRegToGroup(defs[i]);
		}

  		//	Create orion-style groups
		ProcessGroups();
		// 	also store all the architectural registers definitions in the mapper
		mapper.addRegisterDefinitions(defs);
	}
	
	private void AddParent(Vector g, RegisterDefinition parent)
	{
		g.add(parent);
	}
	
	private void AddChild(Vector g, RegisterDefinition child)
	{
		// find parent:
		boolean orphan = true;
		RegisterDefinition register = null;
		int i = 0;
		for(; i < g.size(); i++ )
		{
			register = (RegisterDefinition)g.elementAt(i); 
			orphan = !register.name.equals(child.parent);
			if(!orphan)
				break;
		}

		if(!orphan)
		{
			child.name = ChildFirstName(child);
			register.children.add(child);
			g.setElementAt(register,i);
		}
		// process error. parents should be defined before children.
		// TODO error processing here.
	}
	
	private void AddRegToGroup(RegisterDefinition def)
	{
		Vector vgroup = null;
		if(def.group.length() != 0)
		{
			//	Check if the group has been created:
			if(!VDSPGroups.containsKey(def.group))
			{
				vgroup = new Vector();
				VDSPGroups.put(def.group, vgroup);
			}
			else
				vgroup = (Vector)VDSPGroups.get(def.group);

			if(def.child)
				AddChild(vgroup, def);
			else
				AddParent(vgroup, def);
		}
		else
		{
			// no group, if child, iterate through all groups and find the parent:
			for(Iterator it = VDSPGroups.entrySet().iterator(); it.hasNext();)
			{
				Map.Entry e = (Map.Entry)it.next();
				Vector regs = (Vector)e.getValue();
				AddChild(regs,def);
			}
		}
	}
	
	
	private String ChildFirstName(RegisterDefinition def)
	{
		if(def.name.startsWith(def.parent))
			return def.name.substring(def.parent.length());
		else
			return def.name;
	}
	
	/**
	 * Check if the register can be represented in the group
	 * 
	 * @param r
	 * @param g
	 * @return
	 */
/*
	private boolean CheckRegister(RegistersGroupData g, VDSPRegister r)
	{
		// check total bitsize & number of children:
		boolean match = (r.children.size() == g.names.length);

		// check children - positions, sizes and names:
		for(int i = 0; (i < g.names.length) && match; i++)
		{
			RegisterDefinition child = (RegisterDefinition)r.children.get(i);
			
			match = child.bitPos == g.indicies[i] &&
					child.bitSize == g.sizes[i] &&
					ChildFirstName(child).equals(g.names[i]);
		}
		return match;
	}
*/	
/*
	private void CreateGroup(RegistersGroupData d, VDSPRegister reg)
	{
		// get the first regsiter in the group and fill in the group data:
		d.totalSize = reg.parent.bitSize;
		d.addTotalField = true;
		
		int numChildren = reg.children.size();
		d.indicies = new int[numChildren];
		d.sizes = new int [numChildren];
		d.names = new String[numChildren];
		for(int i = 0; i < numChildren; i++)
		{
			RegisterDefinition child = (RegisterDefinition)reg.children.elementAt(i); 
			d.indicies[i] = child.bitPos;
			d.sizes[i] = child.bitSize;
			d.names[i] = ChildFirstName(child);
		}
	}
	*/
	private void ProcessGroups()
	{
		//	Go over groups. fill in the group data
		for(Iterator it = VDSPGroups.entrySet().iterator(); it.hasNext();)
		{
			Map.Entry e = (Map.Entry)it.next();
			String groupName = (String)e.getKey();
			Vector regs = (Vector)e.getValue();
/*
			RegistersGroupData data = new RegistersGroupData();

			int VDSPGroupSize = regs.size(); 
			CreateGroup(data,(VDSPRegister)regs.firstElement());

			Vector grouped = new Vector();
			for(int i = 0; i < regs.size(); i++)
			{
				VDSPRegister r = (VDSPRegister)regs.elementAt(i); 
				//	Adjust total bit size:
				data.totalSize = Math.max(data.totalSize, r.parent.bitSize);
				if(CheckRegister(data,r))
				{
					grouped.add(r.parent.name);
				}
				else
				{
					//	Create a special group for the register
					//	(named as the register itself) and add it:
					RegistersGroupData singleGroup = new RegistersGroupData();
					CreateGroup(singleGroup, r);
					String[] singleName = new String[1];
					singleName[0] = new String(r.parent.name);
					mapper.addGroup(r.parent.name, singleGroup);
					mapper.addRegisters(r.parent.name, singleName);
				}
			}
	*/
			int size = regs.size();
			String[] regsInGroup = new String[size]; 
			for(int i = 0; i < size; i++)
				regsInGroup[i] = ((RegisterDefinition)regs.elementAt(i)).name;
			mapper.addGroup(groupName);
			mapper.addRegisters(groupName, regsInGroup);
		}
	}
	
}
