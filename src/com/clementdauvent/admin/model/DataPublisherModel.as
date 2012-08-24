package com.clementdauvent.admin.model
{
	import com.clementdauvent.admin.controller.events.DataFetchEvent;
	import com.clementdauvent.admin.model.vo.DataVO;
	import com.sociodox.utils.Base64;
	
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Actor;
	
	public class DataPublisherModel extends Actor
	{
		public function DataPublisherModel()
		{
			// Silence is golden...
		}
		
		public function save(vo:DataVO):void
		{
			if (!ExternalInterface.available) {
				trace("[ERROR] ExternalInterface unavailable. Can't save data.");
				
			} else {
				ExternalInterface.call("console.log", "[INFO] DataPublisherModel call via ExternalInterface");
				ExternalInterface.call("saveData", serializeToString(vo));
			}
		}
		
		protected function serializeToString(o:DataVO):String
		{
			if (!o) {
				throw Error("[ERROR] Not a valid serialization candidate !");
				return null;
			}
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeUTFBytes(JSON.stringify(o));
			
			var serialized:String = Base64.encode(byteArray);
			return serialized;
		}
	}
}