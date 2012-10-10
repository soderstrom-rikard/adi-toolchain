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

import org.eclipse.cdt.debug.gdbjtag.core.jtagdevice.DefaultGDBJtagDeviceImpl;

//com.analog.gnu.toolchain.blackfin.debug.gdbproxy
//org.eclipse.cdt.debug.gdbjtag.core.jtagdevice.gdbproxy

public class gdbproxy extends DefaultGDBJtagDeviceImpl {
	public String getDefaultIpAddress() {
		return "192.168.0.15";
	}
	public String getDefaultPortNumber() {
		return "2000";
	}
}
