package com.adi.toolchain.gnu.debug.gdbjtag;

import java.util.MissingResourceException;
import java.util.ResourceBundle;

import com.adi.toolchain.gnu.Activator;

public class Messages {

	private static final String BUNDLE_NAME = Activator.PLUGIN_ID + ".debug.gdbjtag.JtagUi"; //$NON-NLS-1$

	private static /* final */ ResourceBundle RESOURCE_BUNDLE; // = ResourceBundle.getBundle(BUNDLE_NAME);
	
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
