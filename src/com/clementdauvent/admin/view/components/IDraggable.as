package com.clementdauvent.admin.view.components
{
	public interface IDraggable
	{
		function get id():uint;
		function get x():Number;
		function get y():Number;
		function get isFirst():Boolean;
		function set isFirst(value:Boolean):void;
		function flash():void;
		function toString():String;
	}
}