package game.elements 
{
	import cmg.MovieClipEx;
	import cmg.World;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class Cloud extends MovieClipEx
	{
		private var sprContainer:Sprite;
		private var bmpCloud:Bitmap;
		private var sprMask:Sprite;
		private var uMaskColor:uint;
		
		public function Cloud(mask_color:uint = 0xffffff) 
		{
			uMaskColor = mask_color;
		}

		override protected function onAdded():void 
		{
			sprContainer = new Sprite();
			
			bmpCloud = new Embed.Bitmap_Cloud();
			bmpCloud.x = -200;
			bmpCloud.y = 0;
			
			sprMask = new Sprite();
			sprMask.graphics.beginFill(uMaskColor);
			sprMask.graphics.drawRect(0, 0, World.stageWidth, 200);
			sprMask.graphics.endFill();
			
			sprContainer.addChild(bmpCloud);
			sprContainer.addChild(sprMask);
			
			
			addChild(sprContainer);
		}
	}

}