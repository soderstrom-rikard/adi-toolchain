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
package com.analog.gnu.toolchain.blackfin.build;

import java.util.ArrayList;
import java.util.List;
import org.eclipse.cdt.core.model.CoreModel;
import org.eclipse.cdt.build.core.scannerconfig.ScannerConfigBuilder;
import org.eclipse.cdt.core.settings.model.ICMultiItemsHolder;
import org.eclipse.cdt.core.settings.model.ICProjectDescription;
import org.eclipse.cdt.core.settings.model.ICResourceDescription;
import org.eclipse.cdt.managedbuilder.core.BuildException;
import org.eclipse.cdt.managedbuilder.core.IConfiguration;
import org.eclipse.cdt.managedbuilder.core.IFolderInfo;
import org.eclipse.cdt.managedbuilder.core.IHoldsOptions;
import org.eclipse.cdt.managedbuilder.core.IOption;
import org.eclipse.cdt.managedbuilder.core.IResourceInfo;
import org.eclipse.cdt.managedbuilder.core.ITool;
import org.eclipse.cdt.managedbuilder.core.IToolChain;
import org.eclipse.cdt.managedbuilder.core.ManagedBuildManager;
import org.eclipse.cdt.managedbuilder.ui.properties.AbstractCBuildPropertyTab;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.jface.preference.IPreferencePageContainer;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;

import com.analog.gnu.toolchain.blackfin.Activator;
import com.analog.gnu.toolchain.blackfin.Utility;

/***
 * Displays the UI elements that allow the user to change the 
 * type of processor and revision that is associated with the
 * project.
 */
