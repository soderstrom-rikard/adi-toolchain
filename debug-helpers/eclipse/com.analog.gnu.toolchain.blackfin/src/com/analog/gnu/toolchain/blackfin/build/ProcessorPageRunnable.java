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
package com.analog.gnu.toolchain.blackfin.build;

import org.eclipse.cdt.managedbuilder.core.IConfiguration;
import org.eclipse.cdt.managedbuilder.core.IManagedBuildInfo;
import org.eclipse.cdt.managedbuilder.core.ManagedBuildManager;
import org.eclipse.cdt.managedbuilder.ui.wizards.MBSCustomPageManager;
import org.eclipse.core.resources.IProject;

import com.analog.gnu.toolchain.blackfin.Activator;
import com.analog.gnu.toolchain.blackfin.Utility;

/**
 * ProcessorPageRunnable applies the options set in the Select Processor
 * dialog of the Project Wizard to the project being created.
 *
 * @see com.analog.visualdsp.managedbuilder.ui.ProcessorPage
 */
public class ProcessorPageRunnable implements Runnable {

	/** a regex that matches the processor switch option id */
	public final static String OPTID_PROCESSOR = ".*\\.option\\.proc(\\.\\d+)*";

	/**
	 * Default constructor
	 */
	public ProcessorPageRunnable() {
	}

	/**
	 * Perform the logic for the ProcessorPage dialog when the user finishes
	 * the project wizard.
	 *
	 * Associate the appropriate toolchain with each configuration, and
	 * make the Debug configuration the default.
	 *
	 * @see java.lang.Runnable#run()
	 */
	public void run() {
		final IProject project = Utility.getProject(ProcessorPage.PAGE_ID);
		final IManagedBuildInfo buildInfo = ManagedBuildManager.getBuildInfo(project);
		final IConfiguration[] configurations = buildInfo.getManagedProject().getConfigurations();

		//	set the tool options for the processor and revision
		setToolOptions(project, configurations[0].getToolChain().getUniqueRealName());

		ManagedBuildManager.saveBuildInfo(project, true);
	}
	
	/**
	 * sets the processor and revision options for each tool in the tool chain for each configuration in the project.
	 * @param project		the project that the options are being set in.
	 * @param toolChainName the name of the tool chain.
	 */
	public void setToolOptions(final IProject project, final String toolChainName)	{
		//	declare and initialize the processor and revision string variables
		String processor = null;
		String revision = null;
		final ProcessorInfo procInfo = ProcessorInfo.getInstance();
		
		try {
			//	get the processor value from the wizard page
			processor = MBSCustomPageManager.getPageProperty(ProcessorPage.PAGE_ID, "Processor").toString();
			//	get the revision value from the wizard page
			revision = MBSCustomPageManager.getPageProperty(ProcessorPage.PAGE_ID, "Revision").toString();
		}
		catch (NullPointerException npe) {
			npe = null;
			
			//	if exception occurs then get default values for both the processor and revision
			processor = procInfo.getAllProcessors().get(0);
			if (processor.isEmpty()) {
				Utility.logInfo(Activator.getDefault(),
						"No processor information is available.");
				return;
			}
			revision = "any";
		}
		
		if (processor == null) {
			return;
		}
		
		Utility.setProcessorAndSiliconRevision(project, processor, revision);
	}
}
