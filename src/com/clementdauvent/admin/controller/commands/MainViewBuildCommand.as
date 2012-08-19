package com.clementdauvent.admin.controller.commands
{
	import com.clementdauvent.admin.model.MainViewBuilderModel;
	
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
		}
	}
}