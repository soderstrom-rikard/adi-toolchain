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
package com.analog.gnu.debug.ui.views;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.widgets.Display;

/**
 * @author odcohen
 *
 */
public interface IColorConstants
{
	// default background color for all views
	public static final Color BACKGROUND_COLOR = Display.getDefault().getSystemColor(SWT.COLOR_WHITE);

	// special foreground color for views
	public static final Color DATA_COLOR = Display.getDefault().getSystemColor(SWT.COLOR_BLUE);
	public static final Color LABEL_COLOR = Display.getDefault().getSystemColor(SWT.COLOR_DARK_GREEN);
	public static final Color SELECT_COLOR = Display.getDefault().getSystemColor(SWT.COLOR_DARK_RED);
	public static final Color CHANGED_COLOR = Display.getDefault().getSystemColor(SWT.COLOR_RED);
}
