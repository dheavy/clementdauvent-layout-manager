package com.clementdauvent.admin.view.mediators
{
	import com.clementdauvent.admin.view.components.MainView;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	import com.greensock.TweenMax;
	
	/**
	 * <p>Mediator dealing with the MainView view component.</p>
	 */
	public class MainViewMediator extends Mediator
	{
		/*	@public	view:MainView	The injected MainView instance mediated by this Mediator. */
		[Inject]
		public var view:MainView;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Invoked when this mediator is registered. Add a listener reacting to addition of the view to the display list, launching setup around it.
		 */
		override public function onRegister():void
		{
			view.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		/**
		 * @public	viewAll
		 * @return	void
		 * 
		 * Sets the zoom level in a way that it displays fully, covering up the most possible Stage real-estate as possible.
		 */
		public function viewAll():void
		{
				
		}
		
		/**
		 * @private	initView
		 * @return	void
		 * 
		 * Invoked when the mediated view is added to the display list: starts configuring it.
		 */
		protected function initView(e:Event):void
		{
			trace("[INFO] MainViewMediator starts configuring the MainView instance");
			
			view.removeEventListener(Event.ADDED_TO_STAGE, initView);
		}
	}
}