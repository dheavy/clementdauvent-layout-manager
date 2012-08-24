package com.clementdauvent.admin.view.components
{	
	import com.clementdauvent.admin.view.components.IDraggable;
	import com.clementdauvent.admin.view.components.IResizable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		 * @private	Whether or not the publication is enabled.
		 */
		protected var _canPublish:Boolean;
		
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
		 * @public	elements
		 * @return	The container for the elements.
		 */
		public function get elements():Sprite
		{
			return _elements;
		}
		
		/**
		 * @public	canPublish
		 * @return	Whether or not the publication is enabled.
		 */
		public function get canPublish():Boolean
		{
			return _canPublish;
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
		 * @param	e:Sprite	An element (images, texts) to add in this container.
		 * @return	void
		 */
		public function addElement(e:Sprite):void
		{
			_elements.addChild(e);
		}
		
		/**
		 * @public	setElementOnTop
		 * @param	elm:Sprite	A Sprite, children of the MainView container, to put on top of the stack.
		 * @return	void
		 * 
		 * Push the selected Image on top of the visual image stack.
		 */
		public function setElementOnTop(elm:Sprite):void
		{
			if (_elements.contains(elm) && _elements.numChildren > 1 && elm != _elements.getChildAt(_elements.numChildren - 1)) {
				while (elm != _elements.getChildAt(_elements.numChildren - 1)) {
					_elements.swapChildrenAt(_elements.getChildIndex(elm), _elements.getChildIndex(elm) + 1);
				}
				if (elm is IDraggable) IDraggable(elm).flash();
			}
		}
		
		/**
		 * @public	setAsFirstElement
		 * @param	elm:IDraggable	An IDraggable instance children of this the MainView.
		 * @return	void
		 * 
		 * Re-stacks the set of element to place the chosen one on top.
		 */
		public function setAsFirstElement(elm:IDraggable):void
		{
			var i:int = 0, length:int = _elements.numChildren;
			for (i; i < length; i++) {
				if (_elements.getChildAt(i) is IDraggable) {
					if (_elements.getChildAt(i) === elm) {
						IDraggable(_elements.getChildAt(i)).isFirst = true;
						_canPublish = true;
					} else {
						IDraggable(_elements.getChildAt(i)).isFirst = false;
					}
				}
			}
		}
		
		/**
		 * @public	returnElementUnderPoint
		 * @param	p:Point	A Point instance representing a position.
		 * @return	IDraggable	An possible IDraggable element under the position set by the Point.
		 *
		 * Returns the element, if any, found at the position set by the Point passed as argument.
		 */
		public function returnElementUnderPoint(p:Point):IDraggable
		{
			var i:int = _elements.numChildren - 1;
			
			for (i; i > 0; i--) {
				var elm:IDraggable = _elements.getChildAt(i) as IDraggable;
				if ((elm.x < p.x && elm.x + IResizable(elm).elementWidth > p.x) && (elm.y < p.y && elm.y + IResizable(elm).elementHeight > p.y)) {
					return elm;
				}
			}
			
			return null;
		}
	}
}