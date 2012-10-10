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
package com.analog.gnu.toolchain.blackfin;

import java.io.IOException;
import java.util.ArrayList;

import org.eclipse.cdt.core.model.CoreModel;
import org.eclipse.cdt.core.settings.model.ICConfigurationDescription;
import org.eclipse.cdt.core.settings.model.ICProjectDescription;
import org.eclipse.cdt.core.settings.model.ICProjectDescriptionManager;
import org.eclipse.cdt.debug.gdbjtag.core.IGDBJtagConstants;
import org.eclipse.cdt.debug.mi.core.IMIConstants;
import org.eclipse.cdt.debug.mi.core.IMILaunchConfigurationConstants;
import org.eclipse.cdt.debug.mi.core.MIPlugin;
import org.eclipse.cdt.managedbuilder.core.IConfiguration;
import org.eclipse.cdt.managedbuilder.core.IFolderInfo;
import org.eclipse.cdt.managedbuilder.core.IOption;
import org.eclipse.cdt.managedbuilder.core.IResourceInfo;
import org.eclipse.cdt.managedbuilder.core.ITool;
import org.eclipse.cdt.managedbuilder.core.IToolChain;
import org.eclipse.cdt.managedbuilder.core.ManagedBuildManager;
import org.eclipse.cdt.managedbuilder.ui.wizards.MBSCustomPageData;
import org.eclipse.cdt.managedbuilder.ui.wizards.MBSCustomPageManager;
import org.eclipse.cdt.ui.wizards.CCProjectWizard;
import org.eclipse.cdt.ui.wizards.CProjectWizard;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Plugin;
import org.eclipse.core.runtime.Preferences;
import org.eclipse.core.runtime.Status;
import org.eclipse.debug.core.ILaunchConfigurationType;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.jface.wizard.IWizard;

/** Preferences causes warnings */
@SuppressWarnings("deprecation")

/**
 * This class contains miscellaneous helper functions.
 */
final public class Utility {
	/** a regex that matches the compiler tool */
	public final static String TOOLID_COMPILER = ".+\\.compiler(\\.\\d+)*";

	/** a regex that matches the linker tool */
	public final static String TOOLID_LINKER   = ".+\\.linker(\\.\\d+)*";

	/** a regex that matches the processor switch option id */
	public final static String OPTID_PROCESSOR = ".*\\.options\\.proc(\\.\\d+)*";
	
	/** project processor selection can be unspecified for FDPIC and FLAT projects */
	public final static String UNSPECIFIED = "Unspecified";

	/** default settings for the launch configurations */
	private static final String DEFAULT_BLACKFIN_IP = "192.168.0.15";
	private static final String DEFAULT_GDB_PROXY_IP = "localhost";
	private static final int DEFAULT_GDB_PROXY_PORT = 2000;
	private static final int DEFAULT_GDB_SERVER_PORT = 1234;
	private static final int DEFAULT_KGDB_PORT = 6443;

	private static final String ELF_GDB = "bfin-elf-gdb";
	private static final String FLAT_GDB = "bfin-uclinux-gdb";
	private static final String FDPIC_GDB = "bfin-linux-uclibc-gdb";

	/** ADSP-BF561 and ADSP-BF60x */
	public static final String BF561 = "(?i)bf561";
	public static final String BF60X = "(?i)bf60\\S*";

	/** Ids for the Compiler and Linker Multi-core options */
	public final static String OPTID_CPROJ_CC_MULTICORE_BF561   = ".*\\.c\\.compiler\\.options\\.mcore\\.bf561(\\.\\d+)*";
	public final static String OPTID_CPROJ_LD_MULTICORE_BF561   = ".*\\.c\\.linker\\.options\\.mcore\\.bf561(\\.\\d+)*";
	public final static String OPTID_CPPPROJ_CC_MULTICORE_BF561 = ".*\\.cpp\\.compiler\\.options\\.mcore\\.bf561(\\.\\d+)*";
	public final static String OPTID_CPPPROJ_LD_MULTICORE_BF561 = ".*\\.cpp\\.linker\\.options\\.mcore\\.bf561(\\.\\d+)*";

