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

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.cdt.debug.mi.core.GDBServerCDIDebugger2;
import org.eclipse.cdt.debug.mi.core.IMILaunchConfigurationConstants;
import org.eclipse.core.runtime.Path;

public class BlackfinElfCDIDebugger extends GDBServerCDIDebugger2 {
	protected IPath getGDBPath( ILaunch launch ) throws CoreException {
		ILaunchConfiguration config = launch.getLaunchConfiguration();
		return new Path( config.getAttribute( IMILaunchConfigurationConstants.ATTR_DEBUG_NAME, "bfin-elf-gdb" ) );
	}

}
