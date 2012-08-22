package com.clementdauvent.admin.view.mediators
{
	import com.clementdauvent.admin.controller.events.ImageEvent;
	import com.clementdauvent.admin.view.components.Image;
	import com.clementdauvent.admin.view.components.MainView;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>Mediator for Image instance.</p>
	 */
	public class ImageMediator extends Mediator
	{
		/**
		 * The injected image instance this mediator mediates. 
		 */		
		[Inject]
		public var image:Image;
		
		/**
		 * An injected dependency of the singleton instance of the MainView, parent for instances of Image. 
		 */		
		[Inject]
		public var surface:MainView;
		
		/**
		 * Boolean flag set to true if user is currently pressing the SHIFT key. 
		 */		
		protected var _shiftKeyPressed:Boolean;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Registers a listener to trigger initialization when the view is added to the display list.
		 */
		override public function onRegister():void
		{
			_shiftKeyPressed = false;
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
			image.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			
			eventDispatcher.addEventListener(MouseEvent.CLICK, eventBus_clickHandler);
			eventDispatcher.addEventListener(MouseEvent.MOUSE_WHEEL, eventBus_mouseWheelHandler);
		}
		
		/**
		 * @private	image_mouseDownHandler
		 * @param	e:MouseEvent	The MouseEvent passed during the process
		 * @return	void
		 * 
		 * Event handler triggered when user's mouse button is down on the mediated image.
		 * Enables dragging, or place image on top of the stack if alt-key is pressed.
		 */
		protected function image_mouseDownHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			if (_shiftKeyPressed) {
				trace("[INFO] Placing Image " + image.id + " on top of the stack");
				eventDispatcher.dispatchEvent(new ImageEvent(image, ImageEvent.PLACE_ON_TOP));
				return;
			}
			
			image.addEventListener(MouseEvent.MOUSE_UP, image_mouseUpHandler);
			image.stage.addEventListener(MouseEvent.MOUSE_UP, image_mouseUpHandler);
			image.addEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			image.removeEventListener(MouseEvent.MOUSE_DOWN, image_mouseDownHandler);
			
			image.startDrag(false, new Rectangle(0, 0, surface.elementWidth - image.elementWidth, surface.elementHeight - image.elementHeight));
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
			image.stage.removeEventListener(MouseEvent.MOUSE_UP, image_mouseUpHandler);
			
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
		 * @private	stage_keyboardDownHandler
		 * @param	e:KeyboardEvent		The Event passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered when user presses a key on the keyboard.
		 * Switches boolean flag if user presses the SHIFT key.
		 */
		protected function stage_keyboardDownHandler(e:KeyboardEvent):void
		{
			image.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			image.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyboardUpHandler);
			
			if (e.shiftKey) {
				_shiftKeyPressed = true;
			}
		}
		
		/**
		 * @private	stage_keyboardUpHandler
		 * @param	e:KeyboardEvent		The Event passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered when user presses a key on the keyboard.
		 * Switches boolean flag if user releases the SHIFT key.
		 */
		protected function stage_keyboardUpHandler(e:KeyboardEvent):void
		{
			image.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			image.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyboardUpHandler);
			
			_shiftKeyPressed = false;
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