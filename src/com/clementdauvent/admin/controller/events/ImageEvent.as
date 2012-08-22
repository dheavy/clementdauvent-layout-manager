package com.clementdauvent.admin.controller.events
{
	import com.clementdauvent.admin.view.components.Image;
	
	import flash.events.Event;
	
	public class ImageEvent extends Event
	{
		public static const PLACE_ON_TOP:String = "placeOnTop";
			
		public var img:Image;
		
		public function ImageEvent(img:Image, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.img = img;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ImageEvent(img, type, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("ImageEvent", "img", "type", "bubbles", "cancelable");
		}
	}
}