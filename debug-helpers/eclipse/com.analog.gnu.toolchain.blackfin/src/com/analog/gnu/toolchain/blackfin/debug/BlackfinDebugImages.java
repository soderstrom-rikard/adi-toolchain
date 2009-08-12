/*******************************************************************************
 * Copyright (c) 2007 QNX Software Systems and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     QNX Software Systems - Initial API and implementation
 *******************************************************************************/

package com.adi.toolchain.gnu.debug;

import com.adi.toolchain.gnu.Activator;

import java.net.MalformedURLException;
import java.net.URL;

import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.jface.resource.ImageRegistry;
import org.eclipse.swt.graphics.Image;

public class BlackfinDebugImages {
	private static ImageRegistry imageRegistry = new ImageRegistry();
	
	private static URL iconBaseURL = Activator.getDefault().getBundle().getEntry("/images/"); //$NON-NLS-1$
	
	private static final String NAME_PREFIX = Activator.PLUGIN_ID + '.';
	
	private static final String IMG_ADI = NAME_PREFIX + "adi-16x16.gif"; //$NON-NLS-1$
	
	public static Image getADIImage() {
		return imageRegistry.get(IMG_ADI);
	}
	
	static {
		createManaged("", IMG_ADI);
	}
	
	private static void createManaged(String prefix, String name) {
		imageRegistry.put(name, ImageDescriptor.createFromURL(makeIconFileURL(prefix, name.substring(NAME_PREFIX.length()))));
	}
	
	private static URL makeIconFileURL(String prefix, String name) {
		StringBuffer buffer= new StringBuffer(prefix);
		buffer.append(name);
		try {
			return new URL(iconBaseURL, buffer.toString());
		} catch (MalformedURLException e) {
			System.err.println(e);
			return null;
		}
	}
}
