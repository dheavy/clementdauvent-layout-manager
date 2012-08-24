package com.clementdauvent.admin.controller.commands
{
	import com.clementdauvent.admin.controller.events.DataFetchEvent;
	import com.clementdauvent.admin.model.DataPublisherModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class PublishDataCommand extends Command
	{
		[Inject]
		public var dataFetchEvent:DataFetchEvent;
		
		override public function execute():void
		{
			var publisher:DataPublisherModel = new DataPublisherModel();
			publisher.save(dataFetchEvent.vo);
		}
	}
}