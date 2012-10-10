package com.analog.gnu.toolchain.blackfin.core;

import org.eclipse.cdt.managedbuilder.core.BuildException;
import org.eclipse.cdt.managedbuilder.core.IBuildObject;
import org.eclipse.cdt.managedbuilder.core.IConfiguration;
import org.eclipse.cdt.managedbuilder.core.IFolderInfo;
import org.eclipse.cdt.managedbuilder.core.IHoldsOptions;
import org.eclipse.cdt.managedbuilder.core.IOption;
import org.eclipse.cdt.managedbuilder.core.ITool;

import com.analog.gnu.toolchain.blackfin.Activator;
import com.analog.gnu.toolchain.blackfin.Utility;

/**
 * Utility class containing commonly used functionality for Applicability Calculators
 *
 * @author amclach
 */
public class ApplicabilityCalculatorUtilities {

	private static String[] multiCoreProcs = { Utility.BF561 , Utility.BF60X };

	/**
	 * Constructor
	 */
	public ApplicabilityCalculatorUtilities() {
	}

	/**
	 * This method returns the processor for the active configuration
	 * @param configuration  the configuration containing the tool Id
	 * @return the processor, otherwise null
	 */
	protected String getProcessor(IBuildObject configuration) {

		IConfiguration config = null;
		if (configuration instanceof IConfiguration) {
			config = (IConfiguration) configuration;
		}
		else if (configuration instanceof IFolderInfo) {
			IFolderInfo folderInfo = (IFolderInfo) configuration;
			config = folderInfo.getParent();
		}

		if (config != null) {	
			/* Retrieve the tool */
			ITool tool = Utility.findTool(config, Utility.TOOLID_COMPILER);
			if (tool != null) {
				/*	Retrieve the processor */
				IOption opt = Utility.findOption(tool, Utility.OPTID_PROCESSOR);
				if (opt != null) {
					try {
						final String processor = opt.getStringValue().trim(); // Get the value of the option
						final int dash = processor.lastIndexOf('-');
						if (dash > 0) {
							return processor.substring(0, dash);
						}
					} 
					catch (BuildException e) {
						Utility.logError(Activator.getDefault(),
								"Failed to retrieve processor value.", e);
					}
				}
			}
		}

		// The processor could not be found
		return null;
	}

	/**
	 * This method evaluates the option to determine if the processor is a Multi-core processor
	 * @param holder  the tool that holds the option
	 * @return true if the option is to be used for the project's processor, otherwise false
	 */
	protected boolean isMultiCoreProc(IHoldsOptions holder) {
		boolean isEnabled = true;

		/*	Retrieve the processor */
		IOption opt = Utility.findOption((ITool) holder, Utility.OPTID_PROCESSOR);
		if (opt != null) {
			try {
				final String processor = opt.getStringValue().trim(); // Get the value of the option
				final int dash = processor.lastIndexOf('-');
				if (dash > 0) {
					final String procValue = processor.substring(0, dash);

					for(Object procId : multiCoreProcs)	{
						if(procValue.matches(procId.toString()))	{
							return isEnabled;
						}
					}
				}
			} 
			catch (BuildException e) {
				Utility.logError(Activator.getDefault(),
						"Failed to retrieve processor value.", e);
			}
		}

		// Not a Multi-core processor
		return !isEnabled;
	}

}
