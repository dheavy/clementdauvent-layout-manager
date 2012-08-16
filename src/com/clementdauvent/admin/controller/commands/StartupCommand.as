package com.clementdauvent.admin.controller.commands
{
	import org.robotlegs.mvcs.Command;
	
	import com.clementdauvent.admin.model.ApplicationModel;
	
	/**
	 * StartupCommand
	 * Command invoked on startup, invoking the beginning of the fetching/populating of data in the model.
	 */
	public class StartupCommand extends Command
	{
		[Inject]
		/* @public	model:ApplicationModel	An injected singleton instance of the main model class. */
		public var model:ApplicationModel;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes the command: invokes the external data fetching to populate the model.
		 */
		override public function execute():void
		{
			model.loadJSON();
		}
	}
}