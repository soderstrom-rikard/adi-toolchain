/*******************************************************************************
 * Copyright (c) 2004, 2006 QNX Software Systems and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 * QNX Software Systems - Initial API and implementation
 * Analog Devices, Inc - adapted for VisualDSP++
 *******************************************************************************/
package com.analog.gnu.toolchain.blackfin.launcher;

import java.text.MessageFormat;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

/**
 * Class for reading resource LaunchUIMessages property strings.
 * 
 */
final public class LaunchUIMessages {

	/** the resource bundle name */
	private static final String BUNDLE_NAME = "com.analog.gnu.toolchain.blackfin.launcher.LaunchUIMessages";//$NON-NLS-1$

	/** the resource bundle */
	private static ResourceBundle RESOURCE_BUNDLE = null;

	static {
		try {
			RESOURCE_BUNDLE = ResourceBundle.getBundle(BUNDLE_NAME);
		}
		catch (MissingResourceException x) {
			x.getMessage();
		}
	}

	/**
	 * Constructor.
	 */
	private LaunchUIMessages() {
	}

	/**
	 * Look up and return a resource message string.
	 * 
	 * @param key resource key
	 * @param arg format argument
	 * @return the resource message string
	 */
	public static String getFormattedString(String key, String arg) {
		return MessageFormat.format(getString(key), (Object[])new String[] { arg });
	}

	/**
	 * Look up and return a resource message string.
	 * 
	 * @param key resource key
	 * @param args format arguments
	 * @return the resource message string
	 */
	public static String getFormattedString(String key, String[] args) {
		return MessageFormat.format(getString(key), (Object[])args);
	}

	/**
	 * Look up and return a resource message string.
	 * 
	 * @param key resource key
	 * @return the resource message string
	 */
	public static String getString(String key) {
		if (RESOURCE_BUNDLE == null) {
			return '!' + key + '!';
		}
		return RESOURCE_BUNDLE.getString(key);
	}
}
