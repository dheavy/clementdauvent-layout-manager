package com.clementdauvent.admin.view.components
{
	import com.clementdauvent.admin.model.vo.TextVO;
	import com.clementdauvent.admin.view.components.IDraggable;
	import com.clementdauvent.admin.view.components.IResizable;
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * <p>Draggable element on MainView containing text content</p>
	 */
	public class TextElement extends Sprite implements IResizable, IDraggable
	{
		/**
		 * Default width of TextElement.
		 */
		public static const WIDTH:Number = 800;
		
		/**
		 * Default height of TextElement.
		 */
		public static const HEIGHT:Number = 600;
		
		/**
		 * @private	UID of this instance.
		 */
		protected var _id:uint;
		
		/**
		 * @private	Text for the title of this element.
		 */
		protected var _title:String;
		
		/**
		 * @private	Text for the content of this element.
		 */
		protected var _content:String;
		
		/**
		 * @private	Whether or not this element should be the opening element on the website.
		 */
		protected var _isFirst:Boolean;
		
		/**
		 * @private	The background shape of this instance.
		 */
		protected var _background:Shape;
		
		/**
		 * @private	The container for textfields in this instance.
		 */
		protected var _fieldsContainer:Sprite;
		
		/**
		 * @private	The textfield for the title.
		 */
		protected var _titleField:TextField;
		
		/**
		 * @private	The textfield for the content.
		 */
		protected var _contentField:TextField;
		
		/**
		 * @public	TextElement
		 * @param	id:uint	The UID for this instance.
		 * @param	title:String	The title of this element.
		 * @param	content:String	The text content of this element.
		 * @return	this	
		 * 
		 * Creates an instance of TextElement, draggable element in MainView containing text.
		 */
		public function TextElement(id:uint, title:String, content:String)
		{
			_id = id;
			_title = title;
			_content = content;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * @public	id
		 * @return	The UID of this instance.
		 */
		public function get id():uint
		{
			return _id;
		}
		
		/**
		 * @public	isFirst
		 * @return	Whether or not this instance should be the opening element on the website.
		 */
		public function get isFirst():Boolean
		{
			return false;
		}
		
		/**
		 * @public	isFirst
		 * @return	void
		 * 
		 * Sets the "isFirst" boolean flag.
		 */
		public function set isFirst(value:Boolean):void
		{
			_isFirst = value;
			promote(value);
		}
		
		/**
		 * @public	elementWidth
		 * @return	The width of this element.
		 */
		public function get elementWidth():Number
		{
			return TextElement.WIDTH;
		}
		
		/**
		 * @public	elementHeight
		 * @return	The height of this element.
		 */
		public function get elementHeight():Number
		{
			return TextElement.HEIGHT;
		}
		
		/**
		 * @public	scale
		 * @return	The scale of the element.
		 */
		public function get scale():Number
		{
			return 1;
		}
		
		/**
		 * @public	flash
		 * @return	void
		 * 
		 * Flashes a quick glow around the TextElement. Used when element is re-stacked on top.
		 */
		public function flash():void
		{
			TweenMax.to(_background, .2, { glowFilter: { color: 0xFFFFFF, alpha: 1, blurX: 20, blurY: 20 }, onComplete: 
				function():void {
					TweenMax.to(_background, 1.5, { glowFilter: { color: 0xFFFFFF, alpha: 0, blurX: 0, blurY: 20 } } );
				}
			} );
		}
		
		/**
		 * @public	serialize
		 * @return	A TextVO instance, serialized version of the TextElement.
		 */
		public function serialize():TextVO
		{
			return new TextVO(_title, _content, isFirst, x, y);
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
				TweenMax.to(_background, 1, { colorTransform: { tint: 0x00CCFF, tintAmount: .5 } }); 
			} else {
				TweenMax.to(_background, .5, { colorTransform: { tint: 0x00CCFF, tintAmount: 0 } }); 
			}
		}
		
		/**
		 * @public	toString
		 * @return	A string representation of this instance.
		 */
		override public function toString():String
		{
			return "[TextElement — id: " + id + ", title: " + _title + ", content: " + _content + ", isFirst: " + isFirst + ", x: " + x + ", y: " + y + "]";
		}
		
		/**
		 * @private	init
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Builds the instance visually.
		 */
		protected function init(e:Event):void
		{
			_background = new Shape();
			_background.graphics.beginFill(0x000000, .9);
			_background.graphics.drawRect(0, 0, TextElement.WIDTH, TextElement.HEIGHT);
			_background.graphics.endFill();
			addChild(_background);
			
			var format1:TextFormat = new TextFormat();
			format1.color = 0xFFFFFF;
			format1.size = 42;
			
			var format2:TextFormat = new TextFormat();
			format2.color = 0xFFFFFF;
			format2.size = 24;
			
			_fieldsContainer = new Sprite();
			addChild(_fieldsContainer);
			
			_titleField = new TextField();
			_titleField.defaultTextFormat = format1;
			_titleField.text = _title;
			_titleField.selectable = false;
			_titleField.autoSize = TextFieldAutoSize.LEFT;
			_fieldsContainer.addChild(_titleField);
						
			_contentField = new TextField();
			_contentField.multiline = true;
			_contentField.defaultTextFormat = format2;
			_contentField.htmlText = _content;
			_contentField.autoSize = TextFieldAutoSize.LEFT;
			_contentField.x = _titleField.x;
			_contentField.y = _titleField.y + _titleField.height + 30;
			_contentField.selectable = false;
			_fieldsContainer.addChild(_contentField);
			
			_fieldsContainer.x = (_background.width - _fieldsContainer.width) / 2;
			_fieldsContainer.y = (_background.height - _fieldsContainer.height) / 2;
			_fieldsContainer.mouseEnabled = false;
		}		
	}
}