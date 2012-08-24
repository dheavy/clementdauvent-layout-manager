package com.clementdauvent.admin.view.components
{
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * <p>View used to build a custom context menu on MainView.</p>
	 */
	public class ContextMenuView
	{
		/**
		 * @private	A ContextMenu to replace the default one.
		 */
		protected var _menu:ContextMenu;
		
		/**
		 * @private	Whether or not the "Promote..." option is enabled.
		 */
		protected var _canPromoteAsFirstElement:Boolean;
		
		/**
		 * @private	Whether or not the "Publish..." option is enabled.
		 */
		protected var _canPublish:Boolean;
		
		/**
		 * @private	The "Promote..." option button.
		 */
		protected var _promoteFirstItem:ContextMenuItem;
		
		/**
		 * @private	The "Publish..." option button.
		 */
		protected var _publishItem:ContextMenuItem;
		
		/**
		 * @public	ContextMenuView
		 * @return	this
		 * 
		 * Creates an instance of ContextMenuView, used to build a custom context menu on MainView.
		 */
		public function ContextMenuView()
		{
			_menu = new ContextMenu();
			_menu.hideBuiltInItems();
			
			_promoteFirstItem = new ContextMenuItem("Placer comme élément en ouverture du site");
			_publishItem = new ContextMenuItem("Publier");
			
			_menu.customItems.push(_promoteFirstItem, _publishItem);
			
			canPromoteAsFirstElement = false;
			canPublish = false;
		}
		
		/**
		 * @public	menu
		 * @return	An reference of the custom ContextMenu
		 */
		public function get menu():ContextMenu
		{
			return _menu;
		}
		
		/**
		 * @public	promoteFirstBtn
		 * @return	A reference to the "Promote..." button.
		 */
		public function get promoteFirstBtn():ContextMenuItem
		{
			return _promoteFirstItem;	
		}
		
		/**
		 * @public	publishBtn
		 * @return	A reference to the "Publish..." button.
		 */
		public function get publishBtn():ContextMenuItem
		{
			return _publishItem;
		}
		
		/**
		 * @public	canPromoteAsFirstElement
		 * @return	True if "Promote..." is enabled, false otherwise.
		 */
		public function get canPromoteAsFirstElement():Boolean
		{
			return _canPromoteAsFirstElement;
		}
		
		/**
		 * @public	canPublish
		 * @return	True if "Publish..." is enabled, false otherwise.
		 */
		public function get canPublish():Boolean
		{
			return _canPublish;
		}
		
		/**
		 * @public	canPromoteAsFirstElement
		 * @return	void
		 * 
		 * Sets whether the "Promote..." feature true or false, and enables/disables the button accordingly.
		 */
		public function set canPromoteAsFirstElement(value:Boolean):void
		{
			_canPromoteAsFirstElement = value;
			_promoteFirstItem.enabled = value;
		}
		
		/**
		 * @public	canPublish
		 * @return	void
		 * 
		 * Sets whether the "Publish..." feature true or false, and enables/disables the button accordingly.
		 */
		public function set canPublish(value:Boolean):void
		{
			_canPublish = value;
			_publishItem.enabled = value;
		}
	}
}