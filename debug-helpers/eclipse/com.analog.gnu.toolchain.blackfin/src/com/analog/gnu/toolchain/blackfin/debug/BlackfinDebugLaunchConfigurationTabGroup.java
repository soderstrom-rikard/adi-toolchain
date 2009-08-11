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
package com.analog.gnu.toolchain.blackfin.debug;

import org.eclipse.cdt.launch.ui.CMainTab;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup;
import org.eclipse.debug.ui.CommonTab;
import org.eclipse.debug.ui.ILaunchConfigurationDialog;
import org.eclipse.debug.ui.ILaunchConfigurationTab;
import org.eclipse.debug.ui.sourcelookup.SourceLookupTab;

import com.analog.gnu.toolchain.blackfin.debug.gdbjtag.GDBJtagDebuggerTab;
import com.analog.gnu.toolchain.blackfin.debug.gdbjtag.GDBJtagStartupTab;

public class BlackfinDebugLaunchConfigurationTabGroup extends AbstractLaunchConfigurationTabGroup {

	public void createTabs(ILaunchConfigurationDialog dialog, String mode) {
		GDBJtagDebuggerTab debugger = new GDBJtagDebuggerTab();
		GDBJtagStartupTab startup = new GDBJtagStartupTab();
		ILaunchConfigurationTab[] tabs = new ILaunchConfigurationTab[] {
			new BlackfinDebugTemplates(debugger, startup),
			new CMainTab(CMainTab.DONT_CHECK_PROGRAM),
			debugger,
			startup,
			new SourceLookupTab(),
			new CommonTab()
		};
		setTabs(tabs);
	}

}
