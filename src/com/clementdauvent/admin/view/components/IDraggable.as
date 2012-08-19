package com.clementdauvent.admin.view.components
{
	/**
	 * IDraggable
	 * Interface for draggable elements.
	 */
	public interface IDraggable
	{
		/* @public	id:uint	Unique ID for this instance. */
		function get id()			:uint;
		
		/* @public	elementWidth:Number	Computed width of the element after manipulation. Use instead of width. */
		function get elementWidth()	:Number;
		
		/* @public	elementHeight:Number	Computed height of the element after manipulation. Use instead of height. */
		function get elementHeight()	:Number;
		
		/* @public	scale:Number	Current scale of the element. */
		function get scale()			:Number;
	}
}