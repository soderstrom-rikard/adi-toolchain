package com.adi.debug;

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
