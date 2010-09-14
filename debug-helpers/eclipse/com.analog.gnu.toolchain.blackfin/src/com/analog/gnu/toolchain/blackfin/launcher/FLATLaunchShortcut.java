/*******************************************************************************
 * Copyright (c) 2005, 2007 QNX Software Systems and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 * QNX Software Systems - Initial API and implementation
 * Ken Ryall (Nokia) - bug 178731
 * Analog Devices, Inc - adapted for VisualDSP++
 *******************************************************************************/
package com.analog.gnu.toolchain.blackfin.launcher;

import java.io.FilenameFilter;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.eclipse.cdt.core.model.CModelException;
import org.eclipse.cdt.core.model.CoreModel;
import org.eclipse.cdt.core.model.ICProject;
import org.eclipse.cdt.core.model.IPathEntry;
import org.eclipse.cdt.debug.core.ICDTLaunchConfigurationConstants;
import org.eclipse.cdt.debug.core.ICDebugConfiguration;
import org.eclipse.cdt.internal.core.model.OutputEntry;
import org.eclipse.core.internal.resources.File;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.Path;
import org.eclipse.core.runtime.SubProgressMonitor;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationType;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.DebugUITools;
import org.eclipse.debug.ui.ILaunchGroup;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.dialogs.ProgressMonitorDialog;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.ui.IEditorPart;
import com.analog.gnu.toolchain.blackfin.Activator;
import com.analog.gnu.toolchain.blackfin.Utility;

/** OutputEntry and File causes warnings */
@SuppressWarnings("restriction")

/**
 * Launch shortcut class for FLAT target.
 */
public class FLATLaunchShortcut extends LaunchShortcut {

	/**
	 * Locates a launchable entity in the given active editor, and launches an
	 * application in the specified mode.
	 * 
	 * @param editor the active editor in the workbench
	 * @param mode one of the launch modes defined by the launch manager
	 */
	public void launch(IEditorPart editor, String mode) {
		searchAndLaunch(new Object[] { editor.getEditorInput() }, mode);
	}

	/**
	 * Locates a launchable entity in the given selection and launches an
	 * application in the specified mode.
	 * 
	 * @param selection workbench selection
	 * @param mode one of the launch modes defined by the launch manager
	 */
	public void launch(ISelection selection, String mode) {
		if (selection instanceof IStructuredSelection) {
			searchAndLaunch(((IStructuredSelection)selection).toArray(), mode);
		}
	}
	
	/**
	 * Locates a launchable entity in the given binary and launches an
	 * application in the specified mode.
	 * 
	 * @param file the .gdb file
	 * @param mode one of the launch modes defined by the launch manager
	 */
	public void launch(File file, String mode) {
		ILaunchConfiguration config = findLaunchConfiguration(file, mode);
		if (config != null) {
			DebugUITools.launch(config, mode);
		}
	}

	/**
	 * Locate a configuration to relaunch for the given type. If one cannot be
	 * found, create one.
	 * 
	 * @param file the .gdb file
	 * @param mode one of the launch modes defined by the launch manager
	 * @return a re-useable config or <code>null</code> if none
	 */
	@SuppressWarnings("unchecked")
	protected ILaunchConfiguration findLaunchConfiguration(File file, String mode) {
		ILaunchConfiguration configuration = null;
		ILaunchConfigurationType configType = getCLaunchConfigType();
		List<ILaunchConfiguration> candidateConfigs = Collections.EMPTY_LIST;
		try {
			ILaunchConfiguration[] configs = DebugPlugin.getDefault().getLaunchManager()
				.getLaunchConfigurations(configType);
			candidateConfigs = new ArrayList<ILaunchConfiguration>(configs.length);
			for (int i = 0; i < configs.length; i++) {
				ILaunchConfiguration config = configs[i];
				String programPath = config.getAttribute(
					ICDTLaunchConfigurationConstants.ATTR_PROGRAM_NAME, (String)null);
				String projectName = config.getAttribute(
					ICDTLaunchConfigurationConstants.ATTR_PROJECT_NAME, (String)null);
				IPath name = file.getProjectRelativePath();
				Path p = new Path(programPath);
				if (p.isAbsolute()) {
					IPath projectPath = file.getProject().getLocation();
					IPath relPath = p.makeRelativeTo(projectPath);
					programPath = relPath.toOSString();
				}
				if (programPath != null && programPath.equals(name.toString())) {
					if (projectName != null
						&& projectName.equals(file.getProject().getName())) {
						candidateConfigs.add(config);
					}
				}
			}
		}
		catch (CoreException e) {
			e.printStackTrace();
		}

		// If there are no existing configs associated with the IBinary, create
		// one.
		// If there is exactly one config associated with the IBinary, return
		// it.
		// Otherwise, if there is more than one config associated with the
		// IBinary, prompt the
		// user to choose one.
		int candidateCount = candidateConfigs.size();
		if (candidateCount < 1) {
			createConfiguration(file, null, mode);
		}
		else if (candidateCount == 1) {
			configuration = (ILaunchConfiguration)candidateConfigs.get(0);
		}
		else {
			// Prompt the user to choose a config. A null result means the user
			// cancelled the dialog, in which case this method returns null,
			// since cancelling the dialog should also cancel launching
			// anything.
			configuration = chooseConfiguration(candidateConfigs, mode);
		}
		return configuration;
	}

	/**
	 * Creates a new launch configuration.
	 * @param file the .gdb file
	 * @param debugConfig the list of debug configurations
	 * @param mode one of the launch modes defined by the launch manager
	 */
	@SuppressWarnings("deprecation")
	private void createConfiguration(File file, ICDebugConfiguration debugConfig, String mode) {
		try {
			String projectName = file.getProject().getName();
			ILaunchConfigurationType configType = getCLaunchConfigType();
			ILaunchConfigurationWorkingCopy wc = configType.newInstance(null, getLaunchManager()
				.generateUniqueLaunchConfigurationNameFrom(projectName));
			wc.setAttribute(ICDTLaunchConfigurationConstants.ATTR_PROJECT_NAME, projectName);
			String programName = file.getProjectRelativePath().toString();			
			wc.setAttribute(ICDTLaunchConfigurationConstants.ATTR_PROGRAM_NAME, programName);
			
			Utility.initDefaults(wc);
			
			ILaunchConfiguration config = wc.doSave();
			ILaunchGroup group = DebugUITools.getLaunchGroup(config, mode);
			if (group != null) {
				DebugUITools.openLaunchConfigurationDialogOnGroup(
					Activator.getDefault().getWorkbench().getActiveWorkbenchWindow().getShell(),
					new StructuredSelection(config), group.getIdentifier());
			}
		}
		catch (CoreException ce) {
			ce.printStackTrace();
		}
	}
	/**
	 * @return FDPIC launch configuration type.
	 */
	protected ILaunchConfigurationType getCLaunchConfigType() {
		return getLaunchManager().getLaunchConfigurationType(
			"gdb.app.flat.launchConfigurationType");
	}

	/**
	 * Searches for executables and launches the configuration.
	 * 
	 * @param elements list of binary objects
	 * @param mode the launch mode
	 */
	private void searchAndLaunch(final Object[] elements, String mode) {
		if (elements != null && elements.length > 0) {
			File file = null;
			if (elements.length == 1 && elements[0] instanceof File &&
				((File)elements[0]).getFileExtension().equals("gdb")) {
				file = (File)elements[0];
			}
			else {
				final List<File> results = new ArrayList<File>();
				ProgressMonitorDialog dialog = new ProgressMonitorDialog(getShell());
				IRunnableWithProgress runnable = new IRunnableWithProgress() {
					public void run(IProgressMonitor pm) throws InterruptedException {
						int nElements = elements.length;
						pm.beginTask("Looking for .gdb files", nElements); //$NON-NLS-1$
						try {
							IProgressMonitor sub = new SubProgressMonitor(pm, 1);
							for (int i = 0; i < nElements; i++) {
								if (elements[i] instanceof IAdaptable) {
									IResource r = (IResource)((IAdaptable)elements[i])
										.getAdapter(IResource.class);
									if (r != null) {
										ICProject cproject = CoreModel.getDefault().create(
											r.getProject());
										if (cproject != null) {
											try {
												IPathEntry[] paths = cproject.getRawPathEntries();
												for (int j = 0; j<paths.length; j++) {
													if (paths[j] instanceof OutputEntry) {
														OutputEntry oe = (OutputEntry) paths[j];
														String outputPath = oe.getPath().lastSegment();
														IPath path = cproject.getProject().getLocation().append(outputPath);
														
														// now find the .gdb file in the output dir
														java.io.File dir = new java.io.File(path.toOSString());
														FilenameFilter filter = new FilenameFilter() {
															public boolean accept(java.io.File dir, String name) {
																return name.endsWith(".gdb");
															}
														};
														String[] children = dir.list(filter);
														if (children != null) {
															for (int k=0; k<children.length; k++) {
																Path p = new Path(outputPath);
																p.append(children[k]);
																File f = (File)cproject.getProject().getFile(outputPath + "/" + children[k]);
																results.add(f);
															}
														}
													}
												}
											}
											catch (CModelException e) {
												e.getMessage();
											}
										}
									}
								}
								if (pm.isCanceled()) {
									throw new InterruptedException();
								}
								sub.done();
							}
						}
						finally {
							pm.done();
						}
					}
				};
				try {
					dialog.run(true, true, runnable);
				}
				catch (InterruptedException e) {
					return;
				}
				catch (InvocationTargetException e) {
					MessageDialog.openError(getShell(), LaunchUIMessages
						.getString("CApplicationLaunchShortcut.Application_Launcher"), e
						.getMessage()); //$NON-NLS-1$
					return;
				}
				int count = results.size();
				if (count == 0) {
					MessageDialog.openError(getShell(), LaunchUIMessages
						.getString("CApplicationLaunchShortcut.Application_Launcher"),
						"Launch failed.  .gdb file not found.");
				}
				else {
					// if there are multiple programs in the project, choose
					// the first one as the default.  the user can later on pick
					// a different program if it's not the right one
					file = results.get(0);
				}
			}
			if (file != null) {
				launch(file, mode);
			}
		}
		else {
			MessageDialog.openError(getShell(), LaunchUIMessages
				.getString("CApplicationLaunchShortcut.Application_Launcher"), LaunchUIMessages
				.getString("CApplicationLaunchShortcut.Launch_failed_no_project_selected"));
		}
	}
}
