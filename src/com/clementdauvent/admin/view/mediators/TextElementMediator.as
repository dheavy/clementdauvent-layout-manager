package com.clementdauvent.admin.view.mediators
{
	import com.clementdauvent.admin.controller.events.ElementEvent;
	import com.clementdauvent.admin.view.components.MainView;
	import com.clementdauvent.admin.view.components.TextElement;
	import com.clementdauvent.admin.utils.Logger;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>Mediator for TextElement instances.</p>
	 */
	public class TextElementMediator extends Mediator
	{
		/**
		 * The injected TextElement to mediate.
		 */
		[Inject]
		public var txt:TextElement;
		
		/**
		 * The injected singleton reference of the MainView where the TextElement is stored.
		 */
		[Inject]
		public var surface:MainView;
		
		/**
		 * @private	Whether or not the SHIFT key is being pressed by the user.
		 */
		protected var _shiftKeyPressed:Boolean;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Register listener for when TextElement is added to stage, in order to initialize its behaviours.
		 */
		override public function onRegister():void
		{
			_shiftKeyPressed = false;
			txt.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		/**
		 * @private	initView
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Initializes the behaviour of the view.
		 */
		protected function initView(e:Event):void
		{
			txt.removeEventListener(Event.ADDED_TO_STAGE, initView);
			
			txt.addEventListener(MouseEvent.MOUSE_DOWN, txt_mouseDownHandler);
			txt.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			
			eventDispatcher.addEventListener(MouseEvent.CLICK, eventBus_clickHandler);
			eventDispatcher.addEventListener(MouseEvent.MOUSE_WHEEL, eventBus_mouseWheelHandler);
		}
		
		/**
		 * @private	txt_mouseDownHandler
		 * @param	e:MouseEvent	The MouseEvent object passed during the process.
		 * @return	void
		 * 
		 * Re-stacks the text if SHIFT key is pressed. Enables dragging.
		 */
		protected function txt_mouseDownHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			if (_shiftKeyPressed) {
				Logger.print("[INFO] Placing txt " + txt.id + " on top of the stack");
				eventDispatcher.dispatchEvent(new ElementEvent(txt, ElementEvent.PLACE_ON_TOP));
				return;
			}
			
			txt.addEventListener(MouseEvent.MOUSE_UP, txt_mouseUpHandler);
			txt.stage.addEventListener(MouseEvent.MOUSE_UP, txt_mouseUpHandler);
			txt.addEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			txt.removeEventListener(MouseEvent.MOUSE_DOWN, txt_mouseDownHandler);
			
			txt.startDrag(false, new Rectangle(0, 0, surface.elementWidth - txt.elementWidth, surface.elementHeight - txt.elementHeight));
		}
		
		/**
		 * @private	stage_keyboardDownHandler
		 * @param	e:KeyboardEvent	The KeyboardEvent object passed during the process.
		 * @return	void
		 * 
		 * Sets the SHIFT key press boolean flag to true.
		 */
		protected function stage_keyboardDownHandler(e:KeyboardEvent):void
		{
			txt.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			txt.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyboardUpHandler);
			
			if (e.shiftKey) {
				_shiftKeyPressed = true;
			}
		}
		
		/**
		 * @private	stage_keyboardUpHandler
		 * @param	e:KeyboardEvent	The KeyboardEvent object passed during the process.
		 * @return	void
		 * 
		 * Sets the SHIFT key press boolean flag to false.
		 */
		protected function stage_keyboardUpHandler(e:KeyboardEvent):void
		{
			txt.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			txt.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyboardUpHandler);
			
			_shiftKeyPressed = false;
		}
		
		/**
		 * @private	eventBus_clickHandler
		 * @param	e:MouseEvent	The MouseEvent object passed during the process.
		 * @return	void
		 * 
		 * If mouse button is released anywhere on stage, ensure the TextElement isn't dragged anymore (avoid nasty UX bugs).
		 */
		protected function eventBus_clickHandler(e:MouseEvent):void
		{
			if (e.target is Stage) {
				txt.stopDrag();
			}
		}
		
		/**
		 * @private	eventBus_mouseWheelHandler
		 * @param	e:MouseEvent	The MouseEvent object passed during the process.
		 * @return	void
		 * 
		 * If mouse wheel is used, ensure the TextElement isn't dragged anymore (avoid nasty UX bugs).
		 */
		protected function eventBus_mouseWheelHandler(e:MouseEvent):void
		{
			txt.stopDrag();
		}
		
		/**
		 * @private	txt_mouseUpHandler
		 * @param	e:MouseEvent	The MouseEvent object passed during the process.
		 * @return	void
		 * 
		 * Disables dragging.
		 */
		protected function txt_mouseUpHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			txt.addEventListener(MouseEvent.MOUSE_DOWN, txt_mouseDownHandler);
			txt.removeEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			txt.removeEventListener(MouseEvent.MOUSE_UP, txt_mouseUpHandler);
			txt.stage.removeEventListener(MouseEvent.MOUSE_UP, txt_mouseUpHandler);
			
			txt.stopDrag();
		}
		
		/**
		 * @private	monitorMouseInBounds
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * If mouse cursor leaves bounds of the MainView, disables dragging (avoiding UX bug).
		 */
		protected function monitorMouseInBounds(e:Event):void
		{
			var mouseX:Number = surface.mouseX;
			var mouseY:Number = surface.mouseY;
			if (mouseX < 0 || mouseX > surface.elementWidth || mouseY < 0 || mouseY > surface.elementHeight) {
				txt.stopDrag();
			}
		}
	}
}