	public final static String OPTID_CPROJ_CC_MULTICORE   = ".*\\.c\\.compiler\\.options\\.mcore(\\.\\d+)*";
	public final static String OPTID_CPROJ_LD_MULTICORE   = ".*\\.c\\.linker\\.options\\.mcore(\\.\\d+)*";
	public final static String OPTID_CPPPROJ_CC_MULTICORE = ".*\\.cpp\\.compiler\\.options\\.mcore(\\.\\d+)*";
	public final static String OPTID_CPPPROJ_LD_MULTICORE = ".*\\.cpp\\.linker\\.options\\.mcore(\\.\\d+)*";

	/** Private constructor */
	private Utility() { }
	
	/**
	 * Provides low level logging facilities. See IStatus for possible severity
	 * codes.
	 * 
	 * @param plugin The plugin logging the error or message
	 * @param severity The severity of the error
	 * @param code A numeric error code
	 * @param message The error message
	 * @param exception The exception associated with the error
	 * @see org.eclipse.core.runtime.IStatus
	 */
	public static void log(Plugin plugin, int severity, int code, String message, Throwable exception) {
		if(plugin == null) {
			plugin = Activator.getDefault();
		}
		String pluginId = plugin.getBundle().getSymbolicName();
		IStatus status = new Status(severity, pluginId, code, message, exception);
		log(plugin, status);
	}

	/**
	 * Logs an IStatus object to the Error view
	 * 
	 * @param plugin The plugin logging the error
	 * @param status The IStatus object to log
	 * @see org.eclipse.core.runtime.IStatus
	 */
	public static void log(Plugin plugin, IStatus status) {
		if(plugin == null) {
			plugin = Activator.getDefault();
		}
		plugin.getLog().log(status);
	}

	/**
	 * Logs an exception with a custom error message
	 * 
	 * @param plugin The plugin logging the exception
	 * @param message The message to write to the Error view
	 * @param exception The exception to log
	 */
	public static void logError(Plugin plugin, String message, Throwable exception) {
		log(plugin, IStatus.ERROR, IStatus.OK, message, exception);
	}

	/**
	 * Logs an informational message to the Error log
	 * 
	 * @param plugin The plugin logging the message
	 * @param message The informational message to log
	 */
	public static void logInfo(Plugin plugin, String message) {
		log(plugin, IStatus.INFO, IStatus.OK, message, null);
	}

	/**
	 * A simple helper method that retrives the ITool from the passed
	 * IConfiguration that matches the supplied ID
	 * 
	 * @param cfg the configuration to search
	 * @param toolId the tool to retrieve
	 * @return the tool if found or null otherwise
	 */
	public static ITool findTool(final IConfiguration cfg, final String toolId) {
	
		for (ITool tool : cfg.getFilteredTools()) {
			if (tool.getId().matches(toolId)) {
				return tool;
			}
		}
		return null;
	}

	/**
	 * A simple helper method that retrieves the IOption that
	 * matches the supplied ID
	 * 
	 * @param tool the tool to search
	 * @param optId the option to retrieve
	 * @return the option if found or null otherwise
	 */
	public static IOption findOption(final ITool tool, final String optId) {
	
		for (IOption opt : tool.getOptions()) {
			if (opt.getId().matches(optId)) {
				return opt;
			}
		}
		return null;
	}

