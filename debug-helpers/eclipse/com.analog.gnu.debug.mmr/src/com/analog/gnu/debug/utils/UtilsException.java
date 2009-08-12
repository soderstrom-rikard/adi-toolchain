/*******************************************************************************
 *  Copyright (c) 2009 Analog Devices, Inc.
 *  All rights reserved. This program and the accompanying materials
 *  are made available under the terms of the Eclipse Public License v1.0
 *  which accompanies this distribution, and is available at
 *  http://www.eclipse.org/legal/epl-v10.html
 *
 *  Contributors:
 *     Analog Devices, Inc. - Initial implementation
 *******************************************************************************/
package com.analog.gnu.debug.utils;

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
