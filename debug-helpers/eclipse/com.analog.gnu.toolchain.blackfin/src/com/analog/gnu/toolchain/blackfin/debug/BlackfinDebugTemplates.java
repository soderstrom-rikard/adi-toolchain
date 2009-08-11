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

import org.eclipse.cdt.debug.core.ICDTLaunchConfigurationConstants;
import org.eclipse.cdt.debug.gdbjtag.core.IGDBJtagConstants;
import org.eclipse.cdt.debug.mi.core.IMIConstants;
import org.eclipse.cdt.debug.mi.core.IMILaunchConfigurationConstants;
import org.eclipse.cdt.debug.mi.core.MIPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.Preferences;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.List;
import org.eclipse.swt.widgets.Listener;

import com.analog.gnu.toolchain.blackfin.Activator;
import com.analog.gnu.toolchain.blackfin.build.CheckToolchain;
import com.analog.gnu.toolchain.blackfin.debug.gdbjtag.GDBJtagDebuggerTab;
import com.analog.gnu.toolchain.blackfin.debug.gdbjtag.GDBJtagStartupTab;

public class BlackfinDebugTemplates extends AbstractLaunchConfigurationTab {

	private static final String defaultBlackfinIP = "192.168.0.15";
	private static final String defaultGDBProxyIP = "localhost";
	private static final int defaultGDBProxyPort = 2000;
	private static final int defaultGDBServerPort = 1234;
	private static final int defaultKGDBPort = 6443;

	private static final String elfGDB = "bfin-elf-gdb";
	private static final String flatGDB = "bfin-uclinux-gdb";
	private static final String fdpicGDB = "bfin-linux-uclibc-gdb";

	private GDBJtagDebuggerTab debuggerTab;
	private GDBJtagStartupTab startupTab;
	private ILaunchConfiguration launchConfig;

	private Label headerLabel;

	private List toolchainList;

	private Label elfLabel;
	private List elfList;
	private Label flatLabel;
	private List flatList;
	private Label fdpicLabel;
	private List fdpicList;

	public BlackfinDebugTemplates(GDBJtagDebuggerTab debugger, GDBJtagStartupTab startup) {
		debuggerTab = debugger;
		startupTab = startup;
	}

	public String getName() {
		return Messages.getString("TemplateTab.Name");
	}

	public Image getImage() {
		return BlackfinDebugImages.getADIImage();
	}

	public void createControl(Composite parent) {
		ScrolledComposite sc = new ScrolledComposite(parent, SWT.V_SCROLL | SWT.H_SCROLL);
		sc.setExpandHorizontal(true);
		sc.setExpandVertical(true);
		setControl(sc);

		Composite comp = new Composite(sc, SWT.NONE);
		sc.setContent(comp);
		GridLayout layout = new GridLayout();
		comp.setLayout(layout);

		createHeader(comp);
		createDebuggerList(comp);
		createTemplateList(comp);

		sc.setMinSize(comp.computeSize(SWT.DEFAULT, SWT.DEFAULT));
	}

	private void createHeader(Composite parent) {
		headerLabel = new Label(parent, SWT.NONE);
		headerLabel.setText(Messages.getString("TemplateTab.Explanation"));
	}

	private static String joinStrings(String list[], String delimiter)
	{
		int i;
		String ret = "";
		for (i = 0; i < list.length - 1; ++i)
			ret += list[i] + delimiter;
		return ret + list[i];
	}

	private static String listToDebugger(String item) {
		return item.substring(item.lastIndexOf('(')).replaceAll("[()]", "");
	}
	private static boolean inList(List list, String needle) {
		for (int i = 0; i < list.getItemCount(); ++i)
			if (listToDebugger(list.getItem(i)).equals(needle))
				return true;
		return false;
	}