	/**
	 * Sets the default Multi-core option for ADSP-BF561 and ADSP-BF60x
	 * 
	 * @param cfg      The configuration
	 * @param tool     The tool
	 * @param procType The processor
	 */
	private static void setMultiCoreOptions(final IConfiguration cfg, final ITool tool, final String procType) {
		// Set the default Multi-core option

		if (procType.matches(BF561)) {
			// Compiler tool
			IOption opt = findOption(tool, OPTID_CPROJ_CC_MULTICORE_BF561);
			if (opt != null) {
				final String OPTID_CPROJ_MCOREA = "com.analog.gnu.toolchain.blackfin.c.compiler.options.mcorea";
				ManagedBuildManager.setOption(cfg, tool, opt, OPTID_CPROJ_MCOREA);
			}

			opt = findOption(tool, OPTID_CPPPROJ_CC_MULTICORE_BF561);
			if (opt != null) {
				final String OPTID_CPPPROJ_MCOREA = "com.analog.gnu.toolchain.blackfin.cpp.compiler.options.mcorea";
				ManagedBuildManager.setOption(cfg, tool, opt, OPTID_CPPPROJ_MCOREA);
			}

			// Linker tool
			opt = findOption(tool, OPTID_CPROJ_LD_MULTICORE_BF561);
			if (opt != null) {
				final String OPTID_CPROJ_MCOREA = "com.analog.gnu.toolchain.blackfin.c.linker.options.mcorea";
				ManagedBuildManager.setOption(cfg, tool, opt, OPTID_CPROJ_MCOREA);
			}

			opt = findOption(tool, OPTID_CPPPROJ_LD_MULTICORE_BF561);
			if (opt != null) {
				final String OPTID_CPPPROJ_MCOREA = "com.analog.gnu.toolchain.blackfin.cpp.linker.options.mcorea";
				ManagedBuildManager.setOption(cfg, tool, opt, OPTID_CPPPROJ_MCOREA);
			}
		}
		else if (procType.matches(BF60X)) {
			// Compiler tool
			IOption opt = findOption(tool, OPTID_CPROJ_CC_MULTICORE);
			if (opt != null) {
				final String OPTID_CPROJ_MCORE0 = "com.analog.gnu.toolchain.blackfin.c.compiler.options.mcore0";
				ManagedBuildManager.setOption(cfg, tool, opt, OPTID_CPROJ_MCORE0);
			}

			opt = findOption(tool, OPTID_CPPPROJ_CC_MULTICORE);
			if (opt != null) {
				final String OPTID_CPPPROJ_MCORE0 = "com.analog.gnu.toolchain.blackfin.cpp.compiler.options.mcore0";
				ManagedBuildManager.setOption(cfg, tool, opt, OPTID_CPPPROJ_MCORE0);
			}

			// Linker tool
			opt = findOption(tool, OPTID_CPROJ_LD_MULTICORE);
			if (opt != null) {
				final String OPTID_CPROJ_MCORE0 = "com.analog.gnu.toolchain.blackfin.c.linker.options.mcore0";
				ManagedBuildManager.setOption(cfg, tool, opt, OPTID_CPROJ_MCORE0);
			}

			opt = findOption(tool, OPTID_CPPPROJ_LD_MULTICORE);
			if (opt != null) {
				final String OPTID_CPPPROJ_MCORE0 = "com.analog.gnu.toolchain.blackfin.cpp.linker.options.mcore0";
				ManagedBuildManager.setOption(cfg, tool, opt, OPTID_CPPPROJ_MCORE0);
			}
		}
	}

