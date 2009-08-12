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
package com.analog.gnu.debug;

/*
 * Created on Aug 17, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public interface IDSPDebugGeneralConstants
{
	// Fixed path for locating files
	public static final String CONF_REGISTERS_PATH 	= "/" + "mmrdefinitions";


	public static final int REGSTATUS_OK 				= 0 ; // register value was red and is valid. ( Must have 0 numeric value for native simulator compatibility )
	public static final int REGSTATUS_X_VALUE 			= -1 ; // register value was red and is undefined( xxxxxx )
	public static final int REGSTATUS_NOT_IN_PLATFORM 	= -2 ; // register does not exist in platform

}
