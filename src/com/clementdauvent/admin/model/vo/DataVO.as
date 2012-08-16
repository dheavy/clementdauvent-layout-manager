package com.clementdauvent.admin.model.vo
{
	/**
	 * DataVO
	 * Value Object holding all data extracted from the JSON file on startup,
	 * constitutive of the model for the application.
	 */
	public class DataVO
	{
		/* @private	_images:Vector.<ImageVO>	The vector list of ImageVO instances fetched. */
		protected var _images	:Vector.<ImageVO>;
		
		/* @private	_texts:Vector.<TextVO>	The vector list of TextVO instances fetched. */
		protected var _texts	:Vector.<TextVO>;
		
		/**
		 * @public 	DataVO
		 * @param	images:Vector.<ImageVO>	The vector list of ImageVO instances fetched.
		 * @param	texts:Vector.<TextsVO> The vector list of TextsVO instances fetched.
		 * @return 	this
		 */
		public function DataVO(images:Vector.<ImageVO>, texts:Vector.<TextVO>)
		{
			_images = images;
			_texts = texts;
		}
		
		/**
		 * @return	A vector list of ImageVO instances fetched by the model.
		 */
		public function get images():Vector.<ImageVO>
		{
			return _images;
		}
		
		/**
		 * @return	A vector list of TextVO instances fetched by the model.
		 */
		public function get texts():Vector.<TextVO>
		{
			return _texts;	
		}
	}
}