	/**
	 * sets the processor and revision options for each tool in the tool chain
	 * for each configuration in the project.
	 * Also sets the default Multi-core options depending on processor
	 * 
	 * @param project   Eclipse project to act upon
	 * @param procType  ADI processor type (e.g., "ADSP-21065L")
	 * @param siRev     silicon revision
	 */
	public static void setProcessorAndSiliconRevision(final IProject project, final String procType, final String siRev) {
		//	In order to set the processor and revision options we need to get the 
		// IResourceInfo object associated with each configuration of the project.  
		// Therefore we need to access each configuration.  To get those we need to 
		// get each configuration description in the project.  To get those we need 
		// to get the project description.  To get that we need to use the Project 
		// description manager.  Not sure why we need these objects, I just know it 
		// works.  We also need to make sure that when we get the project description 
		// object we get get a writable copy of it.  Otherwise the changes will not persist.
	
		//	get the project description manager
		final ICProjectDescriptionManager mngr = CoreModel.getDefault().getProjectDescriptionManager();
		//	get a writable copy of the project description
		final ICProjectDescription des = mngr.getProjectDescription(project, 
			true /* writable description */);
		
		//	get an array of all the Configuration Descriptions from the project description
		final ICConfigurationDescription[] cfgDescriptions = des.getConfigurations();
	
		//	step through each configuration description
		for (ICConfigurationDescription cfgDes : cfgDescriptions) {
			//	get the configuration associated with the current configuration description
			//	need configuration to get the resource info object.
			final IConfiguration cfg = ManagedBuildManager.getConfigurationForDescription(cfgDes);
			//	get the Resource Info associated with the current configuration
			//	resource info is needed for call to ManagedBuilderManager.setOption.
			final IResourceInfo res = cfg.getRootFolderInfo();
	
			//	get the array of ITools associated with IResourceInfo. 
			final ITool[] tools = ((IFolderInfo)res).getFilteredTools();
	
			for (ITool tool : tools) {
	
				IOption opt = findOption(tool, OPTID_PROCESSOR);
					
				if(opt == null) {
					continue;
				}
	
				if (procType.equals("Unspecified")) {
					ManagedBuildManager.setOption(cfg, tool, opt, "");
				}
				else {
					ManagedBuildManager.setOption(cfg, tool, opt, procType.toLowerCase() + "-" + siRev);
					setMultiCoreOptions(cfg, tool, procType);
				}
			}
		}
	
		try {
			// now that project has been modified (the options in the tools set) 
			// save the project description.
			CoreModel.getDefault().setProjectDescription(project, des);
		}
		catch (CoreException e) {
			//	log error
			logInfo(Activator.getDefault(), 
				"Failed to save project description.");
		}
	}

	/**
	 * Gets the list of revisions supported by the toolchain's compiler.
	 * 
	 * @param toolchain the toolchain
	 * @param processor the processor target
	 * @return the list of supported revisions for the processor and toolchain
	 */
	public static ArrayList<String> getSupportedRevisions(IToolChain toolchain, String processor) {
		final ArrayList<String> revisions = new ArrayList<String>();
		
		// init list of possible revisions
		revisions.add("any");
		revisions.add("none");
		for (int i = 0; i <= 9; i++ ) {
			revisions.add("0." + i);
		}
		
		ArrayList<String> supportedRevisions = new ArrayList<String>();
		for (ITool t : toolchain.getTools()) {
			if (t.getId().contains(".c.compiler")) {
				
				for (int i = 0; i < revisions.size(); i++) {
					String revision = revisions.get(i);					
				
					boolean supported = false;
					try {
						String compilerCommandLine =  t.getToolCommand()
							+ " -E -P - -mcpu=" + processor.toLowerCase() + "-" + revision;
						Process p = Runtime.getRuntime().exec(compilerCommandLine);
						p.getOutputStream().close();
						p.waitFor();
						supported = (p.exitValue() == 0);
					}
					catch (IOException e) {
						supported = false;
					}
					catch (InterruptedException e) {
						supported = false;
					}
					
					if (supported) {
						supportedRevisions.add(revision);
					}
				}
			}
		}
		
		return supportedRevisions;
	}

	/**
	 * A helper method to retrieve the project being created.
	 * @param pageId	The id of the wizard page that is creating the project 
	 * @return The project being created
	 */
	public static IProject getProject(String pageId) {
		// Get the project being created
		final MBSCustomPageData pageData = MBSCustomPageManager.getPageData(pageId);
		final IWizard wizard = pageData.getWizardPage().getWizard();
		IProject project = null;
		if (wizard instanceof CProjectWizard) {
			project = ((CProjectWizard)wizard).getProject(true);
		}
		else if (wizard instanceof CCProjectWizard) {
			project = ((CCProjectWizard)wizard).getProject(true);
		}
		return project;
	}