public class ProcessorSettingsTab extends AbstractCBuildPropertyTab implements
	IPreferencePageContainer {

	/** the message displayed when multiple configurations with different processors are selected*/
	private final static String MSG_MULTIPLE_PROCS = "[ Multiple processors selected ]";

	/** the message displayed when multiple configurations with different revisions are selected*/
	private final static String MSG_MULTIPLE_REVS = "[ Multiple revisions selected ]";
	
	/** an internal value that we use to mark a processor or si-rev as having multiple values */
	private final static String MULTIPLE_VALUES = "[M]";
	
	/** holds the processor data that is currently applied to the selected configurations */
	private ProcessorData appliedProcessorData = new ProcessorData();

	/** UI components */
	private Combo processorCombo;
	private Combo revisionCombo;

	/**
	 * flag that determines if the processor data has been changed and
	 * should be saved
	 */
	private boolean isDirty = false;

	/**
	 * a flag that determines if we are currently in the middle of an
	 * update requested by Eclipse (e.g. updateData()) vs. a change that
	 * the user has initiated by interacting with the UI.
	 */
	private boolean inUpdateData = false;

	/** copy of toolchain */
	private IToolChain toolchain = null;
	
	/**
	 * Private class to hold the values for the processor and revision
	 */
	private class ProcessorData {

		private String processor = null;
		private String revision = null;

		/**
		 * Constructor
		 */
		ProcessorData() {
		}

		/**
		 * gets the value for the processor
		 * 
		 * @return the processor
		 */
		public String getProcessor() {
			return processor;
		}
		
		/**
		 * sets the value for the processor
		 * 
		 * @param s the value for the processor
		 */
		public void setProcessor(final String s) {
			processor = s;
		}

		/**
		 * Helper method to determine if this instance has 
		 * multiple processors
		 * 
		 * @return true if this instance has multiple processors
		 */
		public boolean hasMultipleProcessors() {
			return processor.compareTo(MULTIPLE_VALUES) == 0;
		}

		/**
		 * gets the value for the revision
		 * 
		 * @return the revision
		 */
		public String getRevision() {
			return revision;
		}

		/**
		 * sets the value for the revision
		 * 
		 * @param s the value for the revision
		 */
		public void setRevision(final String s) {
			revision = s;
		}

		/**
		 * Helper method to determine if this instance has 
		 * multiple silicon revisions
		 * 
		 * @return true if this instance has multiple revs
		 */
		public boolean hasMultipleRevisions() {
			return revision.compareTo(MULTIPLE_VALUES) == 0;
		}
	}

	/***
	 * Creates the controls (combo boxes) on the tab
	 * 
	 * @param parent Composite object for use to build the UI.
	 */
	public void createControls(final Composite parent) {
		//	The following line is needed when using the SWTDesigner.  The SWTDesigner recognizes it and will 
		//	allow graphical design.  However the superclasses need the usercomp variable from AbstractCPropertyTab 
		//	to be the composite.  So this line is commented out when the UI design is done and 
		//	super.createControls(parent) after un-commented. 
		//Composite usercomp = new Composite(parent, SWT.NONE);

		// original code that is needed for the tab to work.  Comment out when using SWTDesigner.
		super.createControls(parent);

		final GridLayout gridLayout = new GridLayout();
		gridLayout.verticalSpacing = 8;
		gridLayout.marginWidth = 8;
		gridLayout.marginHeight = 8;
		gridLayout.horizontalSpacing = 8;
		gridLayout.numColumns = 2;
		usercomp.setLayout(gridLayout);

		// create the processor type controls
		final Label processorLabel = new Label(usercomp, SWT.NONE);
		processorLabel.setText("Processor:");
		processorCombo = new Combo(usercomp, SWT.READ_ONLY);
		final GridData processorGridData = new GridData(SWT.FILL, SWT.CENTER, true, false);
		processorCombo.setLayoutData(processorGridData);
		processorCombo.addSelectionListener(new SelectionAdapter() {
			public void widgetSelected(final SelectionEvent event) {
				processorChanged();
			}
		});

		// create the silicon revision controls
		final Label siRevLabel = new Label(usercomp, SWT.NONE);
		siRevLabel.setText("Silicon Revision:");

		revisionCombo = new Combo(usercomp, SWT.READ_ONLY);
		final GridData revisionGridData = new GridData(SWT.FILL, SWT.CENTER, true, false);
		revisionCombo.setLayoutData(revisionGridData);
		revisionCombo.addSelectionListener(new SelectionAdapter() {
			public void widgetSelected(final SelectionEvent event) {
				revisionChanged();
			}
		});
		
		// populate the combo boxes with data from the currently selected
		// configuration(s)
		updateData(getResDesc());
	}

	/**
	 * Called when user changes the processor type causing the processor
	 * combo box to be rebuilt. 
	 */
	private void processorChanged() {

		final String newProcessor = processorCombo.getText();
		
		// if multiple processors are selected then disable the
		// revision combo and return.
		if(newProcessor.compareTo(MSG_MULTIPLE_PROCS) == 0) {
			revisionCombo.removeAll();
			revisionCombo.setEnabled(false);
			return;
		}

		if(!revisionCombo.isEnabled()) {
			revisionCombo.setEnabled(true);
		}
		
		final ArrayList<String> revisions = Utility.getSupportedRevisions(toolchain, newProcessor);

		// rebuild the silicon revision combo 
		revisionCombo.removeAll();
		for (int i = 0; i < revisions.size(); i++) {
			revisionCombo.add(revisions.get(i));
		}		
		
		if(!inUpdateData) {
			// if this update has been initiated by the user selecting a
			// new processor from the combo then we set the revision to the
			// default value for this part.
			revisionCombo.select(0);
		}
		else if(appliedProcessorData.hasMultipleRevisions()) {
			// else if the current processor has multiple revisions associated 
			// with it mark it as such in the combo box
			revisionCombo.add(MSG_MULTIPLE_REVS, 0);
			revisionCombo.select(0);
		}

		revisionCombo.setEnabled( !newProcessor.equals(Utility.UNSPECIFIED) );
		
		// notify the page that the silicon revision has changed
		revisionChanged();
	}

	/**
	 * Called when the revision has been changed or when a new processor
	 * has been selected causing the revisions to be modified.
	 */
	private void revisionChanged() {

		if(!inUpdateData) {
			// update the options in the resource
			updateOptions();

			// mark the data as being dirty
			isDirty = true;
		}
	}

	/***
	 * Method run when user clicks the Apply button. Stores the processor
	 * specific data for the project.
	 * 
	 * @param src Source Resource Description
	 * @param dst Destination Resource Description
	 */
	@Override
	protected void performApply(final ICResourceDescription src, final ICResourceDescription dst) {
		// has the data data changed, if not then return without doing anything.
		if (isDirty) {
			
			final IResourceInfo ri1 = getResCfg(src);
			final IResourceInfo ri2 = getResCfg(dst);

			final IResource res = ri2.getParent().getOwner();
			final ICProjectDescription des = CoreModel.getDefault().getProjectDescription(res.getProject());

			ITool[] tool1, tool2;
			if (ri1 instanceof IFolderInfo) {
				tool1 = ((IFolderInfo)ri1).getFilteredTools();
				tool2 = ((IFolderInfo)ri2).getFilteredTools();
			}
			else {
				return;
			}
			if (tool1.length != tool2.length) {
				return; // not our case
			}
			for (int i = 0; i < tool1.length; i++) {
				if ((tool1[i].getUniqueRealName()).equals(tool2[i].getUniqueRealName())) {
					// sets the options that are associated with the tool
					processOptions(tool1[i], tool2[i], ri2);
				}
			}
			
			try {
				//	now that project has been modified (the options in the tools set), save the project description.
				CoreModel.getDefault().setProjectDescription(res.getProject(), des);
			}
			catch (CoreException e) {
				//	log error
				Utility.logInfo(Activator.getDefault(),
					"Failed to save project description.");
			}

			// update the list of built-in compiler settings for this
			// configuration since changing the processor type or
			// silicon revision can potentially change them
			ScannerConfigBuilder.build(ri1.getParent(), 
				ScannerConfigBuilder.PERFORM_CORE_UPDATE, 
				new NullProgressMonitor());
			
			isDirty = false;
		}
	}

	/**
	 * Determine if this property tab is displayed.
	 * 
	 * @return true if the current tool chain is VisualDSP Blackfin or Sharc
	 * otherwise return false.
	 */
	@Override
	public boolean canBeVisible() {
		final String id = page.getResDesc().getId();
		return (id.contains("com.analog.gnu.toolchain.blackfin"));
	}
	
	/**
	 * updateData is called whenever the page that hosts this tab is loaded and
	 * set to visible, whenever the tab is selected or when the configuration is
	 * changed. This method just loads the combo boxes with the data stored in
	 * the options that hold the processor information.
	 * 
	 * @param resDesc - the ICResourceDescription for the current selected
	 *            configuration.
	 */
	@Override
	protected void updateData(final ICResourceDescription resDesc) {

		// update data only if this property tab is visible
		if (!canBeVisible()) {
			return;
		}
		
		//	if this is for a file or a multi-config then disable the 
		// combo boxes as processor choice is on the single configuration 
		// project level not the file level
		if (page.isForFile()) {
			processorCombo.setEnabled(false);
			revisionCombo.setEnabled(false);
			return;
		}

		final IConfiguration cfg = ManagedBuildManager.getConfigurationForDescription(
			resDesc.getConfiguration());
		toolchain = cfg.getToolChain();
		
		inUpdateData = true;

		//	get processor data for this configuration
		appliedProcessorData = getProcessorData(resDesc);

		// if multiple configurations are selected then we need to loop through
		// them to see if all of the processors are the same and/or if each of
		// the silicon revisions are the same.
		if (page.isMultiCfg() && resDesc instanceof ICMultiItemsHolder ) {
			
			final ICMultiItemsHolder itemHolder = (ICMultiItemsHolder)resDesc;
			final ICResourceDescription[] resources = (ICResourceDescription[])itemHolder.getItems();

			ProcessorData configA = getProcessorData(resources[0]);
						
			for (int i = 1; i < resources.length; i++) {
				final ProcessorData configB = getProcessorData(resources[i]);
				if(!configA.getProcessor().equals(configB.getProcessor())) {
					// the processors are different
					appliedProcessorData.setProcessor(MULTIPLE_VALUES);
				}
				
				if(!configA.getRevision().equals(configB.getRevision())) {
					// the silicon revisions are different
					appliedProcessorData.setRevision(MULTIPLE_VALUES);
				}
				configA = configB;
			}
		}

		// rebuild the processor combo box
		final ProcessorInfo procInfo = ProcessorInfo.getInstance();
		final ArrayList<String> processorNames = procInfo.getAllProcessors();
		if(processorNames.isEmpty()) {
			Utility.logInfo(Activator.getDefault(), "No processors found.");
			return;
		}
		
		if (toolchain.getId().contains("elf")) {
			// a processor must be selected for an elf project or it won't
			// compile
			processorNames.remove(Utility.UNSPECIFIED);
		}
		
		processorCombo.removeAll();
		for (int i = 0; i < processorNames.size(); i++) {
			processorCombo.add(processorNames.get(i));
		}

		if(appliedProcessorData.hasMultipleProcessors()){
			// select the multiple processor message if this is the case
			processorCombo.add(MSG_MULTIPLE_PROCS, 0);
			processorCombo.select(0);
			
		}
		else if(appliedProcessorData.getProcessor().isEmpty()) {
			// select the first processor in the list as the default
			processorCombo.select(0);
		}
		else {
			// otherwise select the current processor
			String proc = appliedProcessorData.getProcessor();
			if (!proc.equals(Utility.UNSPECIFIED)) {
				proc = proc.toUpperCase();
			}
			else if (toolchain.getId().contains("elf")) {
				// if the processor is "Unspecified" for an elf project, choose
				// the first processor so that the project will be build-able
				processorCombo.select(0);	
			}
			processorCombo.setText(proc);
		}

		processorChanged();

		revisionCombo.setText(appliedProcessorData.getRevision());
		
		revisionChanged();

		inUpdateData = false;
	}

	/**
	 * Returns the preference store. (for our purposes it just returns null)
	 * 
	 * @return IPreferenceStore object
	 */
	public IPreferenceStore getPreferenceStore() {
		return null;
	}

	/***
	 * Updates the message (or error message) shown in the message line to
	 * reflect the state of the currently active page in this container.
	 */
	public void updateMessage() {
		// not implemented in this class
	}

	/***
	 * Updates the title to reflect the state of the currently active page in
	 * this container.
	 */
	public void updateTitle() {
		// not implemented in this class
	}

	/**
	 * Method run when user clicks Restore Defaults but we really do not have a
	 * default processor setting.
	 */
	@Override
	protected void performDefaults() {
		// not implemented in this class
	}

	/**
	 * Method run when buttons need to be updated.
	 */
	@Override
	public void updateButtons() {
		// not implemented in this class
	}

	/**
	 * loads the processor data (processor, revision) into the global
	 * variables from the compiler tool from the configuration provided.
	 * 
	 * @param resDesc The ICResourceDescription object to get the compiler tool
	 *            from.
	 * @return A ProcessorData object with the processor and
	 *         revision values from the options
	 */
	private ProcessorData getProcessorData(final ICResourceDescription resDesc) {

		final ProcessorData pd = new ProcessorData();

		final IConfiguration cfg = ManagedBuildManager.getConfigurationForDescription(
			resDesc.getConfiguration());
		
		try {
			// get the compiler tool
			final ITool compiler = Utility.findTool(cfg, Utility.TOOLID_COMPILER);
			
			if(compiler == null) {
				throw new BuildException("Failed to find the compiler tool.");
			}
			
			// find the processor and si-rev options
			final IOption processor = Utility.findOption(compiler, Utility.OPTID_PROCESSOR);
			
			if(processor == null) {
				throw new BuildException("Failed to find required option.");
			}

			// the -mcpu switch is in the format:
			//   processor-revision
			// extract the processor and revision into separate strings
			String compilerSwitch = processor.getStringValue();
			String proc = "";
			String rev = "";
			if (compilerSwitch.isEmpty()) {
				proc = Utility.UNSPECIFIED;
				rev = "";
			}
			else {
				int index = compilerSwitch.lastIndexOf('-');
				if (index == -1) {
					throw new BuildException("-mcpu switch is in the wrong format.");
				}
				proc = compilerSwitch.substring(0,index);
				rev = compilerSwitch.substring(index+1);
			}
			
			// initialize the ProcessorData object
			pd.setProcessor(proc.trim());
			pd.setRevision(rev.trim());
		}
		catch (BuildException e) {
			Utility.logError(Activator.getDefault(), 
				"Failed to retrieve processor data from the project. " + e.getMessage(), 
				e);
		}
		
		return pd;
	}

	/**
	 * Steps through each option and saves the value in the src options to the
	 * dst options
	 * 
	 * @param src Tool object that has the options with the new values
	 * @param dst Tool object that has the options to be set with the new values
	 * @param res ResourceInfo object that owns the Tool object <i>dst</i>.
	 */
	private void processOptions(final IHoldsOptions src, final IHoldsOptions dst, final IResourceInfo res) {
		final IOption[] op1 = src.getOptions();
		final IOption[] op2 = dst.getOptions();

		for (int i = 0; i < op1.length; i++) {
			//	set the option
			storeOption(op1[i], op2[i], dst, res);
		}
	}

	/**
	 * Sets the option value for the second option parameter based on the first
	 * option parameter.
	 * 
	 * @param op1 Option with the value that will be set in the second option.
	 * @param op2 Option that will get set with the value from the first option
	 *            parameter.
	 * @param dst Tool that the option being set belongs too.
	 * @param res IResourceInfo object that the tool belongs to.
	 */
	@SuppressWarnings("unchecked")
	private void storeOption(final IOption op1, final IOption op2, final IHoldsOptions dst, final IResourceInfo res) {
		try {
			switch (op1.getValueType()) {
			case IOption.BOOLEAN:
				final boolean boolVal = op1.getBooleanValue();
				ManagedBuildManager.setOption(res, dst, op2, boolVal);
				break;
			case IOption.ENUMERATED:
				final String enumVal = op1.getStringValue();
				final String enumId = op1.getEnumeratedId(enumVal);
				final String out = (enumId != null && enumId.length() > 0) ? enumId : enumVal;
				ManagedBuildManager.setOption(res, dst, op2, out);
				break;
			case IOption.STRING:
				ManagedBuildManager.setOption(res, dst, op2, op1.getStringValue());
				break;
			case IOption.STRING_LIST:
			case IOption.INCLUDE_PATH:
			case IOption.PREPROCESSOR_SYMBOLS:
			case IOption.LIBRARIES:
			case IOption.OBJECTS:
			case IOption.INCLUDE_FILES:
			case IOption.LIBRARY_PATHS:
			case IOption.LIBRARY_FILES:
			case IOption.MACRO_FILES:
			case IOption.UNDEF_INCLUDE_PATH:
			case IOption.UNDEF_PREPROCESSOR_SYMBOLS:
			case IOption.UNDEF_INCLUDE_FILES:
			case IOption.UNDEF_LIBRARY_PATHS:
			case IOption.UNDEF_LIBRARY_FILES:
			case IOption.UNDEF_MACRO_FILES:
				String[] data = ((List<String>)op1.getValue()).toArray(new String[0]);
				ManagedBuildManager.setOption(res, dst, op2, data);
				break;
			default:
				break;
			}
		}
		catch (BuildException e) {
			Utility.logInfo(Activator.getDefault(),
				"BuildException - cannot obtain option value: " + e.getMessage());
		}
		catch (ClassCastException e) {
			Utility.logInfo(Activator.getDefault(), "ClassCastException:  " + e.getMessage());
		}
	}
	/**
	 * Updates the processor related options with the current values in the
	 * corresponding combo boxes.
	 */
	private void updateOptions() {

		IResourceInfo resourceInfo = getResCfg(getResDesc());

		ITool[] tools = ((IFolderInfo)resourceInfo).getFilteredTools();

		try {

			// the the options for each tool in the current tool chain
			for (ITool tool : tools) {

				// set the processor option
				if(!processorCombo.getText().equals(MULTIPLE_VALUES)) {
				
					IOption processor = Utility.findOption(tool, Utility.OPTID_PROCESSOR);
					
					if(processor == null) {
						// gnu assembler doesn't support the processor option
						// so continue with the next tool
						continue;
					}

					String proc = processorCombo.getText();
					String rev = revisionCombo.getText();
					if (proc.equals(Utility.UNSPECIFIED)) {
						resourceInfo.setOption(tool, processor, "");
					}
					else {
						resourceInfo.setOption(tool, processor, proc.toLowerCase() + "-" + rev);
					}
				}
			}
		}
		catch (BuildException e) {
			Utility.logError(Activator.getDefault(), 
					"Failed to save the processor and/or silicon revision values. " + e.getMessage(), 
					e);
		}
	}
}
