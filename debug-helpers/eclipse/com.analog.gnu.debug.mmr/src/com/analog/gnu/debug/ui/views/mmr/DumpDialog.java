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
package com.analog.gnu.debug.ui.views.mmr;

import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

import com.analog.gnu.debug.ui.views.TitledEditDialog;
import com.analog.gnu.debug.ui.views.ValueViewUtils;


/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class DumpDialog extends TitledEditDialog
{
	private static String lastPath = "";

	Text fileText;
	Combo formatCombo;
	String filePath;
	int format;

	/**
	 * @param parentShell
	 */
	public DumpDialog(Shell parentShell, int defaultFormat)
	{
		super(parentShell, "Select dump parameters");
		format = defaultFormat;
	}

	/* (non-Javadoc)
	 * Method declared in Window.
	 */
	protected void configureShell(Shell shell)
	{
		super.configureShell(shell);
		shell.setText("Dump Registers");
	}

	public boolean close()
	{

		// Before closing and disposing of the gui elements
		// retreive their data

		if (getReturnCode() == OK)
		{
			filePath = lastPath = fileText.getText();
			if (formatCombo != null)
			{
				Integer formatObj = (Integer)formatCombo.getData(formatCombo.getText());
				if (formatObj == null)
					formatObj = new Integer(ValueViewUtils.HEXA);

				format = formatObj.intValue();
			}
		}

		return super.close();
	}

	public String getFilePath()
	{
		return filePath;
	}

	public int getBaseFormat()
	{
		return format;
	}

	/* (non-Javadoc)
	 * @see com.adi.dsp.project.ui.TitledEditDialog#createPageContainer(org.eclipse.swt.widgets.Composite)
	 */
	protected Composite createPageContainer(Composite parent)
	{
		final Composite composite = new Composite( parent, SWT.NONE );

		GridLayout gridLayout = new GridLayout();
		gridLayout.numColumns = 3;
		gridLayout.marginWidth = 9;
		gridLayout.marginHeight = 5;
		gridLayout.makeColumnsEqualWidth = false;
		composite.setLayout(gridLayout);

		// GUI components
		Label label;
		GridData gridData;
		Control separator;
		Button button;

		// Create file locating gui
		label = new Label(composite, SWT.NONE);
		label.setText("File name: ");

		fileText = new Text(composite, SWT.BORDER | SWT.SINGLE);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		fileText.setText(lastPath);
		gridData.horizontalSpan = 1;
		gridData.widthHint = 200;
		fileText.setLayoutData(gridData);

		button = new Button(composite, SWT.PUSH);
		button.setText("Browse");
		gridData = new GridData();
		gridData.widthHint = 80;
		gridData.horizontalSpan = 1;
		button.setLayoutData(gridData);
		button.addListener(SWT.Selection, new Listener()
		{

			public void handleEvent(Event event)
			{
				FileDialog dialog = new FileDialog(getShell(), SWT.NULL);
				dialog.setFilterPath(fileText.getText());
				dialog.setText("Choose a file");
				String result = dialog.open();

				if (result != null)
					fileText.setText(result);
			}
		});


		// Create format parameters
		label = new Label(composite, SWT.NONE);
		label.setText("Format: ");

		formatCombo = new Combo(composite, SWT.BORDER | SWT.READ_ONLY);
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 2;
		formatCombo.setLayoutData(gridData);

		String[] keys = new String[]
		{
			ValueViewUtils.FORMAT_STR_HEX,
			ValueViewUtils.FORMAT_STR_OCT,
			ValueViewUtils.FORMAT_STR_BIN,
			ValueViewUtils.FORMAT_STR_SIGNED_INT,
			ValueViewUtils.FORMAT_STR_UNSIGNED_INT
		};

		int[] bases = new int[]
		{
			ValueViewUtils.HEXA,
			ValueViewUtils.OCTAL,
			ValueViewUtils.BINARY,
			ValueViewUtils.SIGNED_INT,
			ValueViewUtils.UNSIGNED_INT,
		};

		for (int ind=0; ind < keys.length; ind++)
		{
			formatCombo.add(keys[ind]);
			formatCombo.setData(keys[ind], new Integer(bases[ind]));

			if (bases[ind] == format)
				formatCombo.select(ind);
		}

		if (formatCombo.getSelectionIndex() < 0)
			formatCombo.select(0);

		label = new Label(composite, SWT.NONE);
		label.setText("");
		gridData = new GridData(GridData.FILL_HORIZONTAL);
		gridData.horizontalSpan = 3;
		label.setLayoutData(gridData);


		return composite;
	}
}
