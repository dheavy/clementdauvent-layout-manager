package com.clementdauvent.admin.controller.events
{
	import com.clementdauvent.admin.model.vo.DataVO;
	
	import flash.events.Event;
	
	/**
	 * DataFetchEvent
	 * Event class for managing data fetching mechanism at app startup.
	 */
	public class DataFetchEvent extends Event
	{
		/* @public BEGIN:String	Event type "setupBegin". */
		public static const BEGIN		:String = "setupBegin";
		
		/* @public	COMPLETE:String	Event type "setupComplete". */
		public static const COMPLETE	:String = "setupComplete";
		
		/* @public vo:DataVO	A DataVO instance that instances of DataFetchEvent may carry around. */
		public var vo					:DataVO;
		
		/**
		 * @public	DataFetchEvent
		 * @param	type:String			The Event type — DataFetchEvent.BEGIN or DataFetchEvent.COMPLETE.
		 * @param	vo:DataVO			An optional DataVO instance.Defaults to null.
		 * @param	bubbles:Boolean		Whether or not the event should bubble up the event tree.
		 * @param	cancelable:Boolean	Whether or not the event should be cancelable.
		 * @return	this
		 * 
		 * Creates an instance of DataFetchEvent, a custom event used to manage the fetching process of external data for the app.
		 */
		public function DataFetchEvent(type:String, vo:DataVO = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.vo = vo;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @public	clone
		 * @return	An instance of DataFetchEvent cloned from this one.
		 */
		override public function clone():Event
		{
			return new DataFetchEvent(type, vo, bubbles, cancelable);
		}
		
		/**
		 * @public	toString
		 * @return	A String-formatted representation of this instance.
		 */
		override public function toString():String
		{
			return formatToString("DataFetchEvent", "vo", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}