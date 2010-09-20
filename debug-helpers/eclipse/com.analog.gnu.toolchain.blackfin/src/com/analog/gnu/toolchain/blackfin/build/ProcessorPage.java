/*******************************************************************************
 *  Copyright (c) 2010 Analog Devices, Inc.
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

import org.eclipse.cdt.managedbuilder.core.IConfiguration;
import org.eclipse.cdt.managedbuilder.core.IManagedBuildInfo;
import org.eclipse.cdt.managedbuilder.core.IToolChain;
import org.eclipse.cdt.managedbuilder.core.ManagedBuildManager;
import org.eclipse.cdt.managedbuilder.ui.wizards.CDTConfigWizardPage;
import org.eclipse.cdt.managedbuilder.ui.wizards.MBSCustomPage;
import org.eclipse.cdt.managedbuilder.ui.wizards.MBSCustomPageManager;
import org.eclipse.cdt.managedbuilder.ui.wizards.MBSWizardHandler;
import org.eclipse.cdt.ui.wizards.CDTMainWizardPage;
import org.eclipse.cdt.ui.wizards.EntryDescriptor;
import org.eclipse.core.resources.IProject;
import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.jface.wizard.IWizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Tree;

import com.analog.gnu.toolchain.blackfin.Activator;
import com.analog.gnu.toolchain.blackfin.Utility;

/**
 * ProcessorPage creates the Select Processor page in the Project Wizard
 * 
 * @see com.analog.visualdsp.managedbuilder.ui.ProcessorPageRunnable
 */
public class ProcessorPage extends MBSCustomPage {
	
	/**	The id of the page.  Used by the Runnable classes for the different wizard pages	*/
	public final static String PAGE_ID = "com.analog.gnu.toolchain.blackfin.build.ProcessorPage";
	/**	The name of the page.	*/
	public final static String PAGE_NAME = "ProcessorPage";
	/** Message to users when the choose more than one tool chain for the project	*/
	private final String multipleToolchainMsg = "You have selected multiple toolchains for your VisualDSP++ " +
												"projectType project.  This project type supports only a single " +
												"toolchain.\n\nPlease return to the first page and select one " +
												"toolchain.";
	/**	The name of the page.	*/
	public final static String EMPTY_PROJECT = "Empty Project";

	/**	Java SWT controls used for creating the UI	*/
	private Composite composite;
	private Combo processorCombo;
	private Combo revisionCombo;

	/**	holds the name of the tool chain being used for this project.  
	 * It is being use to determine if the user changes project type
	 */
	private String toolChain;

	/**
	 * Default constructor
	 */
	public ProcessorPage() {
		super(PAGE_ID);
		toolChain = "";
	}

