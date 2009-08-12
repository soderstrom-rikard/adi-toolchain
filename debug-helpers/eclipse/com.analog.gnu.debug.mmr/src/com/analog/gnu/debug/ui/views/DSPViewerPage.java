/*
 * Created on 08/09/2003
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.adi.debug.ui.views;

import org.eclipse.debug.core.DebugEvent;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.IDebugEventSetListener;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.IDebugTarget;
import org.eclipse.swt.events.DisposeEvent;
import org.eclipse.swt.events.DisposeListener;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;


/**
 * @author odcohen
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public abstract class DSPViewerPage extends Composite 
	implements IDebugEventSetListener, DisposeListener
{
	private	String 	processorType;
	private int	suspended;
	
	/**
	 * @param parent
	 * @param style
	 */
	public DSPViewerPage(Composite parent, int style) 
	{
		super(parent, style);
		getParent().addDisposeListener(this);
		DebugPlugin.getDefault().addDebugEventListener(this);
		
		// we make sure the target is not running / stepping. if
		// so we need to disable the view
		synchronized (this)
		{
			IDebugTarget[] targets = DebugPlugin.getDefault().getLaunchManager().getDebugTargets();
			boolean enable = true;
			for(int i = 0; i < targets.length; i++)
				enable = enable && (targets[i].isSuspended()||targets[i].isTerminated() );
			setEnabled(enable);				
		}
		suspended = 0;
	}
	
	
	/**
	 * Sets the device info this page presents
	 * @return
	 */
	public void setDeviceInfo(String procType)
	{
		// TODO: this.processorType = procType;
		reload();
	}
	
	/**
	 * @see org.eclipse.swt.events.DisposeListener#widgetDisposed(DisposeEvent)
	 */
	public void widgetDisposed(DisposeEvent e)
	{
		dispose();
	}
	
	
	/**
	 * @see org.eclipse.debug.core.IDebugEventSetListener#handleDebugEvents(DebugEvent[])
	 */
	public final void handleDebugEvents(DebugEvent[] events)
	{
		if (isDisposed())
			return;
			
		for (int i = 0; i < events.length; i++) 
		{
			if (events[i].getSource() != null) 
			{
				doHandleDebugEvent(events[i]);
			}
		}
	}

	/**
	 * Method doHandleDebugEvent.
	 * @param debugEvent
	 */
	private final synchronized void doHandleDebugEvent(DebugEvent debugEvent)
	{
		switch (debugEvent.getKind()) 
		{
			case DebugEvent.SUSPEND:
				if(suspended == 0)
				{
					Display.getDefault().asyncExec(new Runnable()
					{
						public void run()
						{
							doSuspend();
							setEnabled(true);
						}
					}
					);
					suspended++;
				}
				break;
							
			case DebugEvent.RESUME:
				if(suspended > 0)
					suspended--;
				Display.getDefault().asyncExec(new Runnable()
				{
					public void run()
					{
						setEnabled(false);
						doResume();
					}
				}
				);
				break;

			case DebugEvent.CHANGE:
				if (debugEvent.getSource() instanceof IDebugTarget)
				{	
					Display.getDefault().asyncExec(new Runnable()
					{
						public void run()
						{
							doRestart();
							setEnabled(true);
						}
					}
					);
				}
				suspended = 0;
				break;
				
			case DebugEvent.TERMINATE:
				DebugPlugin.getDefault().removeDebugEventListener(this);
				
				Display.getDefault().asyncExec(new Runnable()
				{
					public void run()
					{
						doTerminate();
						setEnabled(true);
					}
				});
				break;
		}
	}
	
	protected final void reload()
	{
		DebugPlugin.getDefault().addDebugEventListener(this);
			
		doReload();
		setEnabled(true);
	}
	
	
	public ILaunchConfiguration getLaunchConfiguration()
	{
		ILaunch launches[] = DebugPlugin.getDefault().getLaunchManager().getLaunches();
		if(launches.length != 0 && launches[0] != null)
			return launches[0].getLaunchConfiguration();
		else
			return null;
	}
	
	/**
	 * Creates a string which is unique to this given viewer page.
	 * This string should be used for saving persistence data to the 
	 * launch configuration
	 *  
	 * @param viewPrefix	The view prefix	
	 * @return		Unique string
	 */
	protected String getLaunchUniqueName(String viewPrefix)
	{
		return processorType+"#"+viewPrefix;
	}
	

	
	public void dispose()
	{			
		DebugPlugin.getDefault().removeDebugEventListener(this);

		if (isDisposed())
			return;
					
		if (!getParent().isDisposed())
			getParent().removeDisposeListener(this);
			
		super.dispose();
	}
	
	protected abstract void doReload();
	protected abstract void doSuspend();
	protected abstract void doTerminate();
	protected abstract void doResume();
	protected abstract void	doRestart();
}
