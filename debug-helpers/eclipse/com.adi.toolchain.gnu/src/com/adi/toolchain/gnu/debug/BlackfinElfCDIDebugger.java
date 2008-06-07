/**
 * Copyright Analog Devices, Inc. 2008
 * Licensed under the GPL-2
 */

package com.adi.toolchain.gnu.debug;

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
