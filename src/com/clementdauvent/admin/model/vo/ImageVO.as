package com.clementdauvent.admin.model.vo
{
	/**
	 * ImageVO
	 * Value Object for elements constitutive of an image.
	 * 
	 * @author	Davy Peter Braun
	 * @date	2012-08-16
	 */
	public class ImageVO
	{
		/* @private	_src:String	URL of the image resource. */
		protected var _src				:String;
		
		/* @private	_originalWidth:Number	Original width of the image. */
		protected var _originalWidth	:Number;
		
		/* @private	_originalHeight:Number	Original height of the image. */
		protected var _originalHeight	:Number;
		
		/* @private	_isFirst:Boolean	Whether image is used as "first image" to appear on website. */
		protected var _isFirst			:Boolean;
		
		/* @private	_xOffset:Number	Horizontal offset of the image, relative to the previous one in the list. */
		protected var _xOffset			:Number;
		
		/* @private	_yOffset:Number	Vertical offset of the image, relative to the previous one in the list. */
		protected var _yOffset			:Number;
		
		/* @private	_scale	The scale of the image, relative to the "first image". */
		protected var _scale			:Number;
		
		/* @private	_description	The information text for this image. */
		protected var _description		:String;
		
		/**
		 * Creates an instance of ImageVO, a value Object holding elements constitutive of Images object.
		 * 
		 * @param	src:String			URL of the image resource.
		 * @param	origWidth:Number	Original width of the image.
		 * @param	origHeight:Number	Original height of the image.
		 * @param	isFirst:Boolean		Whether image is used as "first image" to appear on website.
		 * @param	xOffset:Number		Horizontal offset of the image, relative to the previous one in the list. Defaults to 0.
		 * @param	yOffset:Number		Vertical offset of the image, relative to the previous one in the list. Defaults to 0.
		 * @param	scale:Number		The scale of the image, relative to the "first image". Defaults to 1.
		 * @param	description:String	The information text for this image.
		 */
		public function ImageVO(src:String, origWidth:Number, origHeight:Number, isFirst:Boolean, xOffset:Number= 0 , yOffset:Number = 0, scale:Number = 1, description:String = "")
		{
			_src = src;
			_originalWidth = origWidth;
			_originalHeight = origHeight;
			_isFirst = isFirst;
			_xOffset = xOffset;
			_yOffset = yOffset;
			_scale = scale;
			_description = description;
		}
		
		/**
		 * @return	A string representation of this instance.
		 */
		public function toString():String
		{
			return "[ImageVO — src: '" + src + "', originalWidth: " + originalWidth + ", originalHeight: " + originalHeight + ", isFirst: '" + isFirst + "', xOffset: " + xOffset + ", yOffset: " + yOffset + ", scale: " + scale + ", description: '" + description + "']";
		}
		
		/**
		 * @return	A String representation of the URL of the image resource.
		 */
		public function get src():String
		{
			return _src;
		}
		
		/**
		 * @return	The original width, in pixels, of the image.
		 */
		public function get originalWidth():Number
		{
			return _originalWidth;
		}
		
		/**
		 * @return	The original height, in pixels, of the image.
		 */
		public function get originalHeight():Number
		{
			return _originalHeight;
		}
		
		/**
		 * @return	True if the image is set as "first image" to appear on website, false otherwise.
		 */
		public function get isFirst():Boolean
		{
			return _isFirst;
		}
		
		/**
		 * @return	The amount of pixels for the horizontal offset of this image relative to the previous one on the list.
		 */
		public function get xOffset():Number
		{
			return _xOffset;
		}
		
		/**
		 * @return	The amount of pixels for the vertical offset of this image relative to the previous one on the list.
		 */
		public function get yOffset():Number
		{
			return _yOffset;
		}
		
		/**
		 * @return	The scale of the image, relative to the "first image".
		 */ 
		public function get scale():Number
		{
			return _scale;
		}
		
		/**
		 * @return	A String representing the information text for this image.
		 */
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * @private	Sets a String representation for URL of the image resource.
		 * @param	value:String	New value for src.
		 */
		public function set src(value:String):void
		{
			_src = value;
		}
		
		/**
		 * @private	Sets a value for horizontal offset of the image, relative to the previous one in the list.
		 * @param	value:Number	New value for originalWidth.
		 * @return	void
		 */
		public function set originalWidth(value:Number):void
		{
			_originalWidth = value;
		}
		
		/**
		 * @private	Sets a value for vertical offset of the image, relative to the previous one in the list.
		 * @param	value:Number	New value for originalHeight.
		 * @return	void
		 */
		public function set originalHeight(value:Number):void
		{
			_originalHeight = value;
		}
		
		/**
		 * @private	Sets whether image appear first in the list of images on the website.
		 * @param	value:Boolean	New value for isFirst.
		 * @return	void
		 */
		public function set isFirst(value:Boolean):void
		{
			_isFirst = value;
		}
		
		/**
		 * @private	Sets a value for the horizontal offset of the image, relative to the previous one on the list.
		 * @param	value:Number	New value for xOffset.
		 * @return	void
		 */
		public function set xOffset(value:Number):void
		{
			_xOffset = value;
		}
		
		/**
		 * @private	Sets a value for the vertical offset of the image, relative to the previous one on the list.
		 * @param	value:Number	New value for the yOffset.
		 * @return	void
		 */
		public function set yOffset(value:Number):void
		{
			_yOffset = value;
		}
		
		/**
		 * @private	Sets a value for the scale of the image, relative to the scale of the "first" image.
		 * @param	value:Number	New value for the scale.
		 * @return	void
		 */
		public function set scale(value:Number):void
		{
			
		}
		
		/**
		 * @private	Sets a String as description for the image.
		 * @param	value:String	New value for the description.
		 * @return	void
		 */
		public function set description(value:String):void
		{
			_description = value;
		}
	}
}