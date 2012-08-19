package com.clementdauvent.admin
{
	import com.clementdauvent.admin.context.ApplicationContext;
	import com.clementdauvent.admin.model.MainViewBuilderModel;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	/**
	 * ClementDauventLayoutManager
	 * Main class for the Image Layout Manager for ClementDauvent.com admin panel.
	 * 
	 * @author	Davy Peter Braun
	 * @date	2012-08-16
	 */
	
	[SWF(width="1024", height="768", backgroundColor="#E8E8E8", frameRate="30")]
	
	public class ClementDauventLayoutManager extends Sprite
	{
		/**
		 * @public	ClementDauventLayoutManager
		 * @return	this
		 * 
		 * Creates ClementDauventLayoutManager, an Image Layout Manager app
		 * for ClementDauvent.com admin panel.
		 */
		public function ClementDauventLayoutManager()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * @private	init
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Sets up the Stage and invokes app start.
		 */
		protected function init(e:Event = null):void
		{
			trace("[INFO] ClementDauventLayoutManager initialized");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			startApplication();
		}
		
		/**
		 * @private	startApplication
		 * @return	void
		 * 
		 * Effectively start the app via the RobotLegs apparatus.
		 */
		protected function startApplication():void
		{
			new ApplicationContext(this);
		}
	}
}