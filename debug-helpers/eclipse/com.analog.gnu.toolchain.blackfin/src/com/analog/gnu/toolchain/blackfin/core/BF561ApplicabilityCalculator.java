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

import org.eclipse.cdt.managedbuilder.core.IBuildObject;
import org.eclipse.cdt.managedbuilder.core.IHoldsOptions;
import org.eclipse.cdt.managedbuilder.core.IOption;
import org.eclipse.cdt.managedbuilder.core.IOptionApplicability;

import com.analog.gnu.toolchain.blackfin.Utility;

/**
 * Applicability Calculator to hide and enable options
 * depending on the current processor being bf561
 *
 * @author amclach
 */
public class BF561ApplicabilityCalculator extends ApplicabilityCalculatorUtilities implements IOptionApplicability {

	@Override
	public boolean isOptionUsedInCommandLine(IBuildObject configuration,
			IHoldsOptions holder, IOption option) {
		final String processor = getProcessor(configuration);
		if (processor != null && processor.matches(Utility.BF561)) {
			return true;
		}
		return false;
	}

	@Override
	public boolean isOptionVisible(IBuildObject configuration,
			IHoldsOptions holder, IOption option) {
		return false;
	}

	@Override
	public boolean isOptionEnabled(IBuildObject configuration,
			IHoldsOptions holder, IOption option) {
		final String processor = getProcessor(configuration);
		if (processor != null && processor.matches(Utility.BF561)) {
			return true;
		}
		return false;
	}

}
