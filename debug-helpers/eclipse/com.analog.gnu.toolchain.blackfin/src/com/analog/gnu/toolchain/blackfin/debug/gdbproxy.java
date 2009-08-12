/**
 * Copyright Analog Devices, Inc. 2008
 * Licensed under the GPL-2
 */

package com.adi.toolchain.gnu.debug;

import org.eclipse.cdt.debug.gdbjtag.core.jtagdevice.DefaultGDBJtagDeviceImpl;

//com.adi.toolchain.gnu.debug.gdbproxy
//org.eclipse.cdt.debug.gdbjtag.core.jtagdevice.gdbproxy

public class gdbproxy extends DefaultGDBJtagDeviceImpl {
	public String getDefaultIpAddress() {
		return "192.168.0.15";
	}
	public String getDefaultPortNumber() {
		return "2000";
	}
}
