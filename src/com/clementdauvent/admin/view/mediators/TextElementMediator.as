package com.clementdauvent.admin.view.mediators
{
	import com.clementdauvent.admin.controller.events.ElementEvent;
	import com.clementdauvent.admin.view.components.MainView;
	import com.clementdauvent.admin.view.components.TextElement;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class TextElementMediator extends Mediator
	{
		[Inject]
		public var txt:TextElement;
		
		[Inject]
		public var surface:MainView;
		
		protected var _shiftKeyPressed:Boolean;
		
		override public function onRegister():void
		{
			_shiftKeyPressed = false;
			txt.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		protected function initView(e:Event):void
		{
			txt.removeEventListener(Event.ADDED_TO_STAGE, initView);
			
			txt.addEventListener(MouseEvent.MOUSE_DOWN, txt_mouseDownHandler);
			txt.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			
			eventDispatcher.addEventListener(MouseEvent.CLICK, eventBus_clickHandler);
			eventDispatcher.addEventListener(MouseEvent.MOUSE_WHEEL, eventBus_mouseWheelHandler);
		}
		
		protected function txt_mouseDownHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			if (_shiftKeyPressed) {
				trace("[INFO] Placing txt " + txt.id + " on top of the stack");
				eventDispatcher.dispatchEvent(new ElementEvent(txt, ElementEvent.PLACE_ON_TOP));
				return;
			}
			
			txt.addEventListener(MouseEvent.MOUSE_UP, txt_mouseUpHandler);
			txt.stage.addEventListener(MouseEvent.MOUSE_UP, txt_mouseUpHandler);
			txt.addEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			txt.removeEventListener(MouseEvent.MOUSE_DOWN, txt_mouseDownHandler);
			
			txt.startDrag(false, new Rectangle(0, 0, surface.elementWidth - txt.elementWidth, surface.elementHeight - txt.elementHeight));
		}
		
		protected function stage_keyboardDownHandler(e:KeyboardEvent):void
		{
			txt.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			txt.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyboardUpHandler);
			
			if (e.shiftKey) {
				_shiftKeyPressed = true;
			}
		}
		
		protected function stage_keyboardUpHandler(e:KeyboardEvent):void
		{
			txt.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyboardDownHandler);
			txt.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyboardUpHandler);
			
			_shiftKeyPressed = false;
		}
		
		protected function eventBus_clickHandler(e:MouseEvent):void
		{
			if (e.target is Stage) {
				txt.stopDrag();
			}
		}
		
		protected function eventBus_mouseWheelHandler(e:MouseEvent):void
		{
			txt.stopDrag();
		}
		
		protected function txt_mouseUpHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			
			txt.addEventListener(MouseEvent.MOUSE_DOWN, txt_mouseDownHandler);
			txt.removeEventListener(Event.ENTER_FRAME, monitorMouseInBounds);
			txt.removeEventListener(MouseEvent.MOUSE_UP, txt_mouseUpHandler);
			txt.stage.removeEventListener(MouseEvent.MOUSE_UP, txt_mouseUpHandler);
			
			txt.stopDrag();
		}
		
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