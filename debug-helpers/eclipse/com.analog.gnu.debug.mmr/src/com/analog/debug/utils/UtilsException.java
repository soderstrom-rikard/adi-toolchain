/*
 * Created on Feb 2, 2004 by hcohen
 * 
 * Orion Integrated Development Environment for TigerSharc DSP family.
 * Analog Devices - Israel DSP Design Center.
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.adi.debug.utils;

/**
 * @author hcohen
 *
 * This exception should be serve as an error indication for Utils classes.
 */
public class UtilsException extends Exception {

	/**
	 * 
	 */
	public UtilsException() {
		super();
	}

	/**
	 * @param arg0
	 */
	public UtilsException(String arg0) {
		super(arg0);
	}

	/**
	 * @param arg0
	 * @param arg1
	 */
	public UtilsException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

	/**
	 * @param arg0
	 */
	public UtilsException(Throwable arg0) {
		super(arg0);
	}

}
