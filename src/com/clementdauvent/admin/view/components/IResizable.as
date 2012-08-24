package com.clementdauvent.admin.view.components
{
	/**
	 * <p>Interface for resizable elements.</p>
	 */
	public interface IResizable
	{
		function get x():Number;
		function get y():Number;
		function get elementWidth():Number;
		function get elementHeight():Number;
		function get scale():Number;
	}
}