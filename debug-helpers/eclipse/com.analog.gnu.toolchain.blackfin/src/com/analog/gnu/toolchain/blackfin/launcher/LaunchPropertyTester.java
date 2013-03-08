/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial implementation
 *     Ken Ryall (Nokia) - Modified to launch on a project context.
 *     Analog Devices, Inc - adapted for VisualDSP++
 *******************************************************************************/
package com.analog.gnu.toolchain.blackfin.launcher;

import org.eclipse.cdt.core.model.CoreModel;
import org.eclipse.cdt.core.model.IBinary;
import org.eclipse.cdt.core.model.ICElement;
import org.eclipse.cdt.core.model.ICProject;
import org.eclipse.cdt.managedbuilder.core.IManagedBuildInfo;
import org.eclipse.cdt.managedbuilder.core.IProjectType;
import org.eclipse.cdt.managedbuilder.core.ManagedBuildManager;
import org.eclipse.core.expressions.PropertyTester;
import org.eclipse.core.internal.resources.File;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.IAdaptable;

/** org.eclipse.core.internal.resources.File causes warnings */
@SuppressWarnings("restriction")

/**
 * A property tester that determines if a file is an executable.
 */
public class LaunchPropertyTester extends PropertyTester {

	/**
	 * Executes the property test determined by the parameter property. 
	 * @param receiver the receiver of the property test
	 * @param property the property to test
	 * @param args additional arguments to evaluate the property.
	 * @param expectedValue the expected value of the property. 
	 * @return returns true if the property is equal to the expected value; otherwise false is returned
	 */
	public boolean test(Object receiver, String property, Object[] args, Object expectedValue) {
		if ("isFLATExecutable".equals(property)) { //$NON-NLS-1$
			return isGDBFile(receiver);
		}		
		else if ("isFDPICExecutable".equals(property)) { //$NON-NLS-1$
			return isExecutable(receiver,
				"com.analog.gnu.toolchain.blackfin.target.bfin.linux.uclibc.exe");
		}
		else if ("isELFExecutable".equals(property)) { //$NON-NLS-1$
			return isExecutable(receiver,
				"com.analog.gnu.toolchain.blackfin.target.bfin.elf.exe");
		}		
		else if ("isCProject".equals(property)) {//$NON-NLS-1$
			return isCProject(receiver);
		}
		else if ("isFLATProject".equals(property)) {//$NON-NLS-1$
			return isProjectType(receiver,
				"com.analog.gnu.toolchain.blackfin.target.bfin.uclinux.exe");
		}
		else if ("isFDPICProject".equals(property)) {//$NON-NLS-1$
			return isProjectType(receiver,
				"com.analog.gnu.toolchain.blackfin.target.bfin.linux.uclibc.exe");
		}
		else if ("isELFProject".equals(property)) {//$NON-NLS-1$
			return isProjectType(receiver,
				"com.analog.gnu.toolchain.blackfin.target.bfin.elf.exe");
		}		
		else {
			return false;
		}
	}

	/**
	 * Checks if the given file has a .gdb extension
	 * 
	 * @param receiver the file object
	 * @return true if the given file has a .gdb extension
	 */
	private boolean isGDBFile(Object receiver) {
		if (receiver instanceof File) {
			File f = (File)receiver;
			String ext = f.getFileExtension();
			if (ext != null && ext.equals("gdb")) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Tests for an executable resource and if it's part of a project of the
	 * given type.
	 *  
	 * @param receiver the receiver of the property test
	 * @param id the project type id to check against	 * 
	 * @return returns true if this resource is executable and part of a
	 * project of the given type
	 */
	private boolean isExecutable(Object receiver, String id) {
		ICElement celement = null;
		if (receiver instanceof IAdaptable) {
			IResource res = (IResource)((IAdaptable)receiver).getAdapter(IResource.class);
			if (res != null) {
				celement = CoreModel.getDefault().create(res);
			}
		}
		if (celement != null && celement instanceof IBinary) {
			IProject project = celement.getCProject().getProject();
			if (isProjectType(project, id)) {
				return true;
			}
		}
		return false;		
	}

	/**
	 * Tests for a C project resource.
	 *  
	 * @param receiver the receiver of the property test
	 * @return returns true if this resource is a C project
	 */
	private boolean isCProject(Object receiver) {
		if (receiver instanceof IProject) {
			return CoreModel.hasCNature((IProject)receiver);
		}
		return (receiver instanceof ICProject);
	}

	/**
	 * Tests if a project is a C project and of the given type.
	 *  
	 * @param receiver the receiver of the property test
	 * @param id the project type id to check against
	 * @return returns true if the project is a C project and of
	 * the given type
	 */
	private boolean isProjectType(Object receiver, String id) {
		if (isCProject(receiver)) {
			IProject project = null;
			if (receiver instanceof IProject) {
				project = (IProject) receiver;
			}
			else if (receiver instanceof ICProject) {
				ICProject cProject = (ICProject)receiver;
				project = cProject.getProject();
			}
			if (project != null) {
				IManagedBuildInfo buildInfo = ManagedBuildManager.getBuildInfo(project);
				IProjectType projectType = buildInfo.getManagedProject().getProjectType();
				if (projectType != null) {
					String projectTypeId = projectType.getId();
					if (projectTypeId.equals(id)) {
						return true;
					}
				}
			}
		}
		return false;
	}	
}
