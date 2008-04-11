package com.adi.debug.ui.views.mmr;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Vector;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.jface.viewers.CellEditor;
import org.eclipse.jface.viewers.ICellModifier;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.jface.viewers.TextCellEditor;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.KeyListener;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Item;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;

import com.adi.debug.core.registers.IModuleRegistersMapper;
import com.adi.debug.core.registers.IRegisterAccessor;
import com.adi.debug.core.registers.MMRAccessor;
import com.adi.debug.core.registers.RegisterDefinition;
import com.adi.debug.core.registers.RegistersGroupData;
import com.adi.debug.core.registers.RegistersMappersManager;
import com.adi.debug.ui.views.DSPViewerPage;
import com.adi.debug.ui.views.IColorConstants;
import com.adi.debug.ui.views.ValueViewUtils;
import com.adi.debug.utils.Sorter;

/**
 * @author odcohen
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class MMRViewerPage extends DSPViewerPage
	implements KeyListener
{
	private static final String ATT_REGISTER_VIEW_PREFIX = "com.adi.debug.ui.views.mmr.";
	
	// for saving persistance data
	private static final String ATT_PART_NUMBER = "processor";
	private static final String PART_NUMBER_UNKNOWN = "UNKNOWN";
	private static final String ATT_TABLES = "tables";
	private static final String ATT_VIEW_BASE = "viewBase";
	private static final String ATT_NEW_TABLE_SEPERATOR = "###";
	
	// for saving table properties
	private static final String TABLE_NAME 	= "TableName";
	private static final String TABLE_DESC 	= "TableDescription";
	
	String 		processorName;
	HashMap		regAccessorMap;
	LinkedHashMap tablesMap;

	int baseMode;
	Composite innerComposite;
	ScrolledComposite scrollComposite;
	
	MMRView	view;	
	
	// Focus handling
	Listener 	focusHandler;
	Table		focusedTable;

	/**
	 * @param parent
	 * @param view
	 * @param deviceID
	 * @param deviceNumber
	 */
	public MMRViewerPage(Composite parent, MMRView view)
	{
		super(parent, SWT.NONE);
		this.view = view;
		baseMode = ValueViewUtils.HEXA;
		regAccessorMap = new HashMap();
		processorName = new String("UNKNOWN");
		initGraphics();
		loadState();
	}
	
	private void initGraphics()
	{
		tablesMap = new LinkedHashMap();
		
		setLayout(new FillLayout());
		scrollComposite = new ScrolledComposite(this, SWT.V_SCROLL | SWT.H_SCROLL);
		scrollComposite.setBackground(IColorConstants.BACKGROUND_COLOR);
		
		innerComposite = new Composite(scrollComposite, SWT.NONE);
		innerComposite.setBackground(IColorConstants.BACKGROUND_COLOR);
		scrollComposite.setContent(innerComposite);
		MultiTableLayout multiTableLayout = new MultiTableLayout();
		multiTableLayout.spacing = 5;
		multiTableLayout.wrap 	= true;
		multiTableLayout.pack 	= true;
		innerComposite.setLayout(multiTableLayout);

		getParent().addListener(SWT.Resize, new Listener()
		{

			public void handleEvent(Event event)
			{
				Display.getDefault().asyncExec(new Runnable()
				{
					public void run()
					{
						updateUI();
					}
				});
			}
		});

		focusHandler = new Listener()
		{
			public void handleEvent(Event event)
			{
				Iterator iter = tablesMap.values().iterator();
				Table table;
				boolean noTableSelected = true;
		
				focusedTable = null;
				while (iter.hasNext())
				{
					table = ((TableViewer)iter.next()).getTable();
					if (table == event.widget)
					{
						table.forceFocus();
						noTableSelected = false;
						focusedTable = table;
					}
					else
						table.deselectAll();
				}
		
				if (noTableSelected)
					innerComposite.forceFocus();
			}
		};

		innerComposite.addListener(SWT.MouseDown, focusHandler);
		scrollComposite.addListener(SWT.MouseDown, focusHandler);
		scrollComposite.addMouseListener(view);
		innerComposite.addMouseListener(view);
	}

	protected String getCurrentProcessorName()
	{
		return processorName;
	}

	protected void setCurrentProcessorName(String pn)
	{
		processorName = pn;
	}

	protected String addTable(String tableSuggestedName, RegistersGroupData desc)
	{
		// make sure the desc actaully fits the existing data for the table.
		// if yes, register will be added to the table,
		// if no, a new group should be created and it's name returned.
		String tableName = tableSuggestedName;
		int i = 1;
		while (tablesMap.containsKey(tableName))
		{
			TableViewer viewer = (TableViewer)tablesMap.get(tableName);
			RegistersGroupData tableDesc =  (RegistersGroupData)viewer.getTable().getData(TABLE_DESC); 
			if(tableDesc.equals(desc))
				// OK. matching descriptions.
				return tableName;
			else
				tableName = tableSuggestedName + '(' + (i++) + ')';
		}
		
		//if (columnNames.length != sizes.length ) return;
		
		Table table = new Table(innerComposite, SWT.BORDER | SWT.MULTI | SWT.FULL_SELECTION);
		table.setHeaderVisible(true);
		table.setLinesVisible(true);
		table.setBackground(IColorConstants.BACKGROUND_COLOR);
		table.setForeground(IColorConstants.DATA_COLOR);
		table.addListener(SWT.MouseDown, focusHandler);
		
		final TableViewer tableViewer = new TableViewer(table);
		tableViewer.setContentProvider(new DSPRegTableContentProvider());
		tableViewer.setLabelProvider(new DSPRegTableLableProvider());
		tableViewer.setInput(new Vector());
				
		tableViewer.setCellModifier(new ICellModifier() 
		{
			public boolean canModify (Object element, String property) 
			{
/**
	TODO Check for read-only registers
		
				if (getDebugPlatform() == null)
					return false;
				
				DSPRegTableRow row = (DSPRegTableRow) element;
				
				return  getDebugPlatform().canSetRegister(getDeviceInfo().getIndex(), row.registerName) &&
						row.propertyToColumn(property) > 0;
*/
				return true;
			}
			
			public Object getValue (Object element, String property) 
			{
				DSPRegTableRow row = (DSPRegTableRow) element;
				return row.getColumnText(row.propertyToColumn(property));
			}
			
			public void modify (Object element, String property, Object value) 
			{
				Item item = (Item)element;
				DSPRegTableRow row = (DSPRegTableRow) item.getData();
				int index = row.propertyToDataColumn(property);
				
				if (!row.setPartialValue(index, (String)value))
					return;
				row.modifyItem();
				
				updateTables(false);
			}
		}); 

		table.addMouseListener(view);
		table.addKeyListener(this);
		table.setData(TABLE_DESC, desc);
		table.setData(TABLE_NAME, tableName);

		// We need to add the "Total value" column if register is spiltted to fields
		int extraColumnsNumber = desc.addTotalField ? 2: 1;
		String[] columnNames = desc.names;
		CellEditor[] editors = new CellEditor[columnNames.length + extraColumnsNumber];
		TableColumn column;
		
		// Adding registers name column	
		column = new TableColumn(table,SWT.CENTER);
		column.setText(tableName);
		column.setResizable(false);
		editors[0] = new TextCellEditor(table);
		
		// If needed add the total value column
		if (extraColumnsNumber == 2)
		{
			column = new TableColumn(table,SWT.CENTER);
			column.setText("Total Value(" + desc.totalSize+')');
			column.setResizable(false);
			editors[1] = new TextCellEditor(table);
		}
		
		
		for (int ind=0; ind < columnNames.length; ind++)
		{
			column = new TableColumn(table,SWT.CENTER);
			column.setText(columnNames[ind]);
			column.setResizable(false);
			editors[ind+extraColumnsNumber] = new TextCellEditor(table);
		}
		tableViewer.setCellEditors(editors);
		
		// Set column properties			
		tableViewer.setColumnProperties(DSPRegTableRow.getProperties(columnNames.length+extraColumnsNumber));
		
		// Add to map
		tablesMap.put(tableName, tableViewer);
		updateTables(false);
		return tableName;
	}
	
	protected void addRow(String tableName, String itemName, IRegisterAccessor accessor)
	{
		if (!tablesMap.containsKey(tableName)) return;
		
		TableViewer viewer = (TableViewer)tablesMap.get(tableName);
		Table table = viewer.getTable();
		
		
		RegistersGroupData desc = (RegistersGroupData)table.getData(TABLE_DESC);
		DSPRegTableRow row = new DSPRegTableRow(itemName,desc, accessor);
		
		Vector vec = (Vector)viewer.getInput();
		
		// check to avoid duplicates
		if (vec.contains(row))
			return;
		
		row.setBase(getViewMode());
		row.updateItem();
		vec.add(row);
		
		// sort the rows
		Object[] elements = vec.toArray();
		Sorter.sort(elements, new RowComparator());
		
		vec.clear();
		for (int ind=0; ind < elements.length; ind++)
			vec.addElement(elements[ind]);
		
		viewer.refresh(false);		
	}
	

	
	public void removeSelectedRows(String tableName)
	{
		if (!tablesMap.containsKey(tableName)) return;
		
		TableViewer viewer = (TableViewer)tablesMap.get(tableName);
		
		// we remove indecies backward (faster + indecies stays valid)
		Vector vec = (Vector)viewer.getInput();
		int previousCount = vec.size();
		int[] indiceis = viewer.getTable().getSelectionIndices();
		for (int ind=indiceis.length-1; ind >=0; ind--)
			vec.removeElementAt(indiceis[ind]);
			
		int currentCount = vec.size();
		
		if (currentCount == 0)
			removeTable(tableName);
		else
			viewer.refresh(true);
	}
	
	/**
	 * Returns a vector of all the register rows from all the table
	 * currently shown by the view
	 * @return a Vectr of DSPRegTableRow
	 */
	public Vector getAllRegistersRows()
	{
		Iterator iter = tablesMap.keySet().iterator();
		String tableName;
		Vector allRows = new Vector();
		Vector tableRows;
		
		// go over all tables
		while (iter.hasNext())
		{
			tableName = (String)iter.next();
			tableRows = (Vector)((TableViewer)tablesMap.get(tableName)).getInput();
			
			// add all rows
			allRows.addAll(tableRows);
		}
		
		return allRows;
	}
	
	/**
	 * Sets the view mode of the page (binary/octal/decimal etc.)
	 * @param base	The new base for the view mode
	 */
	public void setViewMode(int base)
	{
		baseMode = base;
		Iterator iter = tablesMap.values().iterator();
		TableViewer viewer;
		Vector vec;
		
		// Go over all tables
		while (iter.hasNext())
		{
			viewer = (TableViewer)iter.next();
			
			vec = (Vector) viewer.getInput();
			
			// Set base in all rows in table	
			for (int ind=0; ind < vec.size(); ind++)
				((DSPRegTableRow)vec.elementAt(ind)).setBase(base);
			
			viewer.refresh(true);
		}
	}
	
	protected int getViewMode()
	{
		return baseMode;
	}
	
	private void updateUI()
	{
		if (innerComposite.isDisposed() || scrollComposite.isDisposed())
			return;
		
		//System.out.println("updateUI() called");
		innerComposite.setVisible(false);
		innerComposite.setSize(innerComposite.computeSize(SWT.DEFAULT, SWT.DEFAULT));
		innerComposite.layout();
		innerComposite.setVisible(true);
		//System.out.println("updateUI() finished");
	}
	
	/**
	 * Loads the state from the last launch configuration 
	 * (create the relevant tables & their registers)
	 */
	public void loadState()
	{
		removeAllTables();
		
		ILaunchConfiguration conf = getLaunchConfiguration();
		if (conf == null)
			return;

		List list;
		try 
		{
			String baseKey = ATT_REGISTER_VIEW_PREFIX;
			processorName = conf.getAttribute(baseKey + ATT_PART_NUMBER, PART_NUMBER_UNKNOWN);
			list = conf.getAttribute(baseKey+ATT_TABLES, new LinkedList());
			setViewMode(conf.getAttribute(baseKey+ATT_VIEW_BASE, ValueViewUtils.HEXA));
		} catch (CoreException e) 
		{
			view.showMessage(e.getMessage());
			return;
		}
		
		// can not restore anything, processot has not been selected yet:
		if(processorName == PART_NUMBER_UNKNOWN)
			return;
		
		IModuleRegistersMapper registersMap = RegistersMappersManager.getInstance().getRegisterMapper(processorName);

		Iterator iter = list.iterator();
		String tableName;
		String registerName;
		RegistersGroupData data;
		
		// Go over the list of tables names & their registers
		while (iter.hasNext())
		{
			// Add the new table
			tableName = (String)iter.next();
			if (!iter.hasNext())
				return;
			
			// Add each register to table
			registerName = (String)iter.next();
			data = registersMap.getGroupData(registerName);
			addTable(tableName,data);
			
			// Create the accessor for it:
			while (!registerName.equalsIgnoreCase(ATT_NEW_TABLE_SEPERATOR))
			{
				addRow(tableName, registerName, CreateRegisterAccessor(registerName, registersMap));
				registerName = (String)iter.next();
			}
		}	
	}
	
	protected void statusChanged()
	{
		saveState();
		updateUI();
	}
	
	/**
	 * Saves the view state to the launch configuration 
	 * (the viewed tables & their registers)
	 */
	private void saveState()
	{
		ILaunchConfiguration conf = getLaunchConfiguration();
		if (conf == null) return;
		
		// Get the configuration copy
		ILaunchConfigurationWorkingCopy copy;
		try 
		{
			copy = conf.getWorkingCopy();
		} catch (CoreException e) 
		{
			view.showMessage(e.getMessage());
			return;
		}
		
		Table table;
		String tableName;
		Vector rows;
		DSPRegTableRow row;
		
		// Create the view state in the linked list
		List list = new LinkedList();		
		Iterator iter = tablesMap.keySet().iterator();
				
		while (iter.hasNext())
		{
			tableName = (String)iter.next();
			list.add(tableName);
			rows = (Vector)((TableViewer)tablesMap.get(tableName)).getInput();
			
			for (int ind=0; ind < rows.size(); ind++)
			{
				row = (DSPRegTableRow)rows.elementAt(ind);
				list.add(row.getColumnText(0));
			}
			
			list.add(ATT_NEW_TABLE_SEPERATOR);
		}
		
		// sets the new state & save it
		String baseKey = ATT_REGISTER_VIEW_PREFIX;
		copy.setAttribute(baseKey+ATT_PART_NUMBER, processorName);
		copy.setAttribute(baseKey+ATT_VIEW_BASE, baseMode);
		copy.setAttribute(baseKey+ATT_TABLES, list);	
		
		try 
		{
			copy.doSave();
		} catch (CoreException e) 
		{
			view.showMessage(e.getMessage());
		}
	}
	
	public String getFocusedTableName()
	{
		Iterator iter = tablesMap.values().iterator();
		Table item;
		while (iter.hasNext())
		{
			item = ((TableViewer)iter.next()).getTable();
			
			if (item.isFocusControl())
				return (String)item.getData(TABLE_NAME);;
		}
		
		return null;
	}


	protected void removeAllTables()
	{
		Iterator iter;

		String name;
		while ((iter = tablesMap.keySet().iterator()).hasNext())
		{
			name = (String)iter.next();
			removeTable(name, false);
		}

		updateUI();
	}
	
	
	protected void removeTable(String tableName)
	{
		removeTable(tableName, true);
	}
	
	private void removeTable(String tableName, boolean updateUI)
	{
		if (!tablesMap.containsKey(tableName)) return;

		Table 	table = ((TableViewer)tablesMap.remove(tableName)).getTable();
		table.removeListener(SWT.MouseDown, focusHandler);
		table.dispose();
		
		if (focusedTable == table)
			focusedTable = null;
		
		if (updateUI)
			updateUI();
	}
	
	private void updateTables(boolean init)
	{
		// Go over all tables
		Iterator iter = tablesMap.values().iterator();
		TableViewer viewer;
		DSPRegTableRow item;
		Vector vec;
		TableItem tableItem;
		while (iter.hasNext())
		{
			viewer = (TableViewer)iter.next();
			vec = (Vector) viewer.getInput();
			
			// Go over all rows in table	
			for (int ind=0; ind < vec.size(); ind++)
			{
				tableItem = viewer.getTable().getItem(ind);
				
				// if there was a change we color it red
				if (((DSPRegTableRow)vec.elementAt(ind)).updateItem() && !init)
					tableItem.setForeground(IColorConstants.CHANGED_COLOR);
				else
					tableItem.setForeground(IColorConstants.DATA_COLOR);
			}
			
			viewer.setInput(vec);
		}	
	}
	
	static protected IRegisterAccessor CreateRegisterAccessor(String regName, IModuleRegistersMapper mapper)
	{
		IRegisterAccessor access = null;
		RegisterDefinition def = mapper.getRegisterDefinition(regName);
		if(def== null)
		{
			System.err.println("Could not find " + regName + " definition");
			return access;		// Should no be here !!!!
		}
		if(def.memoryMapped)
			access = new MMRAccessor(def);
		/**
		 * TODO will need to deal with other registers - non MMRs later
		 */
		return access;
	
	}
	/*
	/**
	 * Update a single given row in a table, and returns whether, the
	 * update caused a change in value.
	 * 
	 * @param row	The given table row
	 * @return	true if the update caused a change in the value
	 */