	/**
	 * Initializes the default settings for the tabs in the GDB JTAG
	 * debugger plugin, based on the launch configuration type selected by the
	 * user.  For example, if the user chooses Blackfin Linux App (FLAT), then
	 * the gdb command will be set to bfin-linux-gdb.
	 * 
	 * @param configuration - the launch configuration
	 */
	public static void initDefaults(ILaunchConfigurationWorkingCopy configuration) {
		try {
			ILaunchConfigurationType type = configuration.getType();
			String id = type.getIdentifier();
			
			if (id.equals("gdb.app.flat.launchConfigurationType")) {
				setCommonAttributes(configuration, FLAT_GDB);
				setGDBServerAttributes(configuration);
			}
			else if (id.equals("gdb.kernel.flat.launchConfigurationType")) {
				setCommonAttributes(configuration, FLAT_GDB);
				setKGDBAttributes(configuration);
			}			
			else if (id.equals("gdb.app.fdpic.launchConfigurationType")) {
				setCommonAttributes(configuration, FDPIC_GDB);
				setGDBServerAttributes(configuration);				
			}
			else {
				// the user has selected one of the ELF launch configuration types
				setCommonAttributes(configuration, ELF_GDB);
				
				/* Default timeout (~10 seconds) is too short for the gnICE + gdbproxy */
				Preferences prefs = MIPlugin.getDefault().getPluginPreferences();
				if (prefs.getInt(IMIConstants.PREF_REQUEST_TIMEOUT) <= IMIConstants.DEF_REQUEST_TIMEOUT * 3) {
					prefs.setValue(IMIConstants.PREF_REQUEST_TIMEOUT, IMIConstants.DEF_REQUEST_TIMEOUT * 3);
				}
				
				if (id.equals("gdb.app.elf.launchConfigurationType")) {
					setBareMetalAppAttributes(configuration);
				}
				else if (id.equals("gdb.app.elf.sim.launchConfigurationType")) {
					setSimulatorAttributes(configuration);
				}
				else if (id.equals("gdb.kernel.elf.launchConfigurationType")) {
					setKGDBAttributes(configuration);
				}				
			}
			configuration.doSave();			  
		}
		catch (CoreException e) {
			e = null;
		}
	}
	
