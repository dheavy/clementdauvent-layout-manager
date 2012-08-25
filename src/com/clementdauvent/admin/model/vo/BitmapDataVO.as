package com.clementdauvent.admin.model.vo
{
	import flash.display.BitmapData;

	/**
	 * <p>Value Object carrying bitmapdata.</p>
	 */
	public class BitmapDataVO
	{
		/**
		 * The bitmapdata carried by this instance. 
		 */
		protected var _data:BitmapData;
		
		/**
		 * @public	BitmapDataVO
		 * @param	data:BitmapData	The BitmapData carried by this instance. Defaults to null.
		 * @return	this
		 * 
		 * Creates an instance of BitmapDataVO, a value object carrying BitmapData.
		 */
		public function BitmapDataVO(data:BitmapData = null)
		{
			_data = data;
		}
		
		/**
		 * @public	data
		 * @return	The BitmapData value carried by this instance.
		 */
		public function get data():BitmapData
		{
			return _data;
		}
		
		/**
		 * @private	data
		 * @param	value:BitmapData
		 * @return	void
		 * 
		 * Setter method to change the value of the carried BitmapData.
		 */
		public function set data(value:BitmapData):void
		{
			_data = value;
		}
	}
}