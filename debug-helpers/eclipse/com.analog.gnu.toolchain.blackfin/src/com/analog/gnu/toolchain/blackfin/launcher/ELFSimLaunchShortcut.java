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
package com.analog.gnu.toolchain.blackfin.launcher;

import org.eclipse.debug.core.ILaunchConfigurationType;

/**
 * Launch shortcut class for ELF simulator target.
 */
public class ELFSimLaunchShortcut extends LaunchShortcut {

	/**
	 * @return ELF simulator launch configuration type.
	 */	
	@Override
	protected ILaunchConfigurationType getCLaunchConfigType() {
		return getLaunchManager().getLaunchConfigurationType(
			"gdb.app.elf.sim.launchConfigurationType");
	}
}
