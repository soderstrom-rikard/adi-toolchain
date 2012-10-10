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
package com.analog.gnu.toolchain.blackfin.core;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import org.eclipse.cdt.managedbuilder.core.IBuildObject;
import org.eclipse.cdt.managedbuilder.core.IConfiguration;
import org.eclipse.cdt.managedbuilder.core.IFolderInfo;
import org.eclipse.cdt.managedbuilder.core.IHoldsOptions;
import org.eclipse.cdt.managedbuilder.core.IManagedOptionValueHandler;
import org.eclipse.cdt.managedbuilder.core.IOption;
import org.eclipse.cdt.managedbuilder.core.ITool;
import org.eclipse.cdt.managedbuilder.core.ManagedBuildManager;

import com.analog.gnu.toolchain.blackfin.Utility;

/**
 * Sets the corresponding hidden Multi-core Linker option, so
 * that the switch appears on the Linker command line too
 *
 * @author amclach
 */
public class MultiCoreValueHandler extends ApplicabilityCalculatorUtilities implements IManagedOptionValueHandler {

	/**
	 * Helper class to associate a processor string with option Id values
	 */
	protected class PerProcessorOptions {

		private String processor;

		private Map<Pattern, Pattern> associatedOptions = null;

		/**
		 * Constructor
		 * 
		 * @param procValue the processor
		 * @param options   the associated options
		 */
		public PerProcessorOptions(final String procValue, Map<Pattern, Pattern> options) {
			processor = procValue;
			associatedOptions = options;
		}

		/**
		 * @return the processor
		 */
		public String getProcessor() {
			return processor;
		}

		/**
		 * @return the associated options, as a map
		 */
		public Map<Pattern, Pattern> getAssociatedOptions() {
			return associatedOptions;
		}
	}

	/* A list of processors and associated options */
	protected ArrayList<PerProcessorOptions> processorOptions = new ArrayList<PerProcessorOptions>();

	/**
	 * Constructor
	 */
	public MultiCoreValueHandler() {
		/* Multi-core options */
		final String C_MOREA = "com.analog.gnu.toolchain.blackfin.c.compiler.options.mcorea";
		final String C_MOREB = "com.analog.gnu.toolchain.blackfin.c.compiler.options.mcoreb";
		final String C_MORE0 = "com.analog.gnu.toolchain.blackfin.c.compiler.options.mcore0";
		final String C_MORE1 = "com.analog.gnu.toolchain.blackfin.c.compiler.options.mcore1";

		final String CPP_MOREA = "com.analog.gnu.toolchain.blackfin.cpp.compiler.options.mcorea";
		final String CPP_MOREB = "com.analog.gnu.toolchain.blackfin.cpp.compiler.options.mcoreb";
		final String CPP_MORE0 = "com.analog.gnu.toolchain.blackfin.cpp.compiler.options.mcore0";
		final String CPP_MORE1 = "com.analog.gnu.toolchain.blackfin.cpp.compiler.options.mcore1";
		
		Map<Pattern, Pattern> associatedOptions = new HashMap<Pattern, Pattern>();

		associatedOptions.put(Pattern.compile(C_MOREA),   Pattern.compile("com.analog.gnu.toolchain.blackfin.c.linker.options.mcorea"));
		associatedOptions.put(Pattern.compile(C_MOREB),   Pattern.compile("com.analog.gnu.toolchain.blackfin.c.linker.options.mcoreb"));
		associatedOptions.put(Pattern.compile(CPP_MOREA), Pattern.compile("com.analog.gnu.toolchain.blackfin.cpp.linker.options.mcorea"));
		associatedOptions.put(Pattern.compile(CPP_MOREB), Pattern.compile("com.analog.gnu.toolchain.blackfin.cpp.linker.options.mcoreb"));

		PerProcessorOptions options = new PerProcessorOptions(Utility.BF561, associatedOptions);

		processorOptions.add(options);

		associatedOptions = new HashMap<Pattern, Pattern>();

		associatedOptions.put(Pattern.compile(C_MORE0),   Pattern.compile("com.analog.gnu.toolchain.blackfin.c.linker.options.mcore0"));
		associatedOptions.put(Pattern.compile(C_MORE1),   Pattern.compile("com.analog.gnu.toolchain.blackfin.c.linker.options.mcore1"));
		associatedOptions.put(Pattern.compile(CPP_MORE0), Pattern.compile("com.analog.gnu.toolchain.blackfin.cpp.linker.options.mcore0"));
		associatedOptions.put(Pattern.compile(CPP_MORE1), Pattern.compile("com.analog.gnu.toolchain.blackfin.cpp.linker.options.mcore1"));

		options = new PerProcessorOptions(Utility.BF60X, associatedOptions);

		processorOptions.add(options);
	}

