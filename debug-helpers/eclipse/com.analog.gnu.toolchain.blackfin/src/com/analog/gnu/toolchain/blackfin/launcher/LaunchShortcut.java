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

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.eclipse.cdt.core.model.CModelException;
import org.eclipse.cdt.core.model.CoreModel;
import org.eclipse.cdt.core.model.IBinary;
import org.eclipse.cdt.core.model.ICProject;
import org.eclipse.cdt.debug.core.ICDTLaunchConfigurationConstants;
import org.eclipse.cdt.debug.core.ICDebugConfiguration;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.SubProgressMonitor;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationType;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.core.ILaunchManager;
import org.eclipse.debug.ui.DebugUITools;
import org.eclipse.debug.ui.IDebugModelPresentation;
import org.eclipse.debug.ui.ILaunchGroup;
import org.eclipse.debug.ui.ILaunchShortcut;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.dialogs.ProgressMonitorDialog;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.jface.window.Window;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.dialogs.ElementListSelectionDialog;

import com.analog.gnu.toolchain.blackfin.Activator;
import com.analog.gnu.toolchain.blackfin.Utility;

/**
 * A LaunchShortcut launches a selection or active editor in the workbench.
 */
abstract public class LaunchShortcut implements ILaunchShortcut {

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
	 * @param bin binary executable selection
	 * @param mode one of the launch modes defined by the launch manager
	 */
	public void launch(IBinary bin, String mode) {
		ILaunchConfiguration config = findLaunchConfiguration(bin, mode);
		if (config != null) {
			DebugUITools.launch(config, mode);
		}
	}

