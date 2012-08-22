package com.clementdauvent.admin.model
{
	import com.clementdauvent.admin.controller.events.DataFetchEvent;
	import com.clementdauvent.admin.model.vo.DataVO;
	import com.clementdauvent.admin.model.vo.ImageVO;
	import com.clementdauvent.admin.model.vo.TextVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * <p>The main model class for the app.</p>
	 * 
	 * @author	Davy Peter Braun
	 * @date	2012-08-16
	 */
	public class ApplicationModel extends Actor
	{
		/**
		 * URL of the JSON data file.
		 */
		public static const JSON_FILE:String = "data/data.json";
		
		/**
		 * @private	URLLoader to fetch JSON file.
		 */
		protected var _jsonLoader:URLLoader;
		
		/**
		 * @private	DataVO instance holding model data.
		 */
		protected var _data:DataVO;
		
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
		 * @public	data
		 * @return	DataVO object holding the application fetched data.
		 */
		public function get data():DataVO
		{
			return _data;
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
			removeLoaderListeners();
			
			// Parse JSON and populate vector lists of images and texts from its data.
			var json:Object = JSON.parse(e.target.data);
			var imagesArr:Array = json.images;
			var textsArr:Array = json.texts;
			var images:Vector.<ImageVO> = new Vector.<ImageVO>();
			var texts:Vector.<TextVO> = new Vector.<TextVO>();
			
			for (var i:int = 0; i < imagesArr.length; i++) {
				var o:Object = imagesArr[i];
				var iVO:ImageVO = new ImageVO(o.src, o.originalWidth, o.originalHeight, o.isFirst, 0, 0, 1, o.description);
				images.push(iVO);
			}
			
			for (i = 0; i < textsArr.length; i++) {
				o = textsArr[i];
				var tVO:TextVO = new TextVO(o.title, o.content, false, 0, 0);
				texts.push(tVO);
			}
			
			// Store the data in the Model.
			_data = new DataVO(images, texts);
			
			trace("[INFO] ApplicationModel has stored data from JSON");
			
			// Tell the app we're done and we can continue, by broadcasting a
			// DataFetchEvent.COMPLETE with a payload of data.
			eventDispatcher.dispatchEvent(new DataFetchEvent(DataFetchEvent.COMPLETE, _data));
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
			trace("[ERROR] ApplicationModel — " + e.text);
			removeLoaderListeners();
		}
	}
}