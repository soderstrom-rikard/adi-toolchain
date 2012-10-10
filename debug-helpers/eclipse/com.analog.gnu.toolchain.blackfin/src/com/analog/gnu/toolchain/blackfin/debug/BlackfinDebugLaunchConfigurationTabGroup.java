/*******************************************************************************
 *  Copyright (c) 2012 Analog Devices, Inc.
 *  All rights reserved. This program and the accompanying materials
 *  are made available under the terms of the Eclipse Public License v1.0
 *  which accompanies this distribution, and is available at
 *  http://www.eclipse.org/legal/epl-v10.html
 *
 *  Contributors:
 *     Analog Devices, Inc. - Initial implementation
 *******************************************************************************/
package com.analog.gnu.toolchain.blackfin.debug;

import org.eclipse.cdt.launch.ui.CMainTab;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup;
import org.eclipse.debug.ui.CommonTab;
import org.eclipse.debug.ui.ILaunchConfigurationDialog;
import org.eclipse.debug.ui.ILaunchConfigurationTab;
import org.eclipse.debug.ui.sourcelookup.SourceLookupTab;

import org.eclipse.cdt.debug.gdbjtag.ui.GDBJtagDebuggerTab;
import org.eclipse.cdt.debug.gdbjtag.ui.GDBJtagStartupTab;

import com.analog.gnu.toolchain.blackfin.Utility;

/**
 * Launch configuration tab group.
 */
public class BlackfinDebugLaunchConfigurationTabGroup extends AbstractLaunchConfigurationTabGroup {
	/**
	 * Create the tabs in the launch configuration dialog.
	 * 
	 * @param dialog the launch configuration dialog
	 * @param mode the launch configuration mode
	 */
	public void createTabs(ILaunchConfigurationDialog dialog, String mode) {
		GDBJtagDebuggerTab debugger = new GDBJtagDebuggerTab();
		GDBJtagStartupTab startup = new GDBJtagStartupTab();
		ILaunchConfigurationTab[] tabs = new ILaunchConfigurationTab[] {
			new CMainTab(CMainTab.DONT_CHECK_PROGRAM),
			debugger,
			startup,
			new SourceLookupTab(),
			new CommonTab()
		};
		setTabs(tabs);
	}

	/**
	 * setDefaults is called when the user creates a new launch configuration.
	 * This function sets up the default settings for the tabs in the GDB JTAG
	 * debugger plugin, based on the launch configuration type selected by the
	 * user.  For example, if the user chooses Blackfin Linux App (FLAT), then
	 * the gdb command will be set to bfin-linux-gdb.
	 * 
	 * @param configuration - the launch configuration
	 */
	public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		super.setDefaults(configuration);
		  
		Utility.initDefaults(configuration);
	}
}
