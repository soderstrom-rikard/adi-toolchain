/**
 * 
 */
package com.adi.debug.ui.views.mmr;

import org.eclipse.jface.viewers.ContentViewer;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;

/**
 * @author Igoryok
 *
 */
public class MMRViewer extends ContentViewer {

	MMRViewerPage fControl;
	/**
	 * 
	 */
	public MMRViewer(Composite parent, MMRView view)
	{
		fControl = new MMRViewerPage( parent, view);
	}

	/* (non-Javadoc)
	 * @see org.eclipse.jface.viewers.Viewer#getControl()
	 */
	public Control getControl() {
	// TODO Auto-generated method stub
	return fControl;
	}

	/* (non-Javadoc)
	 * @see org.eclipse.jface.viewers.Viewer#getSelection()
	 */
	public ISelection getSelection() {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see org.eclipse.jface.viewers.Viewer#refresh()
	 */
	public void refresh() {
		// TODO Auto-generated method stub
	}

	/* (non-Javadoc)
	 * @see org.eclipse.jface.viewers.Viewer#setSelection(org.eclipse.jface.viewers.ISelection, boolean)
	 */
	public void setSelection(ISelection selection, boolean reveal)
	{
		// TODO Auto-generated method stub

	}
	public MMRViewerPage getPage()
	{
		return fControl;

	}
}
