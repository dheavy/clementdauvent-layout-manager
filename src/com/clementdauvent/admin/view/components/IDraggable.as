package com.clementdauvent.admin.view.components
{
	/**
	 * IDraggable
	 * Interface for draggable elements.
	 */
	public interface IDraggable
	{
		/* @public	id:uint	Unique ID for this instance. */
		public function get id()			:uint;
		
		/* @public	elementWidth:Number	Computed width of the element after manipulation. Use instead of width. */
		public function get elementWidth()	:Number;
		
		/* @public	elementHeight:Number	Computed height of the element after manipulation. Use instead of height. */
		public function get elementHeight()	:Number;
		
		/* @public	scale:Number	Current scale of the element. */
		public function get scale()			:Number;
	}
}