	/**
	 * Retrieve the options that are associated with a processor
	 * @param procValue the processor
	 * @return the options associated with the processor
	 */
	private Map<Pattern, Pattern> getProcessorOptions(final String procValue) {
		if (procValue != null) {
			Iterator<PerProcessorOptions> iter = processorOptions.iterator();
	
			while (iter.hasNext())	{
				PerProcessorOptions proc = iter.next();
				final String processor = proc.getProcessor();
				/* Match by string value or a regular expression */
				if (proc != null && (procValue.matches(processor) || procValue.equals(processor))) {
					return proc.getAssociatedOptions();
				}
			}
		}

		return null;
	}

	/**
	 * Check the current option and return info about which Linker option to toggle
	 * @param processor         the processor
	 * @param optionValue       the current option value
	 * @return an Id containing the option to toggle in the Linker options
	 */
	private Pattern checkAssociatedOption(final String processor, final String optionValue) {
		Map<Pattern, Pattern> associatedOptions = getProcessorOptions(processor);
		
		if (associatedOptions != null) {
			Set<Pattern> keys = associatedOptions.keySet();
			for (Pattern id : keys)	{
				if (id.matcher(optionValue).matches()) {
					return associatedOptions.get(id); // return the Id for the Linker option
				}
			}
		}

		return null;
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see org.eclipse.cdt.managedbuilder.core.IManagedOptionValueHandler#handleValue(
	 * 		org.eclipse.cdt.managedbuilder.core.IBuildObject,
	 *      org.eclipse.cdt.managedbuilder.core.IHoldsOptions,
	 *      org.eclipse.cdt.managedbuilder.core.IOption, java.lang.String, int)
	 */
	@Override
	public boolean handleValue(IBuildObject configuration, IHoldsOptions holder,
			IOption option, String extraArgument, int event) {

		IConfiguration cfg = null;
		if (configuration instanceof IConfiguration) {
			cfg = (IConfiguration) configuration;
		}
		else if (configuration instanceof IFolderInfo) {
			IFolderInfo folderInfo = (IFolderInfo) configuration;
			cfg = folderInfo.getParent();
		}

		if (cfg != null) {
			/* Find the Linker tool */
			ITool linker = null;
			ITool compiler = (ITool) holder;
			for (ITool tool : cfg.getFilteredTools()) {
				if (tool.getId().matches(Utility.TOOLID_LINKER)) {
					linker = tool;
					break;
				}
			}

			if (compiler != null && linker != null) {
				/* Retrieve the currently selected processor */
				final String proc = getProcessor(cfg);
				if (proc != null) {
					/* Retrieve the option's value */
					final Pattern id = checkAssociatedOption(proc, option.getValue().toString());
					if (id != null) {

						final String ldOptValue = id.toString();
						final boolean isBf561 = proc.matches(Utility.BF561);

						String ldOption = (isBf561 ? Utility.OPTID_CPPPROJ_LD_MULTICORE_BF561 : Utility.OPTID_CPPPROJ_LD_MULTICORE);
						String ccOption = (isBf561 ? Utility.OPTID_CPPPROJ_CC_MULTICORE_BF561 : Utility.OPTID_CPPPROJ_CC_MULTICORE);

						/* Check that we have a C++ Linker option and check to see if the option is from the C++ Compiler */
						IOption ldOpt = Utility.findOption(linker,   ldOption);
						IOption ccOpt = Utility.findOption(compiler, ccOption);
						if (ldOpt == null || ccOpt == null) {

							ldOption = (isBf561 ? Utility.OPTID_CPROJ_LD_MULTICORE_BF561 : Utility.OPTID_CPROJ_LD_MULTICORE);
							ccOption = (isBf561 ? Utility.OPTID_CPROJ_CC_MULTICORE_BF561 : Utility.OPTID_CPROJ_CC_MULTICORE);
							
							/* Check that we have a C Linker option and then check to see if the option is from the C Compiler */
							ldOpt = Utility.findOption(linker,   ldOption);
							ccOpt = Utility.findOption(compiler, ccOption);
						}

						if (ldOpt != null && ccOpt != null) {
							ManagedBuildManager.setOption(cfg, linker, ldOpt, ldOptValue);
						}
					}
				}
			}
		}

		return true;
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see org.eclipse.cdt.managedbuilder.core.IManagedOptionValueHandler#isDefaultValue(
	 * 		org.eclipse.cdt.managedbuilder.core.IBuildObject,
	 *      org.eclipse.cdt.managedbuilder.core.IHoldsOptions,
	 *      org.eclipse.cdt.managedbuilder.core.IOption, java.lang.String)
	 */
	@Override
	public boolean isDefaultValue(IBuildObject configuration,
			IHoldsOptions holder, IOption option, String extraArgument) {
		return false;
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see IManagedOptionValueHandler.isEnumValueAppropriate()
	 */
	@Override
	public boolean isEnumValueAppropriate(IBuildObject configuration,
			IHoldsOptions holder, IOption option, String extraArgument,
			String enumValue) {
		return true;
	}

}
