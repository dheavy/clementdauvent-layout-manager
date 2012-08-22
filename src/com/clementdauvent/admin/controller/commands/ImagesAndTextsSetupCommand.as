package com.clementdauvent.admin.controller.commands
{
	import com.clementdauvent.admin.model.ApplicationModel;
	import com.clementdauvent.admin.model.vo.ImageVO;
	import com.clementdauvent.admin.model.vo.TextVO;
	import com.clementdauvent.admin.view.components.Image;
	import com.clementdauvent.admin.view.components.MainView;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command in charge of setting up images and texts on the MainView.</p>
	 */
	public class ImagesAndTextsSetupCommand extends Command
	{
		/*	@public	OFFSET:Number	The offset between images, texts... when added on the display list. */
		public static const OFFSET	:Number = 200;
		
		/* 	@public	ROWS:Number		The number of rows to allow when roughly laying out the elements added. */
		public static const ROWS	:Number = 3;
		
		/*	@public	model:ApplicationModel	The injected singleton instance of the main application model, where the data is contained for building these elements. */
		[Inject]
		public var model:ApplicationModel;
		
		/*	@public	view:MainView			The injected singleton instance of the MainView, where the elements should appear. */
		[Inject]
		public var view:MainView;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes the command, effectively building and adding to the MainView the set of Image and Text instances constitutive of this application.
		 */
		override public function execute():void
		{
			var images:Vector.<ImageVO> = model.data.images;
			var texts:Vector.<TextVO> = model.data.texts;
			
			var i:int = 0, j:int = 0;
			var length:int = images.length;
			
			for (i; i < length; i++) {
				var vo:ImageVO = images[i];
				var img:Image = new Image(i, vo.src, vo.originalWidth, vo.originalHeight);
				
				if (j > ImagesAndTextsSetupCommand.ROWS) j = 0;
				img.x = j * ImagesAndTextsSetupCommand.OFFSET;
				img.y = i * ImagesAndTextsSetupCommand.OFFSET;
				j++;
				
				view.addElement(img);
			}
		}
	}
}