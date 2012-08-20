package com.clementdauvent.admin.controller.commands
{
	import com.clementdauvent.admin.model.MainViewBuilderModel;
	import com.clementdauvent.admin.view.components.MainView;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command fetching the data to build the main view.</p>
	 */
	public class MainViewBuildCommand extends Command
	{
		/*	@public	model:MainViewBuilderModel	Injected instance of the model. */
		[Inject]
		public var model:MainViewBuilderModel;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Initializes the fetching of the data on the model.
		 */
		override public function execute():void
		{
			eventDispatcher.addEventListener(MainViewBuilderModel.READY, readyHandler);
			model.buildDataForMainView();
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
			var mainView:MainView = new MainView();
			mainView.create(model.vo.data);
			contextView.addChild(mainView);
			
			trace("[INFO] MainViewBuildCommand has created the MainView instance and added it to the display list");
		}
	}
}