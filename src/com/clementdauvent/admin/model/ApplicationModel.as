package com.clementdauvent.admin.model
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * ApplicationModel
	 * The main model class for the app.
	 * 
	 * @author	Davy Peter Braun
	 * @date	2012-08-16
	 */
	public class ApplicationModel extends Actor
	{
		/* @public	JSON_FILE:String	URL of the JSON data file. */
		public static const JSON_FILE	:String = "data/data.json";
		
		/* @private	_jsonLoader:URLLoader	URLLoader to fetch JSON file. */
		protected var _jsonLoader		:URLLoader;
		
		/**
		 * @public	ApplicationModel
		 * @return	this
		 * 
		 * Creates an instance of ApplicationModel, the main model class for the app.
		 */
		public function ApplicationModel()
		{
			// Silence is golden...
		}
		
		/**
		 * @public	loadJSON
		 * @return	void
		 * 
		 * Loads the JSON formatted data from given URL, effectively kickstarting the application.
		 */
		public function loadJSON():void 
		{
			_jsonLoader = new URLLoader();
			_jsonLoader.addEventListener(Event.COMPLETE, jsonLoader_completeHandler);
			_jsonLoader.addEventListener(IOErrorEvent.IO_ERROR, jsonLoader_ioErrorHandler);
			_jsonLoader.load(new URLRequest(ApplicationModel.JSON_FILE));
		}
		
		/**
		 * @private	removeLoaderListeners
		 * @return	void
		 * 
		 * Cleans up the listeners used by the loader for JSON data.
		 */
		protected function removeLoaderListeners():void
		{
			if (_jsonLoader) {
				_jsonLoader.removeEventListener(Event.COMPLETE, jsonLoader_completeHandler);
				_jsonLoader.removeEventListener(IOErrorEvent.IO_ERROR, jsonLoader_ioErrorHandler);
			}
		}
		
		/**
		 * @private	jsonLoader_completeHandler
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered if JSON file loading is successful.
		 */
		protected function jsonLoader_completeHandler(e:Event):void
		{
			var json:Object = JSON.decode(e.target.data);
			var imagesArr:Array = json.images;
			var textsArr:Array = json.texts;
			
			
		}
		
		/**
		 * @private	jsonLoader_ioErrorHandler
		 * @param	e:IOErrorEvent	The Event object passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered if JSON file loading fails.
		 */
		protected function jsonLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			
		}
	}
}