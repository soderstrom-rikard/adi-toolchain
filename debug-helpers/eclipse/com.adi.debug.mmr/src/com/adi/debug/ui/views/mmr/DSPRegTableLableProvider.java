package com.adi.debug.ui.views.mmr;

import org.eclipse.jface.viewers.ITableLabelProvider;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.swt.graphics.Image;

/**
 * @author odcohen
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class DSPRegTableLableProvider
	extends LabelProvider
	implements ITableLabelProvider
{

	/**
	 * Constructor for DSPRegTableLableProvider.
	 */
	public DSPRegTableLableProvider()
	{
		super();
	}

	/**
	 * @see org.eclipse.jface.viewers.ITableLabelProvider#getColumnImage(Object, int)
	 */
	public Image getColumnImage(Object element, int columnIndex)
	{
		return null;
	}

	/**
	 * @see org.eclipse.jface.viewers.ITableLabelProvider#getColumnText(Object, int)
	 */
	public String getColumnText(Object element, int columnIndex)
	{
		if (element instanceof DSPRegTableRow)
		{
			return ((DSPRegTableRow)element).getColumnText(columnIndex);
		}
		
		return "";
	}

}
