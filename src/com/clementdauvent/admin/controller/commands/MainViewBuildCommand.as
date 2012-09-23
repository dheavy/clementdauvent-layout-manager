package com.clementdauvent.admin.controller.commands
{
	import com.clementdauvent.admin.controller.events.DataFetchEvent;
	import com.clementdauvent.admin.ClementDauventLayoutManager;
	import com.clementdauvent.admin.model.MainViewBuilderModel;
	import com.clementdauvent.admin.view.components.ContextMenuView;
	import com.clementdauvent.admin.view.components.MainView;
	import com.clementdauvent.admin.utils.Logger;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command fetching the data to build the main view.</p>
	 */
	public class MainViewBuildCommand extends Command
	{
		/**
		 * Injected instance of the model. 
		 */
		[Inject]
		public var model:MainViewBuilderModel;
		
		/**
		 * Injected instance of the main view.
		 **/
		[Inject]
		public var mainView:ClementDauventLayoutManager;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Initializes the fetching of the data on the model.
		 */
		override public function execute():void
		{
			var dummySrc:String = mainView.loaderInfo.parameters.dummySrc || 'img/DummyBitmapData.png';
			Logger.print("[INFO] MainViewBuildCommand fetched the following URL for the dummy bitmap image: " + dummySrc);
			eventDispatcher.addEventListener(MainViewBuilderModel.READY, readyHandler);
			model.buildDataForMainView(dummySrc);
		}
		
		/**
		 * @private	readyHandler
		 * @return	void
		 * 
		 * Event handler triggered when data is available on the model.
		 * Broadcasts the news as an event in eventDispatcher.
		 */
		protected function readyHandler(e:Event):void
		{
			eventDispatcher.removeEventListener(MainViewBuilderModel.READY, readyHandler);
			createMainView();
		}
		
		/**
		 * @private	createMainView
		 * @return	void
		 * 
		 * Creates and adds to the root view class an instance of MainView.
		 */
		protected function createMainView():void
		{
			// Create the main view.
			var mainView:MainView = new MainView();
			mainView.create(model.vo.data);
			
			// Create the custom context menu.
			var contextMenu:ContextMenuView = new ContextMenuView();
			mainView.contextMenu = contextMenu.menu;
			
			// Use the injector to turn this MainView and ContextMenuView instances into singletons.
			injector.mapValue(MainView, mainView);
			injector.mapValue(ContextMenuView, contextMenu);
			
			// Add the view to the display list.
			contextView.addChild(mainView);
			
			Logger.print("[INFO] MainViewBuildCommand has created the MainView instance and added it to the display list");
			
			// Use the event bus to require data from the main model and initialize the build of images views.
			eventDispatcher.dispatchEvent(new DataFetchEvent(DataFetchEvent.REQUIRE_DATA_FOR_IMAGES));
		}
	}
}