	private ILaunchConfigurationWorkingCopy workingCopy, localCopy;
	private void getConfig() {
		try {
			workingCopy = launchConfig.isWorkingCopy() ? (ILaunchConfigurationWorkingCopy) launchConfig : launchConfig.getWorkingCopy();
			localCopy = workingCopy.copy(Activator.PLUGIN_ID + ".hubby.bubby.boobly.boo");
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}
	private void putConfig() {
		/* Save our settings and bail */
		debuggerTab.initializeFrom(localCopy);
		startupTab.initializeFrom(localCopy);
		try {
			workingCopy.setAttributes(localCopy.getAttributes());
			localCopy.delete();
			if (!workingCopy.equals(launchConfig)) {
				workingCopy.doSave();
				workingCopy.delete();
			}
		} catch (CoreException e) {
			e.printStackTrace();
		}
		localCopy = null;
	}
	private String getAttribute(String attributeName, String defaultValue) { try { return localCopy.getAttribute(attributeName, defaultValue); } catch (CoreException e) { return defaultValue; } }

	private void createDebuggerList(Composite parent) {
		Group group = new Group(parent, SWT.NONE);
		group.setLayout(new GridLayout());
		GridData gd = new GridData(GridData.FILL_HORIZONTAL);
		group.setLayoutData(gd);
		group.setText(Messages.getString("TemplateTab.DebuggerHeader"));

		Composite comp = new Composite(group, SWT.NONE);
		comp.setLayout(new GridLayout());

		toolchainList = new List(comp, SWT.BORDER);
		if (CheckToolchain.isToolSupported(elfGDB))
			toolchainList.add(Messages.getString("TemplateTab.DebuggerBare") + " (" + elfGDB + ")");
		if (CheckToolchain.isToolSupported(flatGDB))
			toolchainList.add(Messages.getString("TemplateTab.DebuggerFLAT") + " (" + flatGDB + ")");
		if (CheckToolchain.isToolSupported(fdpicGDB))
			toolchainList.add(Messages.getString("TemplateTab.DebuggerFDPIC") + " (" + fdpicGDB + ")");
		toolchainList.addListener(SWT.Selection, new Listener() {
			public void handleEvent(Event event) {
				String debugger = listToDebugger(toolchainList.getSelection()[0]);
				boolean isJtagDebugger =  debugger.equals(elfGDB);

				if (elfList != null) elfList.setEnabled(debugger.equals(elfGDB));
				if (flatList != null) flatList.setEnabled(debugger.equals(flatGDB));
				if (fdpicList != null) fdpicList.setEnabled(debugger.equals(fdpicGDB));

				getConfig();

				/* Setup the Debugger tab */
				localCopy.setAttribute(IMILaunchConfigurationConstants.ATTR_DEBUG_NAME, debugger);
				localCopy.setAttribute(IMILaunchConfigurationConstants.ATTR_DEBUGGER_COMMAND_FACTORY, "Standard");
				localCopy.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, true);
				localCopy.setAttribute(IGDBJtagConstants.ATTR_JTAG_DEVICE, "Generic");
				if (isJtagDebugger) {
					localCopy.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, defaultGDBProxyIP);
					localCopy.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, defaultGDBProxyPort);
				} else {
					localCopy.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, defaultBlackfinIP);
					localCopy.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, defaultGDBServerPort);
				}

				/* Setup the Startup tab */
				String program = getAttribute(ICDTLaunchConfigurationConstants.ATTR_PROGRAM_NAME, "");
				if (program.indexOf(':') == -1 && program.charAt(0) != '/') {
					/* program is workspace relative, so make the gdb form happy */
					String project = getAttribute(ICDTLaunchConfigurationConstants.ATTR_PROJECT_NAME, "");
					if (project.length() > 0)
						program = "${workspace_loc:" + project + "/" + program + "}";
				}
				localCopy.setAttribute(IGDBJtagConstants.ATTR_LOAD_IMAGE, false);
				localCopy.setAttribute(IGDBJtagConstants.ATTR_LOAD_SYMBOLS, false);
				localCopy.setAttribute(IGDBJtagConstants.ATTR_DO_RESET, false);
				localCopy.setAttribute(IGDBJtagConstants.ATTR_DO_HALT, false);
				localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_PC_REGISTER, false);
				if (!isJtagDebugger) {
					localCopy.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, "");
				} else {
					//String gdbserverHost = getAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, defaultBlackfinIP);
					String init[] = {
							"set remotetimeout 300",
							/*
							"rcp \"" + program + "\" " + gdbserverHost + ".root:/eclipse-cdt-debug",
							"rsh " + gdbserverHost + " -l root chmod a+rx /eclipse-cdt-debug",
							"rsh " + gdbserverHost + " -l root gdbserver :" +  getAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, defaultGDBServerPort) + " /eclipse-cdt-debug",
							*/
					};
					localCopy.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, joinStrings(init, "\r\n"));
				}
				localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, true);
				localCopy.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "main");
				localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, true);

				putConfig();
			}
		});
	}

	/*
	- Linux applications (Windows and Linux hosts)
	    - fdpic only (gdb via ethernet)
	       - automatic rcp to target, and rsh of gdbserver is bonus (if possible)
	 - Linux kernel (only on Linux hosts)
	    - kgdb
	    - gnICE
	 - bare metal applications (Windows and Linux hosts)
	    - gnICE
	    - gdb simulator
	 */

	private void loadTemplateKGDB() {
		localCopy.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, defaultBlackfinIP);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, defaultKGDBPort);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_DO_RESET, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_DO_HALT, false);
		String init[] = {
				"target remote udp:" + defaultBlackfinIP + ":" + defaultKGDBPort,
				"load"
		};
		localCopy.setAttribute(IGDBJtagConstants.ATTR_LOAD_IMAGE, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_LOAD_SYMBOLS, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, joinStrings(init, "\r\n"));
		localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_PC_REGISTER, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "");
		localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, true);
	}

	private void loadTemplateGDBServer() {
		localCopy.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, true);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, defaultBlackfinIP);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, defaultGDBServerPort);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_DO_RESET, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_DO_HALT, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_LOAD_IMAGE, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_LOAD_SYMBOLS, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_PC_REGISTER, false);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, true);
		localCopy.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "main");
		localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, true);
	}

	private void createTemplateList(Composite parent) {
		Group group = new Group(parent, SWT.NONE);
		group.setLayout(new GridLayout());
		GridData gd = new GridData(SWT.FILL, SWT.FILL, true, false);
		group.setLayoutData(gd);
		group.setText(Messages.getString("TemplateTab.TemplateHeader"));

		Composite comp = new Composite(group, SWT.NONE);
		comp.setLayout(new GridLayout(toolchainList.getItemCount(), true));

		if (inList(toolchainList, elfGDB)) {
			elfLabel = new Label(comp, SWT.NONE);
			//elfLabel.setText(Messages.getString("TemplateTab.elfTemplates"));
			elfLabel.setText(elfGDB);
		}
		if (inList(toolchainList, flatGDB)) {
			flatLabel = new Label(comp, SWT.NONE);
			//flatLabel.setText(Messages.getString("TemplateTab.flatTemplates"));
			flatLabel.setText(flatGDB);
		}
		if (inList(toolchainList, fdpicGDB)) {
			fdpicLabel = new Label(comp, SWT.NONE);
			//fdpicLabel.setText(Messages.getString("TemplateTab.fdpicTemplates"));
			fdpicLabel.setText(fdpicGDB);
		}

		if (inList(toolchainList, elfGDB)) {
			elfList = new List(comp, SWT.BORDER);
			elfList.setEnabled(false);
			elfList.add("Bare Metal App");
			elfList.add("Simulation");
			elfList.add("KGDB");
			elfList.addListener(SWT.Selection, new Listener() {
				public void handleEvent(Event event) {
					/* Default timeout (~10 seconds) is too short for the gnICE + gdbproxy */
					Preferences prefs = MIPlugin.getDefault().getPluginPreferences();
					if (prefs.getInt(IMIConstants.PREF_REQUEST_TIMEOUT) <= IMIConstants.DEF_REQUEST_TIMEOUT * 3)
						prefs.setValue(IMIConstants.PREF_REQUEST_TIMEOUT, IMIConstants.DEF_REQUEST_TIMEOUT * 3);

					getConfig();
					switch (elfList.getSelectionIndex()) {
					case 0: {
						localCopy.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, true);
						localCopy.setAttribute(IGDBJtagConstants.ATTR_JTAG_DEVICE, "Generic");
						localCopy.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, defaultGDBProxyIP);
						localCopy.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, defaultGDBProxyPort);
						String init[] = {
								"set remotetimeout 300",
								"load"
						};
						localCopy.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, joinStrings(init, "\r\n"));
						localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, true);
						localCopy.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "main");
						localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, true);
						break;
					}

					case 1: {
						localCopy.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, false);
						String init[] = {
								"target sim",
								"load"
						};
						localCopy.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, joinStrings(init, "\r\n"));
						localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, false);
						localCopy.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "");
						localCopy.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, false);
						break;
					}

					case 2: loadTemplateKGDB(); break;
					}
					putConfig();
				}
			});
		} else
			elfList = null;

		if (inList(toolchainList, flatGDB)) {
			flatList = new List(comp, SWT.BORDER);
			flatList.setEnabled(false);
			flatList.add("GDBServer");
			flatList.add("KGDB");
			flatList.setLocation(0,0);
			flatList.addListener(SWT.Selection, new Listener() {
				public void handleEvent(Event event) {
					getConfig();
					switch (flatList.getSelectionIndex()) {
					case 0: loadTemplateGDBServer(); break;
					case 1: loadTemplateKGDB(); break;
					}
					putConfig();
				}
			});
		} else
			flatList = null;

		if (inList(toolchainList, fdpicGDB)) {
			fdpicList = new List(comp, SWT.BORDER);
			fdpicList.setEnabled(false);
			fdpicList.add("GDBServer");
			fdpicList.setBounds(0, 0, 300, fdpicList.getItemHeight() * fdpicList.getItemCount() + fdpicList.getBorderWidth() * 2);
			fdpicList.addListener(SWT.Selection, new Listener() {
				public void handleEvent(Event event) {
					getConfig();
					switch (fdpicList.getSelectionIndex()) {
					case 0: loadTemplateGDBServer(); break;
					}
					putConfig();
				}
			});
		} else
			fdpicList = null;
	}

	public void initializeFrom(ILaunchConfiguration configuration) {
		launchConfig = configuration;
	}

	public void performApply(ILaunchConfigurationWorkingCopy configuration) {
		// We don't have any settings on this tab
		configuration.getOriginal();
	}

	public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		// We don't have any settings on this tab
		configuration.getOriginal();
	}
}