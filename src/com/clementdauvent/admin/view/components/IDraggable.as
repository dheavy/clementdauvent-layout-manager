package com.clementdauvent.admin.view.components
{
	/**
	 * <p>Interface for draggable objects.</p>
	 */
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