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
package com.analog.gnu.toolchain.blackfin.build;

import java.io.IOException;

import org.eclipse.cdt.managedbuilder.core.IManagedIsToolChainSupported;
import org.eclipse.cdt.managedbuilder.core.ITool;
import org.eclipse.cdt.managedbuilder.core.IToolChain;
import org.osgi.framework.Version;

/**
 * Only display toolchains that installed in user's PATH
 */
public class CheckToolchain implements IManagedIsToolChainSupported {
	public static boolean isToolSupported(String toolCommand) {
		try {
			Runtime.getRuntime().exec(toolCommand + " --version");
			return true;
		} catch (IOException e) {
			//e.printStackTrace();
		}
		return false;
	}

	public static boolean isToolSupported(ITool tool) {
		return isToolSupported(tool.getToolCommand());
	}

	public boolean isSupported(IToolChain toolChain,
			Version version, String instance) {

		// Make sure each tool in the chain is installed and executable
		for (ITool t : toolChain.getTools()) {
			if (t.isAbstract())
				continue;
			// Could just check the C compiler ?
 			//if (t.getSuperClass().getId().equals("com.analog.gnu.toolchain.blackfin.c.compiler.base"))
				if (!isToolSupported(t))
					return false;
		}

		// if we werent able to parse the toolchain, then let's just assume it's supported.
		// this is because this function gets called at multiple points, and not all are
		// able to hit the right superclass ... sometimes you need super.super.id ...
		return true;
	}
}
