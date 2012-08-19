package com.clementdauvent.admin.view.mediators
{
	import com.clementdauvent.admin.ClementDauventLayoutManager;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>The Mediator for the main Stage instance grabbed from the Main class of the app.</p>
	 * 
	 * @author	Davy Peter Braun
	 * @date	2012-08-19
	 */
	public class StageMediator extends Mediator
	{
		/*	@public	application:ClementDauventLayoutManager	Dependency injection of the app's main class. */
		[Inject]
		public var application:ClementDauventLayoutManager;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Method invoked when Mediator is registered.
		 * Registers listeners on Stage to make stage events available throughout the application.
		 */
		override public function onRegister():void
		{
			application.stage.addEventListener(Event.RESIZE, stage_resizeHandler);	
		}
		
		/**
		 * @public	stage_resizeHandler
		 * @return	void
		 * 
		 * Event handler triggered when stage is resized.
		 * Dispatch it throughout the application via EventDispatcher module.
		 */
		protected function stage_resizeHandler(e:Event):void
		{
			eventDispatcher.dispatchEvent(e);
		}
	}
}