	/**
	 * @return the CDT main wizard page 
	 */
	protected CDTMainWizardPage getCDTMainWizardPage() {
		final CDTConfigWizardPage configPage = (CDTConfigWizardPage)super.getPreviousPage();

		IWizardPage p = configPage.getPreviousPage();
		while (p != null) {
			if (p instanceof CDTMainWizardPage) {
				CDTMainWizardPage wp = (CDTMainWizardPage)p;
				return wp;
			}
			else {
				// keep going to the previous page in the list until we find the CDT main wizard page
				p = p.getPreviousPage();
			}
		}
		
		return null;
	}
	
	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.wizard.IWizardPage#isPageComplete()
	 */
	@Override
	protected boolean isCustomPageComplete() {
		CDTMainWizardPage wp = getCDTMainWizardPage();
		if (wp != null) {
			MBSWizardHandler mwh = (MBSWizardHandler)wp.h_selected;
			
			if(mwh.getSelectedToolChains().length > 1)	{
				return false;
			}
		}
		
		return true;
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.wizard.IWizardPage#getName()
	 */
	public String getName() {
		return PAGE_NAME;
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#createControl()
	 */
	public void createControl(final Composite parent) {
		composite = new Composite(parent, SWT.NULL);
		final GridLayout gridLayout = new GridLayout();
		gridLayout.verticalSpacing = 8;
		gridLayout.marginWidth = 8;
		gridLayout.marginHeight = 8;
		gridLayout.horizontalSpacing = 8;
		gridLayout.numColumns = 2;
		composite.setLayout(gridLayout);

		final Label processorLabel = new Label(composite, SWT.NONE);
		processorLabel.setText("Processor:");

		processorCombo = new Combo(composite, SWT.READ_ONLY);
		final GridData processorGridData = new GridData(SWT.FILL, SWT.CENTER, true, false);
		processorCombo.setLayoutData(processorGridData);
		processorCombo.addSelectionListener(new SelectionAdapter() {
			public void widgetSelected(final SelectionEvent event) {
				processorChanged();
			}
		});

		final Label siRevLabel = new Label(composite, SWT.NONE);
		siRevLabel.setText("Silicon Revision:");

		revisionCombo = new Combo(composite, SWT.READ_ONLY);
		final GridData revisionGridData = new GridData(SWT.FILL, SWT.CENTER, true, false);
		revisionCombo.setLayoutData(revisionGridData);
		revisionCombo.addSelectionListener(new SelectionAdapter() {
			public void widgetSelected(final SelectionEvent event) {
				revisionChanged();
			}
		});

		populateProcessors();
	}

	/**
	 * Populate the processor combo.
	 */
	private void populateProcessors() {
		final ProcessorInfo procInfo = ProcessorInfo.getInstance();
		final ArrayList<String> processorNames = procInfo.getAllProcessors();

		CDTMainWizardPage wp = getCDTMainWizardPage();
		if (wp != null) {
			MBSWizardHandler mwh = (MBSWizardHandler)wp.h_selected;
			IToolChain toolchain = mwh.getSelectedToolChains()[0];
			if (toolchain.getId().contains("elf")) {
				// a processor must be selected for an elf project or it won't
				// compile
				processorNames.remove(Utility.UNSPECIFIED);
			}			
		}
		
		processorCombo.removeAll();
		for (int i = 0; i < processorNames.size(); i++) {
			processorCombo.add(processorNames.get(i));
		}

		// select the first processor in the list as the default
		processorCombo.select(0);

		// notify the page that the processor has changed
		processorChanged();
	}

	/**
	 * Update the wizard when the Processor selection is changed
	 */
	private void processorChanged() {
		final String currentProcessor = processorCombo.getText();
		
		// now check with the compiler to see if each revision is supported
		// for the processor target
		CDTMainWizardPage wp = getCDTMainWizardPage();
		if (wp != null) {
			MBSWizardHandler mwh = (MBSWizardHandler)wp.h_selected;
			IToolChain toolchain = mwh.getSelectedToolChains()[0];		
			final ArrayList<String> supportedRevisions = Utility.getSupportedRevisions(toolchain, currentProcessor);
	
			// rebuild the silicon revision combo 
			revisionCombo.removeAll();
			for (int i = 0; i < supportedRevisions.size(); i++) {
				revisionCombo.add(supportedRevisions.get(i));
			}
			revisionCombo.select(0);
	
			revisionCombo.setEnabled( !currentProcessor.equals(Utility.UNSPECIFIED) );
			
			// notify the page that the silicon rev has changed
			revisionChanged();
		}
		
		// save the selected processor
		MBSCustomPageManager.addPageProperty(PAGE_ID, "Processor", currentProcessor);
	}

	/**
	 * Update the wizard when the Silicon Revision selection is changed
	 */
	private void revisionChanged() {
		// save the selected revision
		MBSCustomPageManager.addPageProperty(PAGE_ID, "Revision", revisionCombo.getText());
	}

    /**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.wizard.IWizardPage#getNextPage()
	 * 
	 * One of the criteria in determining if the next wizard page should be displayed is whether the 
	 * user chose two toolchains for the project.  If they did then null is returned as we want the 
	 * user to go back and just choose one toolchain.
	 */
	@Override
	public IWizardPage getNextPage()	{
		final CDTConfigWizardPage configPage = (CDTConfigWizardPage)super.getPreviousPage();

		IWizardPage p = configPage.getPreviousPage();
		while (p != null) {
			if (p instanceof CDTMainWizardPage) {
				final CDTMainWizardPage wp = (CDTMainWizardPage)p;
				final MBSWizardHandler mwh = (MBSWizardHandler)wp.h_selected;
		
				//	get array of tool chains to check if more than one has been selected.
				if(mwh.getSelectedToolChains().length > 1)	{
					//	display message to user that picking more than one tool chain is a 'no-no'
					String projType = mwh.getName();
					String msg = multipleToolchainMsg.replaceAll("projectType", projType);
					MessageBox msgBox = new MessageBox(
							Activator.getDefault().getWorkbench().getActiveWorkbenchWindow().getShell(),
							SWT.OK | SWT.WRAP);
					msgBox.setText("Multiple Toolchains Detected");
					msgBox.setMessage(msg);
					msgBox.open();
		
					return null;
				}
			
				// in case the user has modified the toolchain selection
				// get the project ID from the Configurations page
				String tc = ((IToolChain)mwh.getSelectedToolChains()[0]).getUniqueRealName();
				
				if(!toolChain.equals(tc))	{
					toolChain = tc;
					populateProcessors();
				}
		
				//	see if the user chose an empty project
				if(isEmptyProject(((Composite)wp.getControl()).getChildren()))	{
					return null;
				}
				
				break;
			}
			else {
				// keep going to the previous page in the list until we find the CDT main wizard page
				p = p.getPreviousPage();
			}
		}		
		
		//	return the next page
		return super.getNextPage();
	}
	
	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#dispose()
	 */
	public void dispose() {
		composite.dispose();
	}

	/**
	* {@inheritDoc}
	* @see org.eclipse.jface.dialogs.IDialogPage#getControl()
	*/
	public Control getControl() {
		return composite;
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#getDescription()
	 */
	public String getDescription() {
		return "Select the processor you wish to target";
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#getErrorMessage()
	 */
	public String getErrorMessage() {
		return null;
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#getImage()
	 */
	public Image getImage() {
		return wizard.getDefaultPageImage();
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#getMessage()
	 */
	public String getMessage() {
		return null;
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#getTitle()
	 */
	public String getTitle() {
		return "Select Processor";
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#performHelp()
	 */
	public void performHelp() {
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#setDescription()
	 */
	public void setDescription(final String description) {
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#setTitle()
	 */
	public void setTitle(final String title) {
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#setVisible()
	 */
	public void setVisible(final boolean visible) {
		composite.setVisible(visible);
	}

	/**
	 * {@inheritDoc}
	 * @see org.eclipse.jface.dialogs.IDialogPage#setImageDescriptor()
	 */
	public void setImageDescriptor(final ImageDescriptor arg0) {
	}

	/**
	 * Traverses the controls in the Main Wizard page to see if the Empty Project has been selected.  
	 * This method was developed for the Helios setup for the Main project wizard page.  In this page
	 * a Tree control is used to specify the different project types.  If the powers that be change this
	 * then this method will fail to detect if the user desires an Empty Project and ultimately the template
	 * source page will be shown.
	 * 
	 * @param crtlArray - array of Controls that are traversed
	 * @return	true is Empty project has been found and false otherwise
	 */
	private boolean isEmptyProject(Control[] crtlArray)	{
		for(Control crtl : crtlArray)	{
			if(crtl instanceof Tree) {
				Tree projectTypeTree = (Tree)crtl;

				//	get the EntryDescriptor for the current selection in the tree
				EntryDescriptor ed = CDTMainWizardPage.getDescriptor(projectTypeTree);
				
				//	check if selection's name is 'Empty Page' if so return null which disables the 
				//	Next button and enables the Finish button
				if(ed.getName().equals(EMPTY_PROJECT)) {
					return true;
					// return something probably a boolean indicating whether this is what we are looking for
				}
			}
			else if(crtl instanceof Composite)	{
				if(((Composite)crtl).getChildren().length > 0)	{
					if(isEmptyProject(((Composite)crtl).getChildren()))	{
						return true;
					}
				}
			}
		}
		return false;
	}
}
