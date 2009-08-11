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

import java.util.Vector;

import org.eclipse.jface.dialogs.Dialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.KeyListener;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Tree;
import org.eclipse.swt.widgets.TreeItem;

import com.analog.gnu.debug.core.registers.IModuleRegistersMapper;
import com.analog.gnu.debug.core.registers.RegistersMappersManager;

/**
 * @author odcohen
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class DSPAddRegistersDialog extends Dialog
	implements MouseListener, KeyListener, SelectionListener
{
	List 	list;
	Tree 	tree;
	Button 	addBtn, removeBtn;
	Label	partMessageLabel, messageLabel, fromLabel, toViewLabel, searchLabel;
	Text	searchText;
	Combo	partNumberCombo;

	String[] partNumbers;
	String selectedPart;

	IModuleRegistersMapper mapper;
	String[] addedRegisters;

	String searchFor;
	Vector treeItems;
	int searchIndex;

	private static final String SELECT_YOUR_PART_MESSAGE = "Select your DSP:";
	private static final String SELECT_FROM_MESSAGE = "All MMRs for ";
	private static final String SELECTED_TO_VIEW_MESSAGE = "MMRs selected to View:";
	private static final String WELCOME_MESSAGE = "";


	/**
	 * Constructor for AddRegistersDialog.
	 * @param parentShell
	 */
	public DSPAddRegistersDialog(Shell parentShell, String[] pns, String selectedProcessor)
	{
		super(parentShell);

		partNumbers = pns;
		selectedPart = selectedProcessor;
		setShellStyle(getShellStyle() | SWT.RESIZE);
		searchFor = new String();
		treeItems = new Vector();
		searchIndex = -1;
	}

	public boolean close()
	{
		addedRegisters = list.getItems();
		return super.close();
	}

	protected String getProcessorName()
	{
		return selectedPart;
	}

	protected String[][] getAddedRegisters()
	{
		if (addedRegisters == null)
			return null;

		String[][] 	results = new String[addedRegisters.length][];
		String[]	result;
		int seperatorIndex;
		for (int ind=0; ind < results.length; ind++)
		{
			results[ind] = result = new String[2];
			seperatorIndex = addedRegisters[ind].indexOf(':');
			result[0] = addedRegisters[ind].substring(0, seperatorIndex);
			result[1] = addedRegisters[ind].substring(seperatorIndex+2);
		}

		return results;
	}

	protected void addItem(String parentItemName, String[] itemNames)
	{
		TreeItem item = new TreeItem(tree, SWT.NONE);
		item.setText(parentItemName);
		//	Add the item into the items map:
		treeItems.addElement(item);

		TreeItem[] subItems = new TreeItem[itemNames.length];

		for (int ind=0; ind < subItems.length; ind++)
		{
			subItems[ind] = new TreeItem(item, SWT.NONE);
			subItems[ind].setText(itemNames[ind]);
			treeItems.addElement(subItems[ind]);
		}
	}

	/*
	 * @see Dialog#createDialogArea(Composite)
	 * TODO: make the heights here relative based on the widget size rather than hardcoded pixel count
	 */
	protected Control createDialogArea(Composite parent)
	{
		final Composite composite = (Composite)super.createDialogArea(parent);

		GridLayout gridLayout = new GridLayout();
		gridLayout.numColumns = 3;
		gridLayout.marginWidth = 9;
		gridLayout.marginHeight = 0;
		composite.setLayout(gridLayout);

		// GUI components
		GridData gridData;
		Control separator1,separator2;

		// part number message:
		partMessageLabel = new Label(composite, SWT.NONE);
		partMessageLabel.setText(SELECT_YOUR_PART_MESSAGE);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 3;
		gridData.heightHint = 20;
		gridData.widthHint  = 200;
		partMessageLabel.setLayoutData(gridData);

		// Part number selection combo box:
		partNumberCombo = new Combo(composite, SWT.DROP_DOWN|SWT.READ_ONLY);
		for(int i = 0; i < partNumbers.length; i++)
			partNumberCombo.add(partNumbers[i]);
		partNumberCombo.addSelectionListener(this);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 3;
		gridData.heightHint = 20;
		gridData.widthHint  = 200;
		partNumberCombo.setLayoutData(gridData);

		//	Select from:
		fromLabel = new Label(composite, SWT.NONE);
		fromLabel.setText(SELECT_FROM_MESSAGE);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 3;
		gridData.heightHint = 20;
		gridData.widthHint  = 200;
		fromLabel.setLayoutData(gridData);

		// Registers tree
		tree = new Tree(composite, SWT.BORDER | SWT.MULTI);
		tree.addSelectionListener(this);
		tree.addMouseListener(this);
		gridData = new GridData(GridData.FILL_HORIZONTAL|GridData.FILL_VERTICAL);
		gridData.widthHint = 300;
		gridData.heightHint	= 400;
		gridData.horizontalSpan = 3;
		tree.setLayoutData(gridData);

		// Search label:
		searchLabel = new Label(composite,SWT.NONE);
		searchLabel.setText("Search");
		gridData = new GridData(GridData.BEGINNING, GridData.CENTER, false, false);
		searchLabel.setLayoutData(gridData);

		// Search text:
		searchText = new Text(composite,SWT.SINGLE | SWT.BORDER);
		searchText.addKeyListener(this);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.widthHint = 70;
		searchText.setLayoutData(gridData);

		// Add Button
		addBtn = new Button(composite, SWT.PUSH );
		addBtn.setText("Add To View");
		addBtn.setEnabled(true);
		addBtn.addMouseListener(this);
		gridData = new GridData(GridData.BEGINNING, GridData.BEGINNING, false, false);
		gridData.widthHint 	= addBtn.computeSize(SWT.DEFAULT, SWT.DEFAULT).x;
		addBtn.setLayoutData(gridData);

		// ---------------- Selected:
		separator1 = new Label(composite, SWT.BORDER);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 3;
		gridData.heightHint = 1;
		separator1.setLayoutData(gridData);

		toViewLabel = new Label(composite, SWT.NONE);
		toViewLabel.setText(SELECTED_TO_VIEW_MESSAGE);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 3;
		gridData.heightHint = 20;
		gridData.widthHint  = 200;
		toViewLabel.setLayoutData(gridData);

		// Registers list (added)
		list = new List(composite, SWT.BORDER | SWT.MULTI | SWT.H_SCROLL | SWT.V_SCROLL);
		list.addMouseListener(this);
		gridData = new GridData(GridData.FILL_HORIZONTAL|GridData.FILL_VERTICAL);
		gridData.widthHint 	= 300;
		gridData.heightHint	= 100;
		gridData.horizontalSpan = 3;
		list.setLayoutData(gridData);

		removeBtn = new Button(composite, SWT.PUSH );
		removeBtn.setText("Remove From View");
		removeBtn.setEnabled(true);
		removeBtn.addMouseListener(this);
		gridData = new GridData(GridData.CENTER, GridData.BEGINNING, false, false);
		gridData.widthHint = removeBtn.computeSize(SWT.DEFAULT, SWT.DEFAULT).x;
		gridData.horizontalSpan = 3;
		removeBtn.setLayoutData(gridData);

		// seperator
		separator2 = new Label(composite, SWT.BORDER);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 3;
		gridData.heightHint = 1;
		separator2.setLayoutData(gridData);

		messageLabel = new Label(composite, SWT.NONE);
		messageLabel.setText(WELCOME_MESSAGE);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 3;
		gridData.heightHint = 20;
		gridData.widthHint  = 200;
		messageLabel.setLayoutData(gridData);



		// find the default processorName in the combo box and set selection:
		int selection = partNumberCombo.indexOf(selectedPart);
		if(selection > -1)
		{
			partNumberCombo.select(selection);
			selectPartNumber(selectedPart);
		}

		return composite;
	}

	private void fillTree()
	{
		// get selected part number:

		String[] groups = mapper.getRegisterGroups();

		for (int ind=0; ind < groups.length; ind++)
			addItem(groups[ind], mapper.getRegisters(groups[ind]));
	}

	private TreeItem FindItem(String substr)
	{
		if(substr.length() == 0)
			return null;

		TreeItem item = null;
		int i = 0;
		for(; i < treeItems.size(); i++)
		{
			item = (TreeItem)treeItems.elementAt(i);
			if(item.getText().toLowerCase().startsWith(substr))
				break;
		}
		return (i == treeItems.size()) ? null : item;
	}

	protected void selectPartNumber(String pn)
	{
		tree.removeAll();

		selectedPart = pn;
		list.removeAll();
		searchText.setText("");
		mapper = RegistersMappersManager.getInstance().getRegisterMapper(selectedPart);
		// update the UI elements:
		fromLabel.setText(SELECT_FROM_MESSAGE + mapper.getModuleType());
		fillTree();

	}
	/*
	 * @see Window#configureShell(Shell)
	 */
	protected void configureShell(Shell newShell)
	{
		super.configureShell(newShell);
		newShell.setText("Add registers");
	}

	private void processRegsSelection()
	{
		boolean added = false;
		TreeItem[] items = tree.getSelection();

		for (int ind=0; ind < items.length; ind++)
			added = addSelectedTreeItem(items[ind]) || added;

		if (!added)
			messageLabel.setText("Some Item(s) already exist. ignored.");
		else
			messageLabel.setText(WELCOME_MESSAGE);
	}

	private void processRegsRemoval()
	{
		String[] items = list.getSelection();

		if (items.length == 0)
			messageLabel.setText("No Items were selected");
		else
		{
			for (int ind=0; ind < items.length; ind++)
				list.remove(items[ind]);

			messageLabel.setText(WELCOME_MESSAGE);
		}
	}
	/**
	 * @see org.eclipse.swt.events.MouseListener#mouseDoubleClick(MouseEvent)
	 */
	public void mouseDoubleClick(MouseEvent e)
	{
		if(e.getSource() == tree)
		{
			processRegsSelection();
		}
		else if(e.getSource() == list)
		{
			processRegsRemoval();
		}
	}

	/**
	 * @see org.eclipse.swt.events.MouseListener#mouseDown(MouseEvent)
	 */
	public void mouseDown(MouseEvent e){}

	/**
	 * @see org.eclipse.swt.events.MouseListener#mouseUp(MouseEvent)
	 */
	public void mouseUp(MouseEvent e)
	{
		if (e.getSource() == addBtn)
		{
			processRegsSelection();
		}
		else if (e.getSource() == removeBtn)
		{
			processRegsRemoval();
		}
	}

	private boolean addSelectedTreeItem(TreeItem item)
	{
		TreeItem parentItem = item.getParentItem();

		if (parentItem != null)
			return addItemToList(parentItem.getText() + ": " + item.getText());


		TreeItem[] items = item.getItems();
		boolean added = false;

		for (int ind=0; ind < items.length; ind++)
			added = addSelectedTreeItem(items[ind]) || added;

		return added;
	}


	private boolean addItemToList(String name)
	{
		String[] items = list.getItems();

		for (int ind=0; ind < items.length; ind++)
			if (items[ind].equalsIgnoreCase(name))
				return false;

		list.add(name);
		return true;
	}

	public void keyPressed(KeyEvent e)
	{
	}

	public void keyReleased(KeyEvent e)
	{
		// TODO Auto-generated method stub
		if(e.getSource() == searchText)
		{
			searchFor = searchText.getText().toLowerCase();
			TreeItem item = FindItem(searchFor);
			if(item != null)
				tree.setSelection(item);
			else
				tree.deselectAll();
		}

	}

	public void widgetDefaultSelected(SelectionEvent e) {
		// TODO Auto-generated method stub

	}

	public void widgetSelected(SelectionEvent e)
	{
		Object source = e.getSource();
		if(source == tree)
		{
			searchText.setText(tree.getSelection()[0].getText());
		}
		else if(source == partNumberCombo)
		{
			selectPartNumber(partNumberCombo.getText());
		}
	}




}
