package com.clementdauvent.admin.view.components
{
	import com.clementdauvent.admin.model.vo.ImageVO;
	import com.clementdauvent.admin.utils.Logger;
	import com.clementdauvent.admin.view.components.IDraggable;
	import com.clementdauvent.admin.view.components.IResizable;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	 * <p>The Image view used to represent image content on the Surface</p>
	 */
	public class Image extends Sprite implements IResizable, IDraggable
	{
		/**
		 * Dimensions for the handle image.
		 */
		public static const HANDLE_DIMENSIONS:Number = 250;
				
		/**
		 * @private	The unique ID for this instance.
		 */
		protected var _id:uint;
		
		/**
		 * @private	URL for the image resource of this Image instance.
		 */
		protected var _src:String;
		
		/**
		 * @private	Expected width of this element.
		 */
		protected var _elementWidth:Number;
		
		/**
		 * @private	Expected height of this element.
		 */
		protected var _elementHeight:Number;
		
		/**
		 * @private	The value used as reference to compute the scaled dimensions of this instance.
		 */
		protected var _referenceDimension:Number;
		
		/**
		 * @private	The Loader instance loading the resource handle image.
		 */
		protected var _handleLoader:Loader;
		
		/**
		 * @private	The resize handle.
		 */
		protected var _handle:Sprite;
		
		/**
		 * @private	The image container.
		 */
		protected var _img:Sprite;
		
		/**
		 * @private	The Loader loading the image resource.
		 */
		protected var _imgLoader:Loader;
		
		/**
		 * @private	The loading bar used to show progress of image loading.
		 */
		protected var _progressBar:Shape;
		
		/**
		 * @private	Whether or not this is the opening element on the website.
		 */
		protected var _isFirst:Boolean = false;
		
		/**
		 * @private	The description of this image.
		 */
		protected var _desc:String;
		
		/**
		 * @priavte	The URL for the resize handle image.
		 */
		protected var _handleSrc:String;
		
		/**
		 * @public	Image
		 * @param	id:uint				Unique ID for this instance.
		 * @param	src:String			URL for this image resource.
		 * @param	w:Number			Basic witdh for this element.
		 * @param	h:Number			Basic height for this element.
		 * @param	desc:String			The image description.
		 * @param	handleSrc:String	The URL for the resize handle image.
		 * @return	this
		 * 
		 * Creates an instance of draggable, resizable Image element.
		 */
		public function Image(id:uint, src:String, w:Number, h:Number, desc:String, handleSrc:String)
		{
			_id = id;
			_src = src;
			_elementWidth = w;
			_elementHeight = h;
			_referenceDimension = h;
			_desc = desc;
			_handleSrc = handleSrc;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * @public	id
		 * @return	The uint unique id of this instance.
		 */
		public function get id():uint
		{
			return _id;
		}
		
		/**
		 * @public	elementWidth
		 * @return	The width of the image.
		 */
		public function get elementWidth():Number
		{
			return _img.width;
		}
		
		/**
		 * @public	elementHeight
		 * @return	The height of the image.
		 */
		public function get elementHeight():Number
		{
			return _img.height;
		}
		
		/**
		 * @public	scale
		 * @return	The current scale of the image.
		 */
		public function get scale():Number
		{
			return _img.scaleY;
		}
		
		/**
		 * @public	isFirst
		 * @return	Whether or not this is the opening element on the website.
		 */
		public function get isFirst():Boolean
		{
			return _isFirst;
		}
		
		/**
		 * @public	isFirst
		 * @param	value:Boolean	Boolean stating whether or not this is the opening element on the website.
		 * @return	void
		 *
		 * Promotes the element as opening element on the website if value equals true.
		 */
		public function set isFirst(value:Boolean):void
		{
			_isFirst = value;
			promote(value);
		}
		
		/**
		 * @public	toString
		 * @return	A String representation of the instance.
		 */
		override public function toString():String
		{
			return "[Image — id: " + id + ", src: " + _src + ", elementWidth: " + elementWidth + ", elementHeight: " + elementHeight + ", scale: " + scale + "]";
		}
		
		/**
		 * @public	serialize
		 * @return	An ImageVO instance, serialized version of this Image instance.
		 */
		public function serialize():ImageVO
		{
			return new ImageVO(_src, elementWidth, elementHeight, isFirst, x, y, scale, _desc);
		}
		
		/**
		 * @public	init
		 * @return	void
		 * 
		 * Initializes the instance.
		 */
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Creates graphical elements (image and handle containers).
			_img = new Sprite();
			_img.graphics.beginFill(0xDDDDDD);
			_img.graphics.drawRect(0, 0, _elementWidth, _elementHeight);
			addChild(_img);
			
			_handle = new Sprite();
			var g:Graphics = _handle.graphics;
			g.beginFill(0xFF0000, 0);
			g.drawRect(-Image.HANDLE_DIMENSIONS / 2, - Image.HANDLE_DIMENSIONS / 2, Image.HANDLE_DIMENSIONS, Image.HANDLE_DIMENSIONS);
			g.endFill();
			_handle.alpha = 0;
			addChild(_handle);
			
			// Register listener for handle drags.
			_handle.buttonMode = true;
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			
			// Creates progress bar and leave it ready for loading action...
			_progressBar = new Shape();
			g = _progressBar.graphics;
			g.beginFill(0x999999);
			g.moveTo(0, 0);
			g.drawRect(0, 0, width, height);
			g.endFill();
			_progressBar.scaleX = 0;
			addChild(_progressBar);			
			
			// Load cursor image.
			_handleLoader = new Loader();
			_handleLoader.contentLoaderInfo.addEventListener(Event.INIT, handleLoader_initHandler);
			_handleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoader_ioErrorHandler);
			_handleLoader.load(new URLRequest(_handleSrc));
			
			// Load Image resource.
			_imgLoader = new Loader();
			_imgLoader.contentLoaderInfo.addEventListener(Event.INIT, imgLoader_initHandler);
			_imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imgLoader_progressHandler);
			_imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgLoader_ioErrorHandler);
			_imgLoader.load(new URLRequest(_src));
		}
		
		/**
		 * @public	rescale
		 * @return 	void
		 * 
		 * Rescales element proportional to the resize handle position.
		 */
		public function rescale():void
		{
			// Compute scale value and rescale.
			_img.scaleX = _img.scaleY = _handle.y / _referenceDimension;
			_elementWidth = _img.width;
			_elementHeight = _img.height;
			scaleAndPositionHandle();
			
			// Rescale limit is 20% minimum.
			if (_img.scaleX < .2) {
				_img.scaleX = _img.scaleY = .2;
				scaleAndPositionHandle();
				return;
			}
		}
		
		/**
		 * @public	flash
		 * @return	void
		 * 
		 * Flashes a quick glow around the Image. Used when element is re-stacked on top.
		 */
		public function flash():void
		{
			TweenMax.to(_img, .2, { glowFilter: { color: 0xFFFFFF, alpha: 1, blurX: 20, blurY: 20 }, onComplete: 
				function():void {
					TweenMax.to(_img, 1.5, { glowFilter: { color: 0xFFFFFF, alpha: 0, blurX: 0, blurY: 20 } } );
				}
			} );
		}
		
		/**
		 * @public	promote
		 * @param	value:Boolean	True is element is promoted, false otherwise.
		 * @return	void
		 * 
		 * Show visually if element is promoted as opening element of the website, or not.
		 */
		public function promote(value:Boolean):void
		{
			if (value) {
				TweenMax.to(_img, 1, { colorTransform: { tint: 0x00CCFF, tintAmount: .5 } }); 
			} else {
				TweenMax.to(_img, .5, { colorTransform: { tint: 0x00CCFF, tintAmount: 0 } }); 
			}
		}
		
		/**
		 * @private	removeHandleLoaderListeners
		 * @return	void
		 * 
		 * Removes the listeners used by the handle graphics loader.
		 */
		protected function removeHandleLoaderListeners():void
		{
			_handleLoader.contentLoaderInfo.removeEventListener(Event.INIT, handleLoader_initHandler);
			_handleLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleLoader_ioErrorHandler);
			_handleLoader = null;
		}
		
		/**
		 * @private	removeImgLoaderListeners
		 * @return	void
		 * 
		 * Removes the listeners used by the image loader.
		 */
		protected function removeImgLoaderListeners():void
		{
			_imgLoader.contentLoaderInfo.removeEventListener(Event.INIT, imgLoader_initHandler);
			_imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, imgLoader_progressHandler);
			_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgLoader_ioErrorHandler);
			_imgLoader = null;
		}
		
		/**
		 * @private	scaleAndPositionHandle
		 * @return	void
		 * 
		 * Scales and reposition resize handle accordingly.
		 */
		protected function scaleAndPositionHandle():void
		{
			_handle.x = _img.x + _img.width;
			_handle.y = _img.y + _img.height;
		}
		
		/**
		 * @private	handleLoader_initHandler
		 * @return	void
		 * 
		 * Event handler triggered when handle graphics loads successfully. Add it to display list.
		 */
		protected function handleLoader_initHandler(e:Event):void
		{
			var bmp:Bitmap = e.target.content as Bitmap;
			bmp.x = -bmp.width;
			bmp.y = -bmp.height;
			_handle.addChild(bmp);
			removeHandleLoaderListeners();
			scaleAndPositionHandle();
		}
		
		/**
		 * @private	handleLoader_ioErrorHandler
		 * @return	void
		 * 
		 * Event handler triggered when handle graphics loading fails.
		 */
		protected function handleLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			removeHandleLoaderListeners();
			Logger.print("[ERROR] Image " + id + " couldn't load graphic for resize handle: " + e.text); 
		}
		
		/**
		 * @private imgLoader_initHandler
		 * @return	void
		 * 
		 * Event handler triggered when image has loaded successfully. 
		 * Adds image to display list.
		 */
		protected function imgLoader_initHandler(e:Event):void
		{
			TweenMax.to(_img, 0, { autoAlpha: 0 });
			
			var bmp:Bitmap = _imgLoader.content as Bitmap;
			bmp.smoothing = true;
			_img.addChild(bmp);
			
			TweenMax.to(_img, .1, { autoAlpha: 1 });
			TweenMax.to(_progressBar, .5, { autoAlpha: 0, onComplete: 
				function():void {
					removeChild(_progressBar);
					_progressBar = null;
				}
			});
			
			removeImgLoaderListeners();
			scaleAndPositionHandle();
			
			Logger.print("[INFO] Image " + id + " is ready.");
		}
		
		/**
		 * @private	imgLoader_progressHandler
		 * @return	void
		 * 
		 * Event handler triggered on load progress. Updates progress bar.
		 */
		protected function imgLoader_progressHandler(e:ProgressEvent):void
		{
			_progressBar.scaleX = e.bytesLoaded / e.bytesTotal;
		}
		
		/**
		 * @private	imgLoader_ioErrorHandler
		 * @return	void
		 * 
		 * Event handler triggered when image loading fails. 
		 */
		protected function imgLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			removeImgLoaderListeners();
			Logger.print("[ERROR] Image " + id + " couldn't load its photograph: " + e.text);
		}
		
		/**
		 * @private	handle_mouseDownHandler
		 * @return	void
		 * 
		 * Event handler triggered on mouse down action. Shows handle, starts drag.
		 */
		protected function handle_mouseDownHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			_handle.removeEventListener(MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			_handle.addEventListener(MouseEvent.MOUSE_UP, handle_mouseUpHandler);
			_handle.stage.addEventListener(MouseEvent.MOUSE_UP, handle_mouseUpHandler);
			_handle.addEventListener(Event.ENTER_FRAME, handle_enterFrameHandler);
			
			_handle.alpha = 1;
			_handle.startDrag();
		}
		
		/**
		 * @private	handle_mouseUpHandler
		 * @return	void
		 * 
		 * Event handler triggered on mouse up action. Stops drag, hides handle.
		 */
		protected function handle_mouseUpHandler(e:MouseEvent):void
		{
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			_handle.removeEventListener(MouseEvent.MOUSE_UP, handle_mouseUpHandler);
			_handle.stage.removeEventListener(MouseEvent.MOUSE_UP, handle_mouseUpHandler);
			
			_handle.stopDrag();
			_handle.alpha = 0;
			scaleAndPositionHandle();
		}
		
		/**
		 * @private	handle_enterFrameHandler
		 * @return	void
		 * 
		 * Event handler triggered on enter frame action. Adjust scale of this element if needed.
		 */
		protected function handle_enterFrameHandler(e:Event):void
		{
			rescale();
		}
	}
}