	/**
	 * Sets up the debugger and startup tab attributes.
	 * 
	 * @param configuration - the launch configuration
	 * @param debugger - debugger command
	 */
	private static void setCommonAttributes(ILaunchConfigurationWorkingCopy configuration,
			String debugger) {
		boolean isJtagDebugger =  debugger.equals(ELF_GDB);
		
		/* Setup the Debugger tab */
		configuration.setAttribute(IMILaunchConfigurationConstants.ATTR_DEBUG_NAME, debugger);
		configuration.setAttribute(IMILaunchConfigurationConstants.ATTR_DEBUGGER_COMMAND_FACTORY, "Standard");
		configuration.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, true);
		configuration.setAttribute(IGDBJtagConstants.ATTR_JTAG_DEVICE, "Generic TCP/IP");
		if (isJtagDebugger) {
			configuration.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, DEFAULT_GDB_PROXY_IP);
			configuration.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, DEFAULT_GDB_PROXY_PORT);
		}
		else {
			configuration.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, DEFAULT_BLACKFIN_IP);
			configuration.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, DEFAULT_GDB_SERVER_PORT);
		}		
		
		/* Setup the Startup tab */		
		configuration.setAttribute(IGDBJtagConstants.ATTR_LOAD_IMAGE, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_LOAD_SYMBOLS, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_DO_RESET, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_DO_HALT, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_PC_REGISTER, false);
		if (!isJtagDebugger) {
			configuration.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, "");
		}
		else {
			//String gdbserverHost = getAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, defaultBlackfinIP);
			String[] init = {
					"set remotetimeout 300",
					/*
					"rcp \"" + program + "\" " + gdbserverHost + ".root:/eclipse-cdt-debug",
					"rsh " + gdbserverHost + " -l root chmod a+rx /eclipse-cdt-debug",
					"rsh " + gdbserverHost + " -l root gdbserver :" +  getAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, defaultGDBServerPort) + " /eclipse-cdt-debug",
					*/
			};
			configuration.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, joinStrings(init, "\r\n"));
		}
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, true);
		configuration.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "main");
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, true);
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

	/**
	 * Sets up the attributes for kernel debugging
	 * 
	 * @param configuration - the launch configuration
	 */
	private static void setKGDBAttributes(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, DEFAULT_BLACKFIN_IP);
		configuration.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, DEFAULT_KGDB_PORT);
		configuration.setAttribute(IGDBJtagConstants.ATTR_DO_RESET, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_DO_HALT, false);
		String[] init = {
				"target remote udp:" + DEFAULT_BLACKFIN_IP + ":" + DEFAULT_KGDB_PORT,
				"load"
		};
		configuration.setAttribute(IGDBJtagConstants.ATTR_LOAD_IMAGE, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_LOAD_SYMBOLS, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, joinStrings(init, "\r\n"));
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_PC_REGISTER, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "");
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, true);
	}

	/**
	 * Sets up the attributes for debugging with gdbserver
	 * 
	 * @param configuration - the launch configuration
	 */
	private static void setGDBServerAttributes(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, true);
		configuration.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, DEFAULT_BLACKFIN_IP);
		configuration.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, DEFAULT_GDB_SERVER_PORT);
		configuration.setAttribute(IGDBJtagConstants.ATTR_DO_RESET, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_DO_HALT, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_LOAD_IMAGE, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_LOAD_SYMBOLS, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_PC_REGISTER, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, true);
		configuration.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "main");
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, true);
	}

	/**
	 * Sets up the attributes for debugging a bare metal app with gnICE
	 * 
	 * @param configuration - the launch configuration
	 */	
	private static void setBareMetalAppAttributes(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, true);
		configuration.setAttribute(IGDBJtagConstants.ATTR_JTAG_DEVICE, "Generic");
		configuration.setAttribute(IGDBJtagConstants.ATTR_IP_ADDRESS, DEFAULT_GDB_PROXY_IP);
		configuration.setAttribute(IGDBJtagConstants.ATTR_PORT_NUMBER, DEFAULT_GDB_PROXY_PORT);
		String[] init = {
				"set remotetimeout 300",
				"load"
		};
		configuration.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, joinStrings(init, "\r\n"));
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, true);
		configuration.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "main");
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, true);
	}
	
	/**
	 * Sets up the attributes for debugging a bare metal app with simulator
	 * 
	 * @param configuration - the launch configuration
	 */	
	private static void setSimulatorAttributes(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(IGDBJtagConstants.ATTR_USE_REMOTE_TARGET, false);
		String[] init = {
				"target sim",
				"load"
		};
		configuration.setAttribute(IGDBJtagConstants.ATTR_INIT_COMMANDS, joinStrings(init, "\r\n"));
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_STOP_AT, false);
		configuration.setAttribute(IGDBJtagConstants.ATTR_STOP_AT, "");
		configuration.setAttribute(IGDBJtagConstants.ATTR_SET_RESUME, false);
	}	
	
	/**
	 * Joins an array of string into one string and separate them with the delimiter.
	 * 
	 * @param list array of strings
	 * @param delimiter delimiter string
	 * @return joined strings
	 */
	public static String joinStrings(String[] list, String delimiter) {
		int i;
		String ret = "";
		for (i = 0; i < list.length - 1; ++i) {
			ret += list[i] + delimiter;
		}
		return ret + list[i];
	}
}
