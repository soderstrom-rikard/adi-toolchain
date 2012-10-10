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
package com.analog.gnu.toolchain.blackfin.parser;

import org.eclipse.cdt.core.ICExtension;
import org.eclipse.cdt.core.ICExtensionReference;

import org.eclipse.cdt.managedbuilder.core.IManagedBuildInfo;
import org.eclipse.cdt.managedbuilder.core.ManagedBuildManager;
import org.eclipse.cdt.utils.DefaultGnuToolFactory;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;

@SuppressWarnings("deprecation")
public class BlackfinToolFactory extends DefaultGnuToolFactory {
	public BlackfinToolFactory(ICExtension ext) {
		super(ext);
	}

	private IPath getTool(String tool) {
		ICExtensionReference ref = fExtension.getExtensionReference();
		String value =  ref.getExtensionData(tool);
		if (value == null || value.length() == 0) {
			IManagedBuildInfo buildInfo = ManagedBuildManager.getBuildInfo(fExtension.getProject());
			String toolCheat = buildInfo.getToolForSource("c"); //$NON-NLS-1$
			value = toolCheat.substring(0, toolCheat.lastIndexOf('-') + 1) + tool; //$NON-NLS-1$
		}
		return new Path(value);
	}

	protected IPath getAddr2linePath() {
		return getTool("addr2line"); //$NON-NLS-1$
	}

	protected IPath getObjdumpPath() {
		return getTool("objdump"); //$NON-NLS-1$
	}

	protected IPath getCPPFiltPath() {
		return getTool("c++filt"); //$NON-NLS-1$
	}

	protected IPath getStripPath() {
		return getTool("strip"); //$NON-NLS-1$
	}

	protected IPath getNMPath() {
		return getTool("nm"); //$NON-NLS-1$
	}
}
