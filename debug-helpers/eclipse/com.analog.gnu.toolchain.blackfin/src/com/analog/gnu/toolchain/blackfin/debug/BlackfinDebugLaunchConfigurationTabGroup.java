/**
 * Copyright Analog Devices, Inc. 2008
 * Licensed under the GPL-2
 */

package com.adi.toolchain.gnu.debug;

import org.eclipse.cdt.launch.ui.CMainTab;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup;
import org.eclipse.debug.ui.CommonTab;
import org.eclipse.debug.ui.ILaunchConfigurationDialog;
import org.eclipse.debug.ui.ILaunchConfigurationTab;
import org.eclipse.debug.ui.sourcelookup.SourceLookupTab;

import com.adi.toolchain.gnu.debug.gdbjtag.GDBJtagDebuggerTab;
import com.adi.toolchain.gnu.debug.gdbjtag.GDBJtagStartupTab;

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
