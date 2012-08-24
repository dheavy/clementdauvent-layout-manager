package com.clementdauvent.admin.context
{
	import com.clementdauvent.admin.ClementDauventLayoutManager;
	import com.clementdauvent.admin.controller.commands.PublishDataCommand;
	import com.clementdauvent.admin.controller.commands.ImagesAndTextsSetupCommand;
	import com.clementdauvent.admin.controller.commands.MainViewBuildCommand;
	import com.clementdauvent.admin.controller.commands.StartupCommand;
	import com.clementdauvent.admin.controller.events.DataFetchEvent;
	import com.clementdauvent.admin.model.ApplicationModel;
	import com.clementdauvent.admin.model.MainViewBuilderModel;
	import com.clementdauvent.admin.view.components.ContextMenuView;
	import com.clementdauvent.admin.view.components.Image;
	import com.clementdauvent.admin.view.components.MainView;
	import com.clementdauvent.admin.view.components.TextElement;
	import com.clementdauvent.admin.view.mediators.ImageMediator;
	import com.clementdauvent.admin.view.mediators.MainViewMediator;
	import com.clementdauvent.admin.view.mediators.StageMediator;
	import com.clementdauvent.admin.view.mediators.TextElementMediator;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	/**
	 * <p>The application context based on requirements from the RobotLegs apparatus.</p>
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
			commandMap.mapEvent(DataFetchEvent.COMPLETE, MainViewBuildCommand);
			commandMap.mapEvent(DataFetchEvent.REQUIRE_DATA_FOR_IMAGES, ImagesAndTextsSetupCommand);
			commandMap.mapEvent(DataFetchEvent.PUSH_DATA_FOR_PUBLISHING, PublishDataCommand);
			
			// Defines Model tier.
			injector.mapSingleton(ApplicationModel);
			injector.mapSingleton(MainViewBuilderModel);
			
			// Defines View tier.
			mediatorMap.mapView(ClementDauventLayoutManager, StageMediator);
			mediatorMap.mapView(MainView, MainViewMediator);
			mediatorMap.mapView(Image, ImageMediator);
			mediatorMap.mapView(TextElement, TextElementMediator);
			
			// Start app.
			dispatchEvent(new DataFetchEvent(DataFetchEvent.BEGIN));
			
			trace("[INFO] ApplicationContext started");
		}
	}
}