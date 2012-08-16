package com.clementdauvent.admin.context
{
	import com.clementdauvent.admin.model.ApplicationModel;
	import com.clementdauvent.admin.controller.commands.StartupCommand;
	import com.clementdauvent.admin.controller.events.DataFetchEvent;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	/**
	 * ApplicationContext
	 * The application context based on requirements from the RobotLegs apparatus.
	 * 
	 * @author	Davy Peter Braun
	 * @date	2012-08-16
	 */
	public class ApplicationContext extends Context
	{
		/**
		 * @public	ApplicationContext
		 * @param	contextView:DisplayObjectContainer	The context view. Defaults to null.
		 * @param	autoStartup:Boolean					Specifies if startup should be automatic. Defaults to true.
		 * @return	this
		 * 
		 * Creates an ApplicationContext for the app.
		 */
		public function ApplicationContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		/**
		 * @public	startup
		 * @return	void
		 *
		 * Starts up the app by defining the 3 tiers on the RobotLegs apparatus.
		 */
		override public function startup():void 
		{
			// Defines Controller tier.
			commandMap.mapEvent(DataFetchEvent.BEGIN, StartupCommand);
			
			// Defines Model tier.
			injector.mapSingleton(ApplicationModel);
			
			// Defines View tier.
			
			// Start app.
			dispatchEvent(new DataFetchEvent(DataFetchEvent.BEGIN));
			
			trace("[INFO] ApplicationContext started");
		}
	}
}