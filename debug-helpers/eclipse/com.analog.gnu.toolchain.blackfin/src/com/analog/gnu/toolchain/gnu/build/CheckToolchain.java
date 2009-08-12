/**
 * Copyright Analog Devices, Inc. 2008
 * Licensed under the GPL-2
 */

package com.adi.toolchain.gnu.build;

import java.io.IOException;

import org.eclipse.cdt.managedbuilder.core.IManagedIsToolChainSupported;
import org.eclipse.cdt.managedbuilder.core.ITool;
import org.eclipse.cdt.managedbuilder.core.IToolChain;
import org.eclipse.core.runtime.PluginVersionIdentifier;

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
			PluginVersionIdentifier version, String instance) {
		
		// Make sure each tool in the chain is installed and executable
		for (ITool t : toolChain.getTools()) {
			if (t.isAbstract())
				continue;
			// Could just check the C compiler ?
 			//if (t.getSuperClass().getId().equals("com.adi.toolchain.gnu.bfin.c.compiler.base"))
				if (!isToolSupported(t))
					return false;
		}
		
		// if we werent able to parse the toolchain, then let's just assume it's supported.
		// this is because this function gets called at multiple points, and not all are
		// able to hit the right superclass ... sometimes you need super.super.id ...
		return true;
	}
}
