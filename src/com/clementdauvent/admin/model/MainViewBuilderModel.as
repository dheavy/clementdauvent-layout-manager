package com.clementdauvent.admin.model
{
	import com.clementdauvent.admin.model.vo.BitmapDataVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * <p>Model in charge of setting up the bitmapdata needed to build the main view.</p>
	 * <p>In order to build a bitmap-based view wider than the limited 2880x2880 bitmapdata,
	 * we load a bitmap wider than this, "hijack" its bitmapdata, and inject it later in
	 * a new bitmap. Flash forbids creating bitmapdata wider than the limit but this is
	 * a workaround.</p>
	 */
	public class MainViewBuilderModel extends Actor
	{
		/*	@public	VIEW_BMP_DATA_BUILDER_SRC:String	URL of the image resource used to generate the bitmap data. */
		public static const VIEW_BMP_DATA_BUILDER_SRC:String = "img/DummyBitmapData.jpg";
		
		/*	@public	READY:String	Event constant used to alert of the availability of the data. */
		public static const READY:String = "mainViewReady";
		
		/*	@private	_fileLoader:Loader	The Loader loading the image resource. */
		protected var _fileLoader:Loader;
		
		/*	@private	_vo:BitmapDataVO	The bitmap data container resulting for this manipulation. */
		protected var _vo:BitmapDataVO;
		
		/**
		 * @public	MainViewBuilderModel
		 * @return	this
		 * 
		 * Creates an instance of MainViewBuilderModel, the model in charge of creating
		 * the bitmapdata needed to generate a bitmap-based view wider than the Flash limit,
		 * which is 2880x2880 pixels wide.
		 * 
		 * @usage
		 * var m:MainViewBuilderModel = new MainViewBuilderModel();
		 * m.eventDispatcher.addEventListener(MainViewBuilderModel.READY, handler);
		 * m.buildDataForMainView();
		 * 
		 * function handler(e:Event):void {
		 * 	var bmpD:BitmapData = (e.target as MainViewBuilderModel).mainViewData;
		 *  var bmp:Bitmap = new Bitmap(bmpD);
		 * }
		 */
		public function MainViewBuilderModel()
		{
			_vo = new BitmapDataVO();
		}
		
		/**
		 * @public	buildDataForMainView
		 * @return	void
		 * 
		 * Initialized the bitmap data loading and acquisition process.
		 * Must be invoked AFTER this instance has had a listener registering for its custom READY event.
		 */
		public function buildDataForMainView():void
		{
			_fileLoader = new Loader();
			_fileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fileLoader_completeHandler);
			_fileLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fileLoader_ioErrorHandler);
			_fileLoader.load(new URLRequest(MainViewBuilderModel.VIEW_BMP_DATA_BUILDER_SRC));
		}
		
		/**
		 * @public	vo
		 * @return	The BitmapData generated that should be injected in a new bitmap instance to create a bitmap whose dimensions bypasses the original limit of 2880x2880 px.
		 */
		public function get vo():BitmapDataVO
		{
			if (_vo.data == null) {
				trace("[ERROR] MainViewBuilder has not yet built bitmapdata for main view.");
			}
			
			return _vo;
		}
		
		/**
		 * @private	removeLoaderListeners
		 * @return	void
		 * 
		 * Removes all listeners created during the loading process, as well as the loader itself.
		 */
		protected function removeLoaderListeners():void
		{
			if (_fileLoader) {
				_fileLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, fileLoader_completeHandler);
				_fileLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, fileLoader_ioErrorHandler);
			}
			_fileLoader = null;
		}
		
		
		/**
		 * @private	fileLoader_completeHandler
		 * @return	void
		 * 
		 * Event handler triggered when the image has loaded successfully.
		 * Makes the bitmap data available in the appropriate getter of this instance.
		 */
		protected function fileLoader_completeHandler(e:Event):void
		{
			_vo.data = (_fileLoader.content as Bitmap).bitmapData;
			eventDispatcher.dispatchEvent(new Event(MainViewBuilderModel.READY));
			removeLoaderListeners();
			trace("[INFO] MainViewBuilderModel has acquired the data needed to build the main view");
		}
		
		/**
		 * @private	fileLoader_ioErrorHandler
		 * @return	void
		 * 
		 * Event handler triggered when the loader has failed loading the image.
		 * Displays an error message.
		 */
		protected function fileLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			trace("[ERROR] MainViewBuilderModel could not load its image resource. " + e.text);
			removeLoaderListeners();
		}
	}
}