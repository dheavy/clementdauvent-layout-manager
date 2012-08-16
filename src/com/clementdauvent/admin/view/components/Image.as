// TODO: Finish commenting. Implement imgLoader handlers.
package com.clementdauvent.admin.view.components
{
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
	
	public class Image extends Sprite implements IDraggable, IResizable
	{
		public static const HANDLE_DIMENSIONS	:Number = 70;
		public static const HANDLE_GFX_SRC		:Number = '';
		
		protected var _id						:uint;
		protected var _src						:String;
		protected var _elementWidth				:Number;
		protected var _elementHeight			:Number;
		protected var _referenceDimension		:Number;
		protected var _handleLoader				:Loader;
		protected var _handle					:Sprite;
		protected var _img						:Bitmap;
		protected var _imgLoader				:Loader;
		protected var _progressBar				:Shape;
		
		/**
		 * @public	Image
		 * @param	id:uint		Unique ID for this instance.
		 * @param	src:String	URL for this image resource.
		 * @param	w:Number	Basic witdh for this element.
		 * @param	h:Number	Basic height for this element.
		 * @return	this
		 * 
		 * Creates an instance of draggable, resizable Image element.
		 */
		public function Image(id:uint, src:String, w:Number, h:Number)
		{
			_id = id;
			_src = src;
			_elementWidth = w;
			_elementHeight = h;
			_referenceDimension = h;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * @return	id:uint	Unique ID for this instance. 
		 **/
		public function get id():uint
		{
			return _id;
		}
		
		/**
		 * @return	elementWidth:Number	Computed width of the element after manipulation. Use instead of width. 
		 **/
		public function get elementWidth():Number
		{
			return _elementWidth;
		}
		
		/**
		 * @return	elementHeight:Number	Computed height of the element after manipulation. Use instead of height. 
		 **/
		public function get elementHeight():Number
		{
			return _elementHeight;
		}
		
		/**
		 * @return	scale:Number	Current scale of the element. 
		 **/
		public function get scale():Number
		{
			return _img.scaleY;
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
			_img = new Bitmap(new BitmapData(100, 100));
			addChild(_img);
			
			_handle = new Sprite();
			var g:Graphics = _handle.graphics;
			var half:Number = Image.HANDLE_DIMENSIONS / 2;
			g.beginFill(0x0, 0);
			g.moveTo(-half, -half);
			g.lineTo(half, half);
			g.lineTo(half, half);
			g.lineTo(-half, -half);
			g.endFill();
			_handle.visible = false;
			addChild(_handle);
			
			// Position handle to bottom right and register listener for handle drags.
			_handle.buttonMode = true;
			_handle.x = _img.width;
			_handle.y = _img.height;
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			
			// Creates progress bar and leave it ready for loading action...
			_progressBar = new Shape();
			g = _progressBar.graphics;
			g.beginFill(0x999999);
			g.moveTo(0, 0);
			g.lineTo(_img.width, 0);
			g.lineTo(_img.width, _img.height);
			g.lineTo(0, _img.height);
			g.lineTo(0, 0);
			g.endFill();
			_progressBar.scaleX = 0;
			addChild(_progressBar);			
			
			// Load cursor image.
			_handleLoader = new Loader();
			_handleLoader.contentLoaderInfo.addEventListener(Event.INIT, handleLoader_initHandler);
			_handleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IOErrorEvent, handleLoader_ioErrorHandler);
			_handleLoader.load(new URLRequest(Image.HANDLE_GFX_SRC));
			
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
		 * @private	scaleCompensation
		 * @return	scaleCompensation:Number	The newly computed scale to assign to graphic elements that have been scaled down.
		 */
		protected function get scaleCompensation():Number 
		{
			return 1 / parent.scaleX;
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
			_handleLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IOErrorEvent, handleLoader_ioErrorHandler);
			_handleLoader = null;
		}
		
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
			_handle.scaleX = _handle.scaleY = scaleCompensation;
			_handle.x = _img.x + _img.width - _handle.width;
			_handle.y = _img.y + _img.height - _handle.height;
		}
		
		/**
		 * @private	handleLoader_initHandler
		 * @return	void
		 * 
		 * Event handler triggered when handle graphics loads successfully. Add it to display list.
		 */
		protected function handleLoader_initHandler(e:Event):void
		{
			_handle.addChild(e.target.content as Bitmap);
			removeHandleLoaderListeners();
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
			trace("[ERROR] Image " + id + " couldn't load graphic for resize handle: " + e.text); 
		}
		
		protected function imgLoader_initHandler(e:Event):void
		{
			TweenMax.to(_img, 0, { autoAlpha: 0 });
			
			_img = (e.target as LoaderInfo).content as Bitmap;
			_img.smoothing = true;
			
			TweenMax.to(_img, 1, { autoAlpha: 1 });
			TweenMax.to(_progressBar, .5, { autoAlpha: 0, onComplete: 
				function() {
					removeChild(_progressBar);
					_progressBar = null;
				}
			});
			
			removeImgLoaderListeners();
		}
		
		protected function imgLoader_progressHandler(e:ProgressEvent):void
		{
			
		}
		
		protected function imgLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			
		}
		
		/**
		 * @private	handle_mouseDownHandler
		 * @return	void
		 * 
		 * Event handler triggered on mouse down action. Shows handle, starts drag.
		 */
		protected function handle_mouseDownHandler(e:MouseEvent):void
		{
			_handle.removeEventListener(MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			_handle.addEventListener(MouseEvent.MOUSE_UP, handle_mouseUpHandler);
			_handle.addEventListener(MouseEvent.MOUSE_OUT, handle_mouseUpHandler);
			_handle.addEventListener(Event.ENTER_FRAME, handle_enterFrameHandler);
			
			_handle.visible = true;
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
			_handle.removeEventListener(MouseEvent.MOUSE_OUT, handle_mouseUpHandler);
			
			_handle.stopDrag();
			_handle.x = _img.width;
			_handle.y = _img.height;
			_handle.visible = false;
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