	/**
	 * Locate a configuration to relaunch for the given type. If one cannot be
	 * found, create one.
	 * 
	 * @param bin binary executable selection
	 * @param mode one of the launch modes defined by the launch manager
	 * @return a re-useable config or <code>null</code> if none
	 */
	@SuppressWarnings("unchecked")
	protected ILaunchConfiguration findLaunchConfiguration(IBinary bin, String mode) {
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
				IPath name = bin.getResource().getProjectRelativePath();
				if (programPath != null && programPath.equals(name.toString())) {
					if (projectName != null
						&& projectName.equals(bin.getCProject().getProject().getName())) {
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
			createConfiguration(bin, null, mode);
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
	 * 
	 * @param bin the binary executable
	 * @param debugConfig the list of debug configurations
	 * @param mode one of the launch modes defined by the launch manager
	 */
	@SuppressWarnings("deprecation")
	private void createConfiguration(IBinary bin, ICDebugConfiguration debugConfig, String mode) {
		try {
			ILaunchConfigurationType configType = getCLaunchConfigType();
			ILaunchConfigurationWorkingCopy wc = configType.newInstance(null, getLaunchManager()
				.generateUniqueLaunchConfigurationNameFrom(bin.getElementName()));
			wc.setAttribute(ICDTLaunchConfigurationConstants.ATTR_PROJECT_NAME, bin
				.getCProject().getElementName());
			String programName = bin.getResource().getProjectRelativePath().toString();			
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
	 * Method getCLaunchConfigType.
	 * 
	 * @return ILaunchConfigurationType
	 */
	abstract protected ILaunchConfigurationType getCLaunchConfigType();
	
	/**
	 * @return the launch manager
	 */
	protected ILaunchManager getLaunchManager() {
		return DebugPlugin.getDefault().getLaunchManager();
	}

	/**
	 * Convenience method to get the window that owns this action's Shell.
	 * 
	 * @return the workbench shell
	 */
	protected Shell getShell() {
		IWorkbenchWindow w = Activator.getDefault().getWorkbench().getActiveWorkbenchWindow();
		if (w != null) {
			return w.getShell();
		}
		return null;
	}

	/**
	 * @return the debug configuration property string
	 */
	protected String getDebugConfigDialogTitleString() {
		return LaunchUIMessages.getString("CApplicationLaunchShortcut.LaunchDebugConfigSelection"); //$NON-NLS-1$
	}

	/**
	 * @param mode the launch mode
	 * @return the configuration property string
	 */
	protected String getDebugConfigDialogMessageString(String mode) {
		if (mode.equals(ILaunchManager.DEBUG_MODE)) {
			return LaunchUIMessages.getString("CApplicationLaunchShortcut.ChooseConfigToDebug"); //$NON-NLS-1$
		}
		else if (mode.equals(ILaunchManager.RUN_MODE)) {
			return LaunchUIMessages.getString("CApplicationLaunchShortcut.ChooseConfigToRun"); //$NON-NLS-1$
		}
		return LaunchUIMessages.getString("CApplicationLaunchShortcut.Invalid_launch_mode_1"); //$NON-NLS-1$
	}

	/**
	 * Show a selection dialog that allows the user to choose one of the
	 * specified launch configurations. Return the chosen config, or
	 * <code>null</code> if the user cancelled the dialog.
	 * 
	 * @param configList the list of configurations to choose from
	 * @param mode the launch mode
	 * @return the selected launch configuration
	 */
	protected ILaunchConfiguration chooseConfiguration(List<ILaunchConfiguration> configList, String mode) {
		IDebugModelPresentation labelProvider = DebugUITools.newDebugModelPresentation();
		ElementListSelectionDialog dialog = new ElementListSelectionDialog(getShell(),
			labelProvider);
		dialog.setElements(configList.toArray());
		dialog.setTitle(getLaunchSelectionDialogTitleString());
		dialog.setMessage(getLaunchSelectionDialogMessageString(mode));
		dialog.setMultipleSelection(false);
		int result = dialog.open();
		labelProvider.dispose();
		if (result == Window.OK) {
			return (ILaunchConfiguration)dialog.getFirstResult();
		}
		return null;
	}

	/**
	 * @return the launch selection dialog title property string
	 */
	protected String getLaunchSelectionDialogTitleString() {
		return LaunchUIMessages.getString("CApplicationLaunchShortcut.LaunchConfigSelection"); //$NON-NLS-1$
	}

	/**
	 * @param mode the launch mode
	 * @return the launch selection dialog message property string
	 */
	protected String getLaunchSelectionDialogMessageString(String mode) {
		if (mode.equals(ILaunchManager.DEBUG_MODE)) {
			return LaunchUIMessages
				.getString("CApplicationLaunchShortcut.ChooseLaunchConfigToDebug"); //$NON-NLS-1$
		}
		else if (mode.equals(ILaunchManager.RUN_MODE)) {
			return LaunchUIMessages.getString("CApplicationLaunchShortcut.ChooseLaunchConfigToRun"); //$NON-NLS-1$
		}
		return LaunchUIMessages.getString("CApplicationLaunchShortcut.Invalid_launch_mode_2"); //$NON-NLS-1$
	}

	/**
	 * Searches for executables and launches the configuration.
	 * 
	 * @param elements list of binary objects
	 * @param mode the launch mode
	 */
	private void searchAndLaunch(final Object[] elements, String mode) {
		if (elements != null && elements.length > 0) {
			IBinary bin = null;
			if (elements.length == 1 && elements[0] instanceof IBinary) {
				bin = (IBinary)elements[0];
			}
			else {
				final List<IBinary> results = new ArrayList<IBinary>();
				ProgressMonitorDialog dialog = new ProgressMonitorDialog(getShell());
				IRunnableWithProgress runnable = new IRunnableWithProgress() {
					public void run(IProgressMonitor pm) throws InterruptedException {
						int nElements = elements.length;
						pm.beginTask("Looking for executables", nElements); //$NON-NLS-1$
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
												IBinary[] bins = cproject.getBinaryContainer()
													.getBinaries();

												for (int j = 0; j < bins.length; j++) {
													if (bins[j].isExecutable()) {
														results.add(bins[j]);
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
						LaunchUIMessages
							.getString("CApplicationLaunchShortcut.Launch_failed_no_binaries"));
				}
				else {
					// if there are multiple programs in the project, choose
					// the first one as the default.  the user can later on pick
					// a different program if it's not the right one
					bin = (IBinary)results.get(0);
				}
			}
			if (bin != null) {
				launch(bin, mode);
			}
		}
		else {
			MessageDialog.openError(getShell(), LaunchUIMessages
				.getString("CApplicationLaunchShortcut.Application_Launcher"), LaunchUIMessages
				.getString("CApplicationLaunchShortcut.Launch_failed_no_project_selected"));
		}
	}
}
