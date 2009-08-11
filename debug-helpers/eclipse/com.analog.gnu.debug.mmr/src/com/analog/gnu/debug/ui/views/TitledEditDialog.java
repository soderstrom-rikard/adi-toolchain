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
package com.analog.gnu.debug.ui.views;


import org.eclipse.jface.dialogs.Dialog;
import org.eclipse.jface.dialogs.IDialogConstants;
import org.eclipse.jface.resource.JFaceColors;
import org.eclipse.jface.resource.JFaceResources;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.CLabel;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;

/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public abstract class TitledEditDialog extends Dialog
{
	private String fDefaultMessage;
	private String fMessage;
	private String fErrorMessage;
	private Color fNormalMsgAreaBackground;
	private Image fErrorMsgImage;

	// title part
	Composite fTitleArea;
	private Label fTitleImage;
	private CLabel fMessageLabel;

	/**
	 * Must declare our own images as the JFaceResource images will not be created unless
	 * a property/preference dialog has been shown
	 */
	protected static final String PREF_DLG_TITLE_IMG = "preference_dialog_title_image";//$NON-NLS-1$
	protected static final String PREF_DLG_IMG_TITLE_ERROR = "preference_dialog_title_error_image";//$NON-NLS-1$
	static
	{
	/**
		TODO Images for TitleEditDialog
		ImageRegistry reg = DebugPlugin.getDefault().getImageRegistry();
		reg.put(PREF_DLG_TITLE_IMG, ImageDescriptor.createFromFile(PreferenceDialog.class, "images/pref_dialog_title.gif"));//$NON-NLS-1$
		reg.put(PREF_DLG_IMG_TITLE_ERROR, ImageDescriptor.createFromFile(Dialog.class, "images/message_error.gif"));//$NON-NLS-1$
	*/
	}

	// page part
	Composite fPageContainer;



	public TitledEditDialog(Shell parentShell, String defaultMessage)
	{
		super(parentShell);
		fDefaultMessage = defaultMessage;
	}

	/*
	 * @see Dialog#createDialogArea(Composite)
	 */
	protected Control createDialogArea(Composite parent)
	{
		Font font = parent.getFont();

		Composite composite = (Composite)super.createDialogArea(parent);
		((GridLayout) composite.getLayout()).numColumns = 1;
		composite.setFont(font);

		// Build the title area and separator line
		Composite titleComposite = new Composite(composite, SWT.NONE);
		GridLayout layout = new GridLayout();
		layout.marginHeight = 0;
		layout.marginWidth = 0;
		layout.verticalSpacing = 0;
		layout.horizontalSpacing = 0;
		titleComposite.setLayout(layout);
		titleComposite.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
		titleComposite.setFont(font);

		createTitleArea(titleComposite);

		Label titleBarSeparator = new Label(titleComposite, SWT.HORIZONTAL | SWT.SEPARATOR);
		GridData gd = new GridData(GridData.FILL_HORIZONTAL);
		titleBarSeparator.setLayoutData(gd);


		// Build the Page container
		fPageContainer = createPageContainer(composite);
		fPageContainer.setLayoutData(new GridData(GridData.FILL_BOTH));

		// Build the separator line
		Label separator = new Label(composite, SWT.HORIZONTAL | SWT.SEPARATOR);
		gd = new GridData(GridData.FILL_HORIZONTAL);
		gd.horizontalSpan = 2;
		separator.setLayoutData(gd);

		applyDialogFont(composite);

		return composite;
	}


	/**
	 * Creates the inner page container.
	 */
	protected abstract Composite createPageContainer(Composite parent);

	/**
	 * Creates the dialog's title area.
	 *
	 * @param parent the SWT parent for the title area composite
	 * @return the created title area composite
	 */
	private Composite createTitleArea(Composite parent)
	{
		Font font = parent.getFont();

		// Create the title area which will contain
		// a title, message, and image.
		fTitleArea = new Composite(parent, SWT.NONE);
		GridLayout layout = new GridLayout();
		layout.marginHeight = 0;
		layout.marginWidth = 0;
		layout.verticalSpacing = 0;
		layout.horizontalSpacing = 0;
		layout.numColumns = 2;

		// Get the colors for the title area
		Display display = parent.getDisplay();
		Color bg = JFaceColors.getBannerBackground(display);
		Color fg = JFaceColors.getBannerForeground(display);

		GridData layoutData = new GridData(GridData.FILL_BOTH);
		fTitleArea.setLayout(layout);
		fTitleArea.setLayoutData(layoutData);
		fTitleArea.setFont(font);
		fTitleArea.setBackground(bg);

		// Message label
		fMessageLabel = new CLabel(fTitleArea, SWT.LEFT);
		fMessageLabel.setBackground(bg);
		fMessageLabel.setForeground(fg);
		fMessageLabel.setText(" ");//$NON-NLS-1$
		fMessageLabel.setFont(JFaceResources.getBannerFont());

		GridData gd = new GridData(GridData.FILL_BOTH);
		fMessageLabel.setLayoutData(gd);

		// Title image
		fTitleImage = new Label(fTitleArea, SWT.LEFT);
		fTitleImage.setBackground(bg);
/**
		TODO Image
		fTitleImage.setImage(ProjectUIPlugin.getDefault().getImageRegistry().get(PREF_DLG_TITLE_IMG));
*/
		gd = new GridData();
		gd.horizontalAlignment = GridData.END;
		fTitleImage.setLayoutData(gd);

		setMessage(fDefaultMessage);
		return fTitleArea;
	}


	/**
	 * Display the given error message. The currently displayed message
	 * is saved and will be redisplayed when the error message is set
	 * to <code>null</code>.
	 *
	 * @param errorMessage the errorMessage to display or <code>null</code>
	 */
	public void setErrorMessage(String errorMessage)
	{
		fErrorMessage = errorMessage;
		if (errorMessage == null)
		{
			if (fMessageLabel.getImage() != null)
			{
				// we were previously showing an error
				fMessageLabel.setBackground(fNormalMsgAreaBackground);
				fMessageLabel.setImage(null);
				/**
				TODO Image
				fTitleImage.setImage(ProjectUIPlugin.getDefault().getImageRegistry().get(PREF_DLG_TITLE_IMG));
				 */
				fTitleArea.layout(true);
			}

			// show the message
			setMessage(fMessage);
		}
		else
		{
			fMessageLabel.setText(errorMessage);
			if (fMessageLabel.getImage() == null)
			{
				// we were not previously showing an error

				// lazy initialize the error background color and image
				/** TODO Image
				if (fErrorMsgImage == null)
				{
					fErrorMsgImage = ProjectUIPlugin.getDefault().getImageRegistry().get(PREF_DLG_IMG_TITLE_ERROR);
				}
				*/
				// show the error
				fNormalMsgAreaBackground = fMessageLabel.getBackground();
				fMessageLabel.setBackground(JFaceColors.getErrorBackground(fMessageLabel.getDisplay()));
				fMessageLabel.setImage(fErrorMsgImage);
				fTitleImage.setImage(null);
				fTitleArea.layout(true);
			}
		}

		updateMessage();
		updateButtons();
	}
	/**
	 * Set the message text. If the message line currently displays an error,
	 * the message is stored and will be shown after a call to clearErrorMessage
	 */
	public void setMessage(String newMessage)
	{
		fMessage = newMessage;
		if (fMessage == null)
			fMessage = "";

		if (fErrorMessage == null)
			// we are not showing an error
			fMessageLabel.setText(fMessage);

		updateMessage();
	}


	public void updateMessage()
	{
		// Adjust the font
		if (fErrorMessage == null)
			fMessageLabel.setFont(JFaceResources.getBannerFont());
		else
			fMessageLabel.setFont(JFaceResources.getDialogFont());
	}


	private void updateButtons()
	{
		if (getButton(IDialogConstants.OK_ID) != null)
			getButton(IDialogConstants.OK_ID).setEnabled(fErrorMessage == null);
	}
}
