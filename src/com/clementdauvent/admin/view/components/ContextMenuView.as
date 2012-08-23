package com.clementdauvent.admin.view.components
{
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class ContextMenuView
	{
		protected var _menu:ContextMenu;
		protected var _canPromoteAsFirstImage:Boolean;
		protected var _canPublish:Boolean;
		protected var _promoteFirstItem:ContextMenuItem;
		protected var _publishItem:ContextMenuItem;
		
		
		public function ContextMenuView()
		{
			_menu = new ContextMenu();
			_menu.hideBuiltInItems();
			
			_promoteFirstItem = new ContextMenuItem("Placer en Image d'Ouverture");
			_publishItem = new ContextMenuItem("Publier");
			
			_menu.customItems.push(_promoteFirstItem, _publishItem);
			
			canPromoteAsFirstImage = false;
			canPublish = false;
		}
		
		public function get menu():ContextMenu
		{
			return _menu;
		}
		
		public function get promoteFirstBtn():ContextMenuItem
		{
			return _promoteFirstItem;	
		}
		
		public function get publishBtn():ContextMenuItem
		{
			return _publishItem;
		}
		
		public function get canPromoteAsFirstImage():Boolean
		{
			return _canPromoteAsFirstImage;
		}
		
		public function get canPublish():Boolean
		{
			return _canPublish;
		}
		
		public function set canPromoteAsFirstImage(value:Boolean):void
		{
			_canPromoteAsFirstImage = value;
			_promoteFirstItem.enabled = value;
		}
		
		public function set canPublish(value:Boolean):void
		{
			_canPublish = value;
			_publishItem.enabled = value;
		}
	}
}