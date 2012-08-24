package com.clementdauvent.admin.view.components
{	
	import com.clementdauvent.admin.view.components.IResizable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * <p>The view serving as a grided backdrop for the layout tool.</p>
	 */
	public class MainView extends Sprite implements IResizable
	{
		/**
		 * @private	The container for the gridded backdrop.
		 */
		protected var _bmp:Bitmap;
		
		/**
		 * @private	The container for the elements (images, texts) that will be added in here.
		 */
		protected var _elements:Sprite;
		
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
			
			_bmp = new Bitmap();
		}
		
		/**
		 * @public	elementWidth
		 * @return	The width of this view, after rescale. To be used instead of width.
		 */
		public function get elementWidth():Number
		{
			return _bmp.width;	
		}
		
		/**
		 * @public	elementHeight
		 * @return	The height of this view, after rescale. To be used instead of width.
		 */
		public function get elementHeight():Number
		{
			return _bmp.height;
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
		 * @public	setImageOnTop
		 * @param	img:Image	An Image instance, children of the MainView container, to put on top of the stack.
		 * @return	void
		 * 
		 * Push the selected Image on top of the visual image stack.
		 */
		public function setImageOnTop(img:Image):void
		{
			if (_elements.contains(img) && _elements.numChildren > 1 && img != _elements.getChildAt(_elements.numChildren - 1)) {
				while (img != _elements.getChildAt(_elements.numChildren - 1)) {
					_elements.swapChildrenAt(_elements.getChildIndex(img), _elements.getChildIndex(img) + 1);
				}
				img.flash();
			}
		}
		
		public function setAsFirstImage(img:Image):void
		{
			var i:int = 0, length:int = _elements.numChildren;
			for (i; i < length; i++) {
				if (_elements.getChildAt(i) is Image) {
					if (_elements.getChildAt(i) === img) {
						Image(_elements.getChildAt(i)).isFirst = true;
					} else {
						Image(_elements.getChildAt(i)).isFirst = false;
					}
				}
			}
		}
		
		public function returnImageUnderPoint(p:Point):Image
		{
			var i:int = _elements.numChildren - 1;
			
			for (i; i > 0; i--) {
				var img:Image = _elements.getChildAt(i) as Image;
				if ((img.x < p.x && img.x + img.elementWidth > p.x) && (img.y < p.y && img.y + img.elementHeight > p.y)) {
					return img;
				}
			}
			
			return null;
		}
	}
}