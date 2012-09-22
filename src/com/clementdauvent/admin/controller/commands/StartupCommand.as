package com.clementdauvent.admin.controller.commands
{
	import com.clementdauvent.admin.ClementDauventLayoutManager;
	import com.clementdauvent.admin.context.ApplicationContext;
	import com.clementdauvent.admin.model.ApplicationModel;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command invoked on startup, invoking the beginning of the fetching/populating of data in the model.</p>
	 */
	public class StartupCommand extends Command
	{
		/**
		 * An injected singleton instance of the main model class. 
		 */
		[Inject]
		public var model:ApplicationModel;
		
		[Inject]
		public var mainView:ClementDauventLayoutManager;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes the command: invokes the external data fetching to populate the model.
		 */
		override public function execute():void
		{
			var dataSrc:String = mainView.loaderInfo.parameters.data || 'data/data.json';
			model.loadJSON(dataSrc);
		}
	}
}