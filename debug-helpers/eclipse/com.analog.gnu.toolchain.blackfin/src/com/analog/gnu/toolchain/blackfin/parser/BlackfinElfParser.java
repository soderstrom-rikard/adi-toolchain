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
package com.analog.gnu.toolchain.blackfin.parser;

import org.eclipse.cdt.utils.IGnuToolFactory;
import org.eclipse.cdt.utils.elf.parser.GNUElfParser;

public class BlackfinElfParser extends GNUElfParser {
	private IGnuToolFactory toolFactory;

	public String getFormat() {
		return "Blackfin ELF Parser"; //$NON-NLS-1$
	}

	protected IGnuToolFactory createGNUToolFactory() {
		return new BlackfinToolFactory(this);
	}
	@SuppressWarnings("rawtypes")
	public Object getAdapter(Class adapter) {
		if (adapter.equals(IGnuToolFactory.class)) {
			if (toolFactory == null) {
				toolFactory = createGNUToolFactory();
			}
			return toolFactory;
		}
		return super.getAdapter(adapter);
	}
}