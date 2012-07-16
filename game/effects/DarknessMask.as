package game.effects 
{
	import cmg.MovieClipEx;
	import cmg.World;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class DarknessMask extends MovieClipEx
	{
		private var sprMask:Sprite;
		
		public function DarknessMask() 
		{
			
		}
		
		override protected function onAdded():void 
		{
			sprMask = new Sprite();
			sprMask.graphics.beginFill(0x000000);
			sprMask.graphics.drawRect(0, 0, World.stageWidth, World.stageHeight);
			sprMask.graphics.endFill();
			addChild(sprMask);
		}
		
	}

}