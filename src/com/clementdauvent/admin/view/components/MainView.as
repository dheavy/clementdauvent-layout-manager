package com.clementdauvent.admin.view.components
{	
	import com.clementdauvent.admin.view.components.IResizable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	/**
	 * <p>The view serving as a grided backdrop for the layout tool.</p>
	 */
	public class MainView extends Sprite implements IResizable
	{
		/*	@private	_bmp:Bitmap			The container for the gridded backdrop. */
		protected var _bmp		:Bitmap;
		
		/*	@private	_elements:Sprite	The container for the elements (images, texts) that will be added in here. */
		protected var _elements	:Sprite;
		
		/*	@private	_mask:Sprite		The container for the mask over this container. */
		protected var _mask		:Sprite;
		
		/**
		 * @public	MainView
		 * @return	this
		 * 
		 * Creates an instance of MainView, the grided backdrop for the layout tool.
		 */
		public function MainView() 
		{
			_elements = new Sprite();
			addChild(_elements);
			
			_mask = new Sprite();
			addChild(_mask);
		}
		
		/**
		 * @public	elementWidth
		 * @return	The width of this view, after rescale. To be used instead of width.
		 */
		public function get elementWidth():Number
		{
			return width / scaleX;	
		}
		
		/**
		 * @public	elementHeight
		 * @return	The height of this view, after rescale. To be used instead of width.
		 */
		public function get elementHeight():Number
		{
			return height / scaleY;
		}
		
		
		/**
		 * @public	scale
		 * @return	The current scale of this element.
		 */
		public function get scale():Number
		{
			return scaleX;	
		}
		
		/**
		 * @public	create
		 * @param	data:BitmapData	The BitmapData captured from a loaded images, ready to be injected as a backdrop cover in this instance.
		 * @return	void
		 */
		public function create(data:BitmapData):void
		{
			_bmp = new Bitmap(data, PixelSnapping.AUTO, true);
			addChild(_bmp);
			
			// Now that we have the dimensions of the bitmap, the mask construction can be completed.
			_mask.name = "mask";
			_mask.graphics.beginFill(0, 0);
			_mask.graphics.drawRect(0, 0, _bmp.width, _bmp.height);
			_mask.graphics.endFill();
			_mask.mouseEnabled = false;
		}
		
		/**
		 * @public	addElement
		 * @param	e:DisplayObject	An element (images, texts) to add in this container.
		 * @return	void
		 */
		public function addElement(e:DisplayObject):void
		{
			_elements.addChild(e);
		}
		
		/**
		 * @public	activateMask
		 * @return	void
		 * 
		 * Activate the mask over this view, hiding all elements going out of its borders.
		 */
		public function activateMask():void
		{
			_elements.mask = _mask;
		}
	}
}