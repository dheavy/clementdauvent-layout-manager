package com.clementdauvent.admin.model
{
	import com.clementdauvent.admin.controller.events.DataFetchEvent;
	import com.clementdauvent.admin.model.vo.DataVO;
	import com.clementdauvent.admin.utils.Logger;
	
	import com.sociodox.utils.Base64;
	
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * <p>Model for publish data via ExternalInterface and JS outside of Flash, into the database.</p>
	 */
	public class DataPublisherModel extends Actor
	{
		/**
		 * @public	DataPublisherModel
		 * @return	this
		 * 
		 * Creates an instance of DataPubliserModel, a model for publish data via ExternalInterface and JS outside of Flash, into the database.
		 */
		public function DataPublisherModel()
		{
			// Silence is golden...
		}
		
		/**
		 * @public	save
		 * @param	vo:DataVO	The DataVO compiling all the data we want to save in the database.
		 * @return	void
		 * 
		 * Attempts to save the data by pushing it outside of Flash to Javascript via ExternalInterface and Base64 encoding.
		 * TODO: set a bunch of listeners/events to monitor the results.
		 */
		public function save(vo:DataVO):void
		{
			if (!ExternalInterface.available) {
				Logger.print("[ERROR] ExternalInterface unavailable. Can't save data.");
				
			} else {
				Logger.print("[INFO] DataPublisherModel call via ExternalInterface");
				ExternalInterface.call("saveData", serializeToString(vo));
			}
		}
		
		/**
		 * @private	serializeToString
		 * @param	o:DataVO	The DataVO object compiling the data we want to save in the database.
		 * @return	A Base64 encoded string.
		 * 
		 * Turns the data to JSON, then base64-encodes it in order to make it consumable by Javascript in the browser.
		 */
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