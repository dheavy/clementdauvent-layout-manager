package com.clementdauvent.admin.view.components
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	
	/**
	 * <p>The view serving as a grided backdrop for the layout tool.</p>
	 */
	public class MainView extends Sprite
	{
		/**
		 * @public	MainView
		 * @return	this
		 * 
		 * Creates an instance of MainView, the grided backdrop for the layout tool.
		 */
		public function MainView() 
		{
			// Silence is golden...
		}
		
		/**
		 * @public	create
		 * @param	data:BitmapData	The BitmapData captured from a loaded images, ready to be injected as a backdrop cover in this instance.
		 */
		public function create(data:BitmapData):void
		{
			var bmp:Bitmap = new Bitmap(data, PixelSnapping.AUTO, true);
			addChild(bmp);
		}
	}
}