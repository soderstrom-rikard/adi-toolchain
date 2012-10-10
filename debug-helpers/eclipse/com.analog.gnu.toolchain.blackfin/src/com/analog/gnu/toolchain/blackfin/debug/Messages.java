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

import java.util.MissingResourceException;
import java.util.ResourceBundle;

import com.analog.gnu.toolchain.blackfin.Activator;

public class Messages {

	private static final String BUNDLE_NAME = Activator.PLUGIN_ID + ".debug.DebugMessages"; //$NON-NLS-1$

	private static ResourceBundle RESOURCE_BUNDLE;

	static {
		try {
			RESOURCE_BUNDLE = ResourceBundle.getBundle(BUNDLE_NAME);
		} catch (MissingResourceException e) {
			System.out.println(e.getMessage());
		}
	}

	private Messages() {
	}

	public static String getString(String key) {
		try {
			return RESOURCE_BUNDLE.getString(key);
		} catch (MissingResourceException e) {
			return '!' + key + '!';
		}
	}

	public static ResourceBundle getResourceBundle() {
		return RESOURCE_BUNDLE;
	}
}
