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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigInteger;
import java.util.Vector;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ISelectionProvider;
import org.eclipse.jface.window.Window;
import org.eclipse.ui.actions.SelectionProviderAction;

import com.analog.gnu.debug.ui.views.ValueViewUtils;


/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class RegistersDumpAction
	extends SelectionProviderAction
{
	MMRView view;
	/**
	 * @param provider
	 * @param text
	 */
	public RegistersDumpAction(MMRView view, ISelectionProvider provider, String text)
	{
		super(provider, text);
		this.view = view;
	}



	/* (non-Javadoc)
	 * @see org.eclipse.jface.action.IAction#run()
	 */
	public void run()
	{
		MMRViewerPage page = view.getVisiableSheet();
		if (page == null)
			return;

		DumpDialog dialog = new DumpDialog(page.getShell(), page.getViewMode());
		int ret = dialog.open();

		if (ret == Window.CANCEL)
			return;

		int base = dialog.getBaseFormat();
		String fileName = dialog.getFilePath();


		if ( fileName.length() == 0)
		{
			handleError("Error", "No file name was specified.");
			return;
		}

		File file = new File(fileName);
		if (file.exists())
		{
			if (!MessageDialog.openConfirm(page.getShell(), "Confirmation", "The file already exists. Do you want to overwrite it ?"))
				return;

			if (!file.delete())
			{
				handleError("Error", "Overwriting '" + fileName + "' failed.");
				return;
			}
		}

		boolean fileCreated = false;
		try
		{
			fileCreated = file.createNewFile();
		} catch (IOException e) {}

		if (!fileCreated)
		{
			handleError("Error", "Error creating '" + fileName + "'. Plaese make sure the file's path exists, and that you are not using invalid characters.");
			return;
		}

		BufferedWriter writer = null;
		try
		{
			writer = new BufferedWriter(new FileWriter(file));
		} catch (IOException e)
		{
			handleError("Error", "Unable to open file for writing.");
			return;
		}

		Vector registers = page.getAllRegistersRows();
		DSPRegTableRow row;
		BigInteger value;
		try
		{
			for (int ind=0; ind < registers.size(); ind++)
			{
				row = (DSPRegTableRow)registers.elementAt(ind);

				// register name
				writer.write(row.getColumnText(0));
				writer.write("\t = ");

				// write value
				value = row.getBigTotalValue();
				writer.write(ValueViewUtils.getFormatedString(value, base, row.getNumberOf32bits()*32, false));
				writer.newLine();
			}
			writer.flush();
			writer.close();
		} catch (IOException e1)
		{
		}
	}

	private void handleError(String title, String errorMessage)
	{
		MessageDialog.openError(null,
								title,
								errorMessage);
	}

}
