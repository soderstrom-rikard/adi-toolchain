package com.adi.debug.ui.views;

import org.eclipse.jface.viewers.ISelectionProvider;
import org.eclipse.ui.actions.SelectionProviderAction;

/**
 * @author odcohen
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class ChangeViewBaseAction extends SelectionProviderAction
{
	INumberBaseView view;
	int mode;


	/**
	 * Constructor for DSPModeRegistersAction.
	 * @param provider
	 * @param text
	 */
	public ChangeViewBaseAction(INumberBaseView view, ISelectionProvider provider, int mode)
	{
		super(provider, "");
		this.view = view;
		this.mode = mode;
		String text = ValueViewUtils.baseToFormat(mode);
		setText(text);
	}
	
	

	/* (non-Javadoc)
	 * @see org.eclipse.jface.action.IAction#run()
	 */
	public void run() 
	{
		//DSPRegistersViewSheet sheet = view.getVisiableSheet();
		//sheet.setViewMode(mode);
		view.changeViewBase(mode);	
	}

}