/*
	private boolean updateItem(DSPRegTableRow row)
	{

		TODO Register access goes here:

		IDebugPlatform platform = getDebugPlatform();
		if (platform == null)
			return false;
			
		long[]	value = new long[row.getNumberOf32bits()];
		long 	partialValue;
		int res = platform.fetchRegByNameAPI(getDeviceInfo().getIndex(), row.getColumnText(0), value, value.length);
		
		boolean change = false;
		if ( res == IDebugPlatform.REGSTATUS_OK )
			change = row.setTotalValue(value);
		
		// whatever the status is, we just copy it to the row so the viewer will deal with it.
		row.setRegisterValueStatus( res );
		return change;
		
		return true;
	}
*/
	/**
	 * @see org.eclipse.swt.events.KeyListener#keyPressed(KeyEvent)
	 */
	public void keyPressed(KeyEvent e)
	{
	}

	/**
	 * @see org.eclipse.swt.events.KeyListener#keyReleased(KeyEvent)
	 */
	public void keyReleased(KeyEvent e)
	{
		if (e.character != SWT.DEL) return;
			
		if (e.getSource() instanceof Table)
		{
			removeSelectedRows((String)((Table) e.getSource()).getData(TABLE_NAME));
			statusChanged();
		}
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.ui.views.DSPViewerPage#doReload()
	 */
	protected void doReload() 
	{
		loadState();
		
		Display.getDefault().syncExec(new Runnable()
		{
			public void run()
			{
				updateTables(false);
				updateUI();
			}
		});
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.ui.views.DSPViewerPage#doSuspend()
	 */
	protected void doSuspend() 
	{
		updateTables(false);	
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.ui.views.DSPViewerPage#doTerminate()
	 */
	protected void doTerminate() 
	{	
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.ui.views.DSPViewerPage#doResume()
	 */
	protected void doResume() 
	{
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.debug.ui.views.DSPViewerPage#doChanged()
	 */
	protected void doRestart() 
	{
		updateTables(false);
	}
	
	private class RowComparator implements Comparator
	{
		public int compare(Object o1, Object o2) 
		{
			// split registers to name & number so we can sort
			// them properly (format <reg>XX or <reg>YY:XX)
			String[] val1 = splitRegisterName(o1.toString());
			String[] val2 = splitRegisterName(o2.toString());
				
			if (	val1.length == 2 && 
					val2.length == 2 &&
					val1[0].equalsIgnoreCase(val2[0]))
			{
				return Integer.valueOf(val1[1]).compareTo(Integer.valueOf(val2[1]));
			}
				
			return o1.toString().compareTo(o2.toString());
		}
		/**
		 * Split the register to its name and number (if such exists)
		 * @param reg	The register full name
		 * @return
		 */
		private String[] splitRegisterName(String reg)
		{
			// find the number at the end
			int ind = reg.length()-1;
			for (;ind > 0; ind--)
			{
				char c = reg.charAt(ind);
				if (!Character.isDigit(c))
					break;
			}
		
			String[] result;
		
			// split the number if found
			if (ind < reg.length()-1)
			{
				result = new String[2];
				result[0] = reg.substring(0, ind+1);
				result[1] = reg.substring(ind+1);
			
				// remove the editional number if exists (<reg>YY:XX format)
				if (result[0].endsWith(":"))
				{
					ind = result[0].length()-2;
					for (;ind > 0; ind--)
					{
						char c = reg.charAt(ind);
						if (!Character.isDigit(c))
							break;
					}
				
					result[0] = result[0].substring(0, ind+1);
				}
			}
			else
			{
				result = new String[]{reg};
			}
		
		
			return result;
		}
	}
}
