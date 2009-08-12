package com.adi.debug.ui.views.mmr;

import org.eclipse.jface.viewers.ISelectionProvider;
import org.eclipse.jface.window.Window;
import org.eclipse.ui.actions.SelectionProviderAction;

import com.adi.debug.core.registers.IModuleRegistersMapper;
import com.adi.debug.core.registers.IRegisterAccessor;
import com.adi.debug.core.registers.MMRAccessor;
import com.adi.debug.core.registers.RegisterDefinition;
import com.adi.debug.core.registers.RegistersGroupData;
import com.adi.debug.core.registers.RegistersMappersManager;

/**
 * @author odcohen
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class DSPChangeRegisterTableAction extends SelectionProviderAction
{
	MMRView view;
	
	public static final int CMD_REMOVE_ALL_TABLE	= 0;
	public static final int CMD_REMOVE_TABLE 		= 1;
	public static final int CMD_REMOVE_REGISTERS 	= 2;
	public static final int CMD_ADD_REGISTERS 		= 3;
	
	int command;
	
	String tableName;

	/**
	 * Constructor for DSPRemoveRegTableAction.
	 * @param provider
	 * @param text
	 */
	public DSPChangeRegisterTableAction(MMRView view, ISelectionProvider provider, String text, int command)
	{
		super(provider, text);
		this.view = view;
		this.command = command;
	}

	protected void setTableName(String name)
	{
		tableName = name;
	}
	
	public void run()
	{
		MMRViewerPage sheet = view.getVisiableSheet();
		
		if (sheet == null)
			return;

		if (command == CMD_REMOVE_ALL_TABLE)
		{
			sheet.removeAllTables();
		}
		else if (command == CMD_REMOVE_TABLE)
		{
			sheet.removeTable(tableName);
		}
		else if (command == CMD_REMOVE_REGISTERS)
		{
			sheet.removeSelectedRows(tableName);
		}
		else if (command == CMD_ADD_REGISTERS)
		{
			DSPAddRegistersDialog 
				dialog = new DSPAddRegistersDialog(sheet.getShell(), RegistersMappersManager.getInstance().getPartNumbers(), 
						sheet.getCurrentProcessorName());

			int ret = dialog.open();
			
			if (ret != Window.OK)
				return;
				
			addRegisters(sheet, dialog.getProcessorName(), dialog.getAddedRegisters());
		}
		
		sheet.statusChanged();
	}
	
	private void addRegisters(MMRViewerPage sheet, String processorName, String[][] registers)
	{
		if (processorName == null || registers == null)
			return;
		
		sheet.setCurrentProcessorName(processorName);
		IModuleRegistersMapper mapper = RegistersMappersManager.getInstance().getRegisterMapper(processorName);
		String[] register;
		RegistersGroupData data;
		for (int ind=0; ind < registers.length; ind++)
		{
			register = registers[ind];
			// get the "group data" by register name:
			data = mapper.getGroupData(register[1]);
			
			if (data == null) continue;
			
			String group = sheet.addTable(register[0], data);
			sheet.addRow(group, register[1], MMRViewerPage.CreateRegisterAccessor(register[1], mapper));
			
		}	
	}

}
