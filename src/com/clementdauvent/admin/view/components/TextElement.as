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
	
	public class TextElement extends Sprite implements IResizable, IDraggable
	{
		public static const WIDTH:Number = 800;
		
		public static const HEIGHT:Number = 600;
		
		protected var _id:uint;
		protected var _title:String;
		protected var _content:String;
		protected var _isFirst:Boolean;
		protected var _background:Shape;
		protected var _fieldsContainer:Sprite;
		protected var _titleField:TextField;
		protected var _contentField:TextField;
		
		public function TextElement(id:uint, title:String, content:String)
		{
			_id = id;
			_title = title;
			_content = content;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function get id():uint
		{
			return _id;
		}
		
		public function get isFirst():Boolean
		{
			return false;
		}
		
		public function set isFirst(value:Boolean):void
		{
			_isFirst = value;
			promote(value);
		}
		
		public function get elementWidth():Number
		{
			return TextElement.WIDTH;
		}
		
		public function get elementHeight():Number
		{
			return TextElement.HEIGHT;
		}
		
		public function get scale():Number
		{
			return 1;
		}
		
		public function flash():void
		{
			TweenMax.to(_background, .2, { glowFilter: { color: 0xFFFFFF, alpha: 1, blurX: 20, blurY: 20 }, onComplete: 
				function():void {
					TweenMax.to(_background, 1.5, { glowFilter: { color: 0xFFFFFF, alpha: 0, blurX: 0, blurY: 20 } } );
				}
			} );
		}
		
		public function serialize():TextVO
		{
			return new TextVO(_title, _content, isFirst, x, y);
		}
		
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
		
		protected function promote(value:Boolean):void
		{
			if (value) {
				TweenMax.to(_background, 1, { colorTransform: { tint: 0x00CCFF, tintAmount: .5 } }); 
			} else {
				TweenMax.to(_background, .5, { colorTransform: { tint: 0x00CCFF, tintAmount: 0 } }); 
			}
		}
		
	}
}