package com.clementdauvent.admin.controller.commands
{
	import com.clementdauvent.admin.controller.events.DataFetchEvent;
	import com.clementdauvent.admin.model.DataPublisherModel;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command in charge of creating the model saving the data, and use it to do so.</p>
	 */
	public class PublishDataCommand extends Command
	{
		/**
		 * An injected singleton instance of event that triggered the command. 
		 */
		[Inject]
		public var dataFetchEvent:DataFetchEvent;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes the command: creates the model for publishing data, and use it to attempt saving the data.
		 */
		override public function execute():void
		{
			var publisher:DataPublisherModel = new DataPublisherModel();
			publisher.save(dataFetchEvent.vo);
		}
	}
}