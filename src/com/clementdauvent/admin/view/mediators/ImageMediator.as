package com.clementdauvent.admin.view.mediators
{
	import com.clementdauvent.admin.controller.events.ElementEvent;
	import com.clementdauvent.admin.view.components.Image;
	import com.clementdauvent.admin.view.components.MainView;
	import com.clementdauvent.admin.utils.Logger;
	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>Mediator for img instance.</p>
	 */
	public class ImageMediator extends Mediator
	{
		/**
		 * The injected img instance this mediator mediates. 
		 */		
		[Inject]
		public var img:Image;
		
		/**
		 * An injected dependency of the singleton instance of the MainView, parent for instances of img. 
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
			img.addEventListener(Event.ADDED_TO_STAGE, initView);
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
			img.removeEventListener(Event.ADDED_TO_STAGE, initView);

			img.addEventListener(MouseEvent.MOUSE_DOWN, img_mouseDownHandler);
			img.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			
			eventDispatcher.addEventListener(MouseEvent.CLICK, eventBus_clickHandler);
			eventDispatcher.addEventListener(MouseEvent.MOUSE_WHEEL, eventBus_mouseWheelHandler);
		}
		
		/**
		 * @private	img_mouseDownHandler
		 * @param	e:MouseEvent	The MouseEvent passed during the process
		 * @return	void
		 * 
		 * Event handler triggered when user's mouse button is down on the mediated img.
		 * Enables dragging, or place img on top of the stack if alt-key is pressed.
		 */
		protected function img_mouseDownHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			if (_shiftKeyPressed) {
				Logger.print("[INFO] Placing img " + img.id + " on top of the stack");
				eventDispatcher.dispatchEvent(new ElementEvent(img, ElementEvent.PLACE_ON_TOP));
				return;
			}
			
			img.addEventListener(MouseEvent.MOUSE_UP, img_mouseUpHandler);
			img.stage.addEventListener(MouseEvent.MOUSE_UP, img_mouseUpHandler);
			img.addEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			img.removeEventListener(MouseEvent.MOUSE_DOWN, img_mouseDownHandler);
			
			img.startDrag(false, new Rectangle(0, 0, surface.elementWidth - img.elementWidth, surface.elementHeight - img.elementHeight));
		}
		
		/**
		 * @private	img_mouseUpHandler
		 * @param	e:MouseEvent	The MouseEvent passed during the process
		 * @return	void
		 * 
		 * Event handler triggered when user's mouse button is up/off the mediated img.
		 * Disables dragging.
		 */
		protected function img_mouseUpHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			img.addEventListener(MouseEvent.MOUSE_DOWN, img_mouseDownHandler);
			img.removeEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			img.removeEventListener(MouseEvent.MOUSE_UP, img_mouseUpHandler);
			img.stage.removeEventListener(MouseEvent.MOUSE_UP, img_mouseUpHandler);
			
			img.stopDrag();
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
				img.stopDrag();
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
			img.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			img.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyboardUpHandler);
			
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
			img.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			img.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyboardUpHandler);
			
			_shiftKeyPressed = false;
		}
		
		/**
		 * @private	eventBus_clickHandler
		 * @param	e:Event		The Event passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered when user clicks on the stage but NOT on the img.
		 * Stops dragging if it happens.
		 */
		protected function eventBus_clickHandler(e:MouseEvent):void
		{
			if (e.target is Stage) {
				img.stopDrag();
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
			img.stopDrag();
		}
	}
}