package com.clementdauvent.admin.controller.events
{
	import com.clementdauvent.admin.view.components.IDraggable;
	
	import flash.events.Event;
	
	/**
	 * <p>Custom Event class for IDraggable related events.</p>
	 */
	public class ElementEvent extends Event
	{
		/**
		 * Event type "placeOnTop".
		 */
		public static const PLACE_ON_TOP:String = "placeOnTop";
			
		/**
		 * An IDraggable instance carried during an event.
		 */
		public var elm:IDraggable;
		
		/**
		 * @public	ElementEvent
		 * @param	elm:IDraggable		An IDraggable instance carried during an event.
		 * @param	type:String			The Event type.
		 * @param	bubbles:Boolean		Whether or not the event should bubble up the display list.
		 * @param	cancelable:Boolean	Whether or not the Event can be cancelled.
		 */
		public function ElementEvent(elm:IDraggable, type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.elm = elm;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @public	clone
		 * @return	Event	A new ElementEvent instance.
		 *
		 * Clones this ElementEvent instance.
		 */
		override public function clone():Event
		{
			return new ElementEvent(elm, type, bubbles, cancelable);
		}
		
		/**
		 * @public	toString
		 * @return	String	A string representation of this instance.
		 */
		override public function toString():String
		{
			return formatToString("ElementEvent", "elm", "type", "bubbles", "cancelable");
		}
	}
}