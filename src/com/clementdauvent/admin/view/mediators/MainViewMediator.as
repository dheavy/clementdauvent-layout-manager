package com.clementdauvent.admin.view.mediators
{
	import com.clementdauvent.admin.controller.events.ImageEvent;
	import com.clementdauvent.admin.view.components.ContextMenuView;
	import com.clementdauvent.admin.view.components.Image;
	import com.clementdauvent.admin.view.components.MainView;
	import com.greensock.TweenMax;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Context;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>Mediator dealing with the MainView view component.</p>
	 */
	public class MainViewMediator extends Mediator
	{
		/**
		 * The injected MainView instance mediated by this Mediator. 
		 */
		[Inject]
		public var view:MainView;
		
		/**
		 * The injected ContextMenuView instance holding the context menu attached to the MainView.
		 */
		[Inject]
		public var contextMenu:ContextMenuView;
		
		/**
		 * @private	Whether or not the user is currently trying to move around the gridded view.
		 */
		protected var _isDragged:Boolean = false;
		
		/**
		 * @private	Whether or not the user is currently trying to zoom in and out of the gridded view.
		 */
		protected var _isZooming:Boolean = false;
		
		/**
		 * @private	A calculated horizontal offset between the click point and the top-left corner of the view.
		 */
		protected var _offsetX:Number = 0;
		
		/**
		 * @private	A calculated vertical offset between the click point and the top-left corner of the view.
		 */
		protected var _offsetY:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _prevX:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _prevY:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _vx:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _vy:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _friction:Number = .7;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Invoked when this mediator is registered. Add a listener reacting to addition of the view to the display list, launching setup around it.
		 */
		override public function onRegister():void
		{
			view.addEventListener(Event.ADDED_TO_STAGE, initView);
			TweenPlugin.activate([ TransformAroundPointPlugin ]);
		}
		
		/**
		 * @public	viewAll
		 * @return	void
		 * 
		 * Sets the zoom level in a way that it displays fully, covering up the most possible Stage real-estate as possible.
		 */
		public function viewAll():void
		{
			var ratio:Number = view.stage.stageHeight / view.height;
			view.scaleX = view.scaleY = ratio;
		}
		
		/**
		 * @private	initView
		 * @return	void
		 * 
		 * Invoked when the mediated view is added to the display list: starts configuring it.
		 */
		protected function initView(e:Event):void
		{
			view.removeEventListener(Event.ADDED_TO_STAGE, initView);
			view.addEventListener(Event.ENTER_FRAME, monitorDrag);
			view.addEventListener(MouseEvent.MOUSE_DOWN, view_mouseDownHandler);
			view.addEventListener(MouseEvent.MOUSE_UP, view_mouseReleaseHandler);
			view.addEventListener(MouseEvent.MOUSE_OUT, view_mouseReleaseHandler);
			
			eventDispatcher.addEventListener(MouseEvent.MOUSE_WHEEL, eventBus_mouseWheelHandler);
			eventDispatcher.addEventListener(ImageEvent.PLACE_ON_TOP, eventBus_imagePlaceOnTopHandler);
			
			view.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, monitorRightClick);
			
			contextMenu.promoteFirstBtn.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenu_promoteFirstHandler);
			contextMenu.publishBtn.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenu_publishHandler);
			
			trace("[INFO] MainViewMediator finished configuring the MainView instance");
			
			viewAll();
		}
		
		/**
		 * @private	monitorDrag
		 * @return	void
		 * 
		 * Monitors and applies behaviour on the view when it is dragged or released with inertia.
		 */
		protected function monitorDrag(e:Event):void
		{
			if (_isZooming) return;
			
			if (_isDragged) {
				_vx = view.stage.mouseX - _prevX;
				_vy = view.stage.mouseY - _prevY;
				_prevX = view.stage.mouseX;
				_prevY = view.stage.mouseY;
				view.x = view.stage.mouseX - _offsetX;
				view.y = view.stage.mouseY - _offsetY;
			} else {
				_vx *= _friction;
				_vy *= _friction;
				view.x += _vx;
				view.y += _vy;
			}
		}
		
		protected function monitorRightClick(e:ContextMenuEvent):void
		{
			var mousePos:Point = new Point(view.mouseX, view.mouseY);
			var img:Image = view.returnImageUnderPoint(mousePos);
			
			if (img && !img.isFirst) {
				contextMenu.canPromoteAsFirstImage = true;
			} else {
				contextMenu.canPromoteAsFirstImage = false;
			}
		}
		
		/**
		 * @private	view_mouseDownHandler
		 * @return	void
		 * 
		 * Event handler triggered when user holds down mouse button on the view.
		 * Starts dragging it.
		 */
		protected function view_mouseDownHandler(e:MouseEvent):void
		{
			_offsetX = view.stage.mouseX - view.x;
			_offsetY = view.stage.mouseY - view.y;
			_isDragged = true;
		}
		
		/**
		 * @private	view_mouseReleaseHandler
		 * @return	void
		 * 
		 * Event handler triggered when user releases the mouse button.
		 * Stops dragging the view.
		 */
		protected function view_mouseReleaseHandler(e:MouseEvent):void
		{
			_isDragged = false;	
		}
		
		/**
		 * @private	eventBus_mouseWheelHandler
		 * @return	void
		 * 
		 * Event handler triggered when user scrolls mouse wheel.
		 * Calculate and apply zoom (actually rescale) on the view based on scroll values.
		 */
		protected function eventBus_mouseWheelHandler(e:MouseEvent):void
		{
			if (_isZooming) return;
			
			_isZooming = true;
			
			var amount:Number = e.delta / 100;
			
			var sX:Number = view.scaleX + amount;
			var sY:Number = view.scaleY + amount;
			
			if (sX <= .05) {
				sX = sY = .05;
			}
			
			TweenMax.to(view, 0, { transformAroundPoint: { point: new Point(view.stage.mouseX, view.stage.mouseY), scaleX: sX, scaleY: sY }, 
				onComplete: function():void { 
					_isZooming = false;
				} 
			});
		}
		
		protected function eventBus_imagePlaceOnTopHandler(e:ImageEvent):void
		{
			view.setImageOnTop(e.img);
		}
		
		protected function contextMenu_promoteFirstHandler(e:ContextMenuEvent):void
		{
			var img:Image = view.returnImageUnderPoint(new Point(view.mouseX, view.mouseY)) as Image;
			view.setAsFirstImage(img);
			trace("[INFO] Promoted " + img.toString() + " as First Image");
		}
		
		protected function contextMenu_publishHandler(e:ContextMenuEvent):void
		{
			
		}
				
	}
}