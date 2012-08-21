package com.clementdauvent.admin.view.mediators
{
	import com.clementdauvent.admin.view.components.Image;
	import com.clementdauvent.admin.view.components.MainView;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>Mediator for Image instance.</p>
	 */
	public class ImageMediator extends Mediator
	{
		/*	@public	image:Image			The injected image instance this mediator mediates. */
		[Inject]
		public var image:Image;
		
		/*	@public	surface:MainView	An injected dependency of the singleton instance of the MainView, parent for instances of Image. */
		[Inject]
		public var surface:MainView;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Registers a listener to trigger initialization when the view is added to the display list.
		 */
		override public function onRegister():void
		{
			image.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		/**
		 * @private	initView
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Initializes the mediation for the view.
		 */
		protected function initView(e:Event):void
		{
			image.removeEventListener(Event.ADDED_TO_STAGE, initView);
			
			image.addEventListener(MouseEvent.MOUSE_DOWN, image_mouseDownHandler);
			
			eventDispatcher.addEventListener(MouseEvent.CLICK, eventBus_clickHandler);
			eventDispatcher.addEventListener(MouseEvent.MOUSE_WHEEL, eventBus_mouseWheelHandler);
		}
		
		/**
		 * @private	image_mouseDownHandler
		 * @param	e:MouseEvent	The MouseEvent passed during the process
		 * @return	void
		 * 
		 * Event handler triggered when user's mouse button is down on the mediated image.
		 * Enables dragging.
		 */
		protected function image_mouseDownHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			image.addEventListener(MouseEvent.MOUSE_UP, image_mouseUpHandler);
			image.addEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			image.removeEventListener(MouseEvent.MOUSE_DOWN, image_mouseDownHandler);
			
			image.startDrag();
		}
		
		/**
		 * @private	image_mouseUpHandler
		 * @param	e:MouseEvent	The MouseEvent passed during the process
		 * @return	void
		 * 
		 * Event handler triggered when user's mouse button is up/off the mediated image.
		 * Disables dragging.
		 */
		protected function image_mouseUpHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			image.addEventListener(MouseEvent.MOUSE_DOWN, image_mouseDownHandler);
			image.removeEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			image.removeEventListener(MouseEvent.MOUSE_UP, image_mouseUpHandler);
			image.stopDrag();
		}
		
		/**
		 * @private	monitorMouseInBounds
		 * @param	e:Event		The Event passed during the process.
		 * @return	void
		 * 
		 * Check if mouse cursor leaves the boundaries of the main view and stops dragging if it happens.
		 */
		protected function monitorMouseInBounds(e:Event):void
		{
			var mouseX:Number = surface.mouseX;
			var mouseY:Number = surface.mouseY;
			if (mouseX < 0 || mouseX > surface.elementWidth || mouseY < 0 || mouseY > surface.elementHeight) {
				image.stopDrag();
			}
		}
		
		/**
		 * @private	eventBus_clickHandler
		 * @param	e:Event		The Event passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered when user clicks on the stage but NOT on the image.
		 * Stops dragging if it happens.
		 */
		protected function eventBus_clickHandler(e:MouseEvent):void
		{
			if (e.target is Stage) {
				image.stopDrag();
			}
		}
		
		/**
		 * @private	eventBus_mouseWheelHandler
		 * @param	e:Event		The Event passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered when user scrolls mouse wheel.
		 * Stops dragging if it happens.
		 */
		protected function eventBus_mouseWheelHandler(e:MouseEvent):void
		{
			image.stopDrag();
		}
	}
}