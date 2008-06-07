/**
 * Copyright Analog Devices, Inc. 2008
 * Licensed under the GPL-2
 */

package com.adi.toolchain.gnu.parser;

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