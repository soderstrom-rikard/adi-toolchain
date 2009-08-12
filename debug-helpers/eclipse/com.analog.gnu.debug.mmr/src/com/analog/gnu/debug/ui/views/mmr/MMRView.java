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

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.eclipse.jface.action.IAction;
import org.eclipse.jface.action.IMenuListener;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.jface.action.MenuManager;
import org.eclipse.jface.action.Separator;
import org.eclipse.jface.viewers.DoubleClickEvent;
import org.eclipse.jface.viewers.Viewer;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Menu;
import org.eclipse.ui.IWorkbenchActionConstants;
import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.Platform;
import org.eclipse.debug.core.DebugEvent;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.IDebugEventSetListener;
import org.eclipse.debug.core.model.IDebugTarget;
import org.eclipse.debug.ui.AbstractDebugView;


import com.analog.gnu.debug.IDSPDebugUIConstants;
import com.analog.gnu.debug.core.registers.MMRViewUIPlugin;
import com.analog.gnu.debug.core.registers.RegistersMappersManager;
import com.analog.gnu.debug.ui.views.ChangeViewBaseAction;
import com.analog.gnu.debug.ui.views.INumberBaseView;
import com.analog.gnu.debug.ui.views.ValueViewUtils;

public class MMRView extends AbstractDebugView
				implements INumberBaseView, IDebugEventSetListener, MouseListener
{

	private static final String ADD_REG 		= "Add registers";
	private static final String REMOVE_REG 		= "Remove Selected Registers";
	private static final String REMOVE_TABLE 	= "Remove Selected Table";
	private static final String REMOVE_ALL 		= "Remove All Tables";

	private static final String DUMP 			= "Dump Registers";

	private static final String TmpProcessorType = "BFCore";
	MMRViewer viewer;
	MMRViewerPage page;
	Menu			menu;

	// not used currently:
	String processorType;
	// TODO: DSPPartNumberAccessor pnAccessor;

	public MMRView()
	{
		super();
		processorType = new String("UNKNOWN");
		// TODO: pnAccessor = new DSPPartNumberAccessor();
		InitializeRegisterMappers();
	}

	protected Viewer createViewer(Composite parent)
	{
		viewer = new MMRViewer(parent,this);
		page = viewer.getPage();
		page.addMouseListener(this);
		hookContextMenu(viewer);

		register(true);
		// Check if the target already created:
		// TODO: IDebugTarget[] targets = DebugPlugin.getDefault().getLaunchManager().getDebugTargets();
		// if(targets.length != 0)
		// processorType = pnAccessor.getPartNumberName();

		return viewer;
	}
	/*
	 *  (non-Javadoc)
	 * @see org.eclipse.debug.ui.AbstractDebugView#createActions()
	 */
	protected void createActions()
	{

		IAction action = new DSPChangeRegisterTableAction( this, viewer, ADD_REG, DSPChangeRegisterTableAction.CMD_ADD_REGISTERS  );
		setAction( ADD_REG, action );

		action = new DSPChangeRegisterTableAction( this, viewer, REMOVE_REG,  DSPChangeRegisterTableAction.CMD_REMOVE_REGISTERS );
		setAction( REMOVE_REG, action );

		action = new DSPChangeRegisterTableAction( this, viewer, REMOVE_TABLE,  DSPChangeRegisterTableAction.CMD_REMOVE_TABLE );
		setAction( REMOVE_TABLE, action );

		action = new DSPChangeRegisterTableAction( this, viewer, REMOVE_ALL,  DSPChangeRegisterTableAction.CMD_REMOVE_ALL_TABLE );
		setAction( REMOVE_ALL, action );

		action = new ChangeViewBaseAction( this, viewer,  ValueViewUtils.BINARY );
		setAction( ValueViewUtils.FORMAT_STR_BIN, action );

		action = new ChangeViewBaseAction( this, viewer,  ValueViewUtils.OCTAL );
		setAction( ValueViewUtils.FORMAT_STR_OCT, action );

		action = new ChangeViewBaseAction( this, viewer,  ValueViewUtils.UNSIGNED_INT );
		setAction( ValueViewUtils.FORMAT_STR_UNSIGNED_INT, action );

		action = new ChangeViewBaseAction( this, viewer,  ValueViewUtils.SIGNED_INT );
		setAction( ValueViewUtils.FORMAT_STR_SIGNED_INT, action );

		//action = new ChangeViewBaseAction( this, viewer,  ValueViewUtils.FLOATING );
		//setAction( ValueViewUtils.FORMAT_STR_FLOAT, action );

		action = new ChangeViewBaseAction( this, viewer,  ValueViewUtils.HEXA );
		setAction( ValueViewUtils.FORMAT_STR_HEX, action );
		action.setChecked(true);


		action = new RegistersDumpAction( this, viewer , DUMP);
		setAction( DUMP, action );

	}


	private void hookContextMenu(Viewer viewer)
	{
	 	MenuManager menuMgr = new MenuManager("#PopupMenu");
	  	menuMgr.setRemoveAllWhenShown(true);
	  	menuMgr.addMenuListener(new IMenuListener()
	  		{
		   		public void menuAboutToShow(IMenuManager manager)
		   		{
		    		fillContextMenu(manager);
		   		}
		  	});

		  menu = menuMgr.createContextMenu(viewer.getControl());
		  viewer.getControl().setMenu(menu);
		  getSite().registerContextMenu(menuMgr, viewer);
	 }


	/*
	 *  (non-Javadoc)
	 * @see org.eclipse.debug.ui.AbstractDebugView#fillContextMenu(org.eclipse.jface.action.IMenuManager)
	 */
	protected void fillContextMenu(IMenuManager menu)
	{

		menu.add(new Separator(IWorkbenchActionConstants.MB_ADDITIONS));

		menu.add( new Separator( IDSPDebugUIConstants.EMPTY_REGISTERS_GROUP ) );
		menu.add( new Separator( IDSPDebugUIConstants.REGISTERS_GROUP ) );

		menu.add( new Separator( IDSPDebugUIConstants.EMPTY_REGISTERS_MODE_GROUP ) );
		menu.add( new Separator( IDSPDebugUIConstants.REGISTERS_MODE_GROUP ) );

		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_GROUP, getAction( ADD_REG ) );
		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_GROUP, getAction( REMOVE_REG ) );
		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_GROUP, getAction( REMOVE_TABLE ) );
		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_GROUP, getAction( REMOVE_ALL ) );


		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_MODE_GROUP, getAction( ValueViewUtils.FORMAT_STR_BIN ) );
		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_MODE_GROUP, getAction( ValueViewUtils.FORMAT_STR_OCT ) );
		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_MODE_GROUP, getAction( ValueViewUtils.FORMAT_STR_HEX ) );
		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_MODE_GROUP, getAction( ValueViewUtils.FORMAT_STR_SIGNED_INT ) );
		menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_MODE_GROUP, getAction( ValueViewUtils.FORMAT_STR_UNSIGNED_INT ) );
		//menu.appendToGroup( IDSPDebugUIConstants.REGISTERS_MODE_GROUP, getAction( ValueViewUtils.FORMAT_STR_FLOAT ) );

		// dump
		menu.appendToGroup( IWorkbenchActionConstants.MB_ADDITIONS, getAction( DUMP ) );


		String focusedTable = page.getFocusedTableName();
		if (focusedTable == null)
		{
			getAction( REMOVE_REG ).setEnabled(false);
			getAction( REMOVE_TABLE ).setEnabled(false);
		}
		else
		{
			DSPChangeRegisterTableAction act = (DSPChangeRegisterTableAction)getAction( REMOVE_REG );
			act.setTableName(focusedTable);
			act.setEnabled(true);

			act = (DSPChangeRegisterTableAction)getAction( REMOVE_TABLE );
			act.setTableName(focusedTable);
			act.setEnabled(true);
		}

		getAction( ValueViewUtils.FORMAT_STR_BIN ).setEnabled(true);
		getAction( ValueViewUtils.FORMAT_STR_OCT ).setEnabled(true);
		getAction( ValueViewUtils.FORMAT_STR_UNSIGNED_INT ).setEnabled(true);
		getAction( ValueViewUtils.FORMAT_STR_SIGNED_INT ).setEnabled(true);
		//getAction( ValueViewUtils.FORMAT_STR_FLOAT ).setEnabled(true);
		getAction( ValueViewUtils.FORMAT_STR_HEX ).setEnabled(true);

		int mode = page.getViewMode();
		getAction(ValueViewUtils.FORMAT_STR_BIN).setChecked(mode == ValueViewUtils.BINARY);
		getAction(ValueViewUtils.FORMAT_STR_OCT).setChecked(mode == ValueViewUtils.OCTAL);
		getAction(ValueViewUtils.FORMAT_STR_UNSIGNED_INT).setChecked(mode == ValueViewUtils.UNSIGNED_INT);
		getAction(ValueViewUtils.FORMAT_STR_SIGNED_INT).setChecked(mode == ValueViewUtils.SIGNED_INT);
		//getAction(ValueViewUtils.FORMAT_STR_FLOAT).setChecked(mode == ValueViewUtils.FLOATING);
		getAction(ValueViewUtils.FORMAT_STR_HEX).setChecked(mode == ValueViewUtils.HEXA);

	}

	protected void configureToolBar(IToolBarManager tbm)
	{
	}



	protected MMRViewerPage getVisiableSheet()
	{
		return page;
	}

	protected String getProcessorType()
	{
		return processorType;
	}

	/**
	 * Register/Unregister the viewer to the its relevant events
	 * @param register	true for registration
	 */
	private void register(boolean register)
	{
		if (register)
		{
			DebugPlugin.getDefault().addDebugEventListener(this);
		}
		else
		{
			DebugPlugin.getDefault().removeDebugEventListener(this);
		}

	}


	/**
	 * @see org.eclipse.debug.core.IDebugEventSetListener#handleDebugEvents(DebugEvent[])
	 */
	final public void handleDebugEvents(DebugEvent[] events)
	{
		for (int i = 0; i < events.length; i++)
		{
			if (events[i].getSource() instanceof IDebugTarget)
				doHandleDebugEvent(events[i]);
		}
	}

	private synchronized void doHandleDebugEvent(DebugEvent debugEvent)
	{
		switch (debugEvent.getKind())
		{
			case DebugEvent.CREATE:
				if (debugEvent.getSource() instanceof IDebugTarget)
					handleTargetCreationg((IDebugTarget)debugEvent.getSource());

				break;
		}
	}

	private void handleTargetCreationg(final IDebugTarget target)
	{
		viewer.getControl().getDisplay().asyncExec(new Runnable()
		{
			public void run()
			{
				page.setDeviceInfo(processorType);
			}
		});

	}

	private void InitializeRegisterMappers()
	{
		URL dir = MMRViewUIPlugin.getDefault().getBundle().getEntry("/");
		URL localdir = null;
		String location = null;
		try
		{
			localdir = FileLocator.toFileURL(dir);
			location = new File(FileLocator.resolve(localdir).getPath()).getCanonicalPath();
		}
		catch (IOException e)
		{
			DebugPlugin.logDebugMessage("Could not get the MMR plugin location");
		}
		RegistersMappersManager.getInstance().loadMappers(location);
	}

	protected String getHelpContextId()
	{
		return new String("");
	}


	public void changeViewBase(int newBase) {
		page.setViewMode(newBase);
		page.statusChanged();

	}

	public void mouseDoubleClick(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	public void mouseDown(MouseEvent e)
	{
		if (menu != null)
		{
			menu.setVisible(false);
			if( e.button != 1)
				menu.setVisible(true);
		}

	}

	public void mouseUp(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	public void doubleClick(DoubleClickEvent event) {
		// TODO Auto-generated method stub

	}

}
