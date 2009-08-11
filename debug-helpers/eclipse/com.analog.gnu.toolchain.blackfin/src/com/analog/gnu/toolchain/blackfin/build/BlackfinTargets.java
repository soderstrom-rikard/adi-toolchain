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

import org.eclipse.cdt.managedbuilder.core.BuildException;
import org.eclipse.cdt.managedbuilder.core.IBuildObject;
import org.eclipse.cdt.managedbuilder.core.IHoldsOptions;
import org.eclipse.cdt.managedbuilder.core.IManagedOptionValueHandler;
import org.eclipse.cdt.managedbuilder.core.IOption;
import org.eclipse.cdt.managedbuilder.core.ITool;
import org.eclipse.cdt.managedbuilder.core.IToolChain;
import org.eclipse.cdt.managedbuilder.internal.core.FolderInfo;

import com.analog.gnu.toolchain.blackfin.Activator;

public class BlackfinTargets implements IManagedOptionValueHandler {

	private static String getTargetOption(IToolChain toolchain, String name) {
		IOption option = toolchain.getOptionBySuperClassId(name);
		if (option == null)
			option = toolchain.getOptionById(name);
		if (option == null)
			return "";
		try {
			return option.getEnumCommand(option.getValue().toString()).toString();
		} catch (BuildException e) {
			return "";
		}
	}
	private static String getTargetProc(IToolChain toolchain) { return getTargetOption(toolchain, Activator.PLUGIN_ID + ".options.general.proc"); }
	private static String getTargetSirev(IToolChain toolchain) { return getTargetOption(toolchain, Activator.PLUGIN_ID + ".options.general.sirev"); }

	public BlackfinTargets() {
		// TODO Generate available procs based on XML files
	}

	public boolean handleValue(IBuildObject configuration, IHoldsOptions holder, IOption option, String extraArgument, int event) {
		if (event != EVENT_APPLY)
			return false;
		if (!(holder instanceof IToolChain))
			return false;

		IToolChain toolchain = (IToolChain) holder;
		FolderInfo info = (FolderInfo) configuration;

		/* Find the selected target from the user's configuration options */
		String targetFlag = getTargetProc(toolchain);
		if (targetFlag.length() > 0)
			targetFlag += "-" + getTargetSirev(toolchain);

		/* Tell all the subtools to use this target */
		for (ITool t : toolchain.getTools()) {
			for (IOption o : t.getOptions()) {
				if (!o.getId().startsWith("com.analog.gnu.toolchain.blackfin.") || !o.getId().contains(".options.proc"))
					continue;
				try {
					info.setOption(t, o, targetFlag);
					break;
				} catch (BuildException e) {
					e.printStackTrace();
				}
			}
		}

		return true;
	}

	public boolean isDefaultValue(IBuildObject configuration, IHoldsOptions holder, IOption option, String extraArgument) {
		return false;
	}

	public boolean isEnumValueAppropriate(IBuildObject configuration, IHoldsOptions holder, IOption option, String extraArgument, String enumValue) {
		if (!option.getId().startsWith("com.analog.gnu.toolchain.blackfin.") || !option.getId().contains(".options.general.sirev"))
			return true;

		// See if the compiler supports the silicon revision for this target
		String targetProc = getTargetProc((IToolChain) holder);
		if (targetProc.length() == 0)
			return false;

		IToolChain toolchain = (IToolChain) holder;
		for (ITool t : toolchain.getTools()) {
			if (t.getId().contains(".c.compiler")) {
				try {
					Process p = Runtime.getRuntime().exec(t.getToolCommand() + " -E -P - -mcpu=" + targetProc + "-" + enumValue);
					p.getOutputStream().close();
					p.waitFor();
					return p.exitValue() == 0;
				} catch (IOException e) {
					return false;
				} catch (InterruptedException e) {
					return false;
				}
			}
		}

		// Just assume it's OK if we couldn't find a compiler to test against
		return true;
	}

}
