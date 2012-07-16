package game.effects 
{
	import cmg.MovieClipEx;
	import cmg.tweener.Tweener;
	import cmg.World;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class LighteningMask extends MovieClipEx
	{
		private var sprMask:Sprite;
		
		public function LighteningMask() 
		{
			
		}
		
		override protected function onAdded():void 
		{
			sprMask = new Sprite();
			sprMask.graphics.beginFill(0xffffff);
			sprMask.graphics.drawRect(0, 0, World.stageWidth, World.stageHeight);
			sprMask.graphics.endFill();
			addChild(sprMask);
		}
		
		public function strike(intensity:Number = 0.5, duration:Number = 0.1):void
		{
			Tweener.removeTweens(this);
			var a:Number = alpha;
			Tweener.addTween(this, { time:duration / 2, alpha:intensity, transition:"linear" } );
			Tweener.addTween(this, { delay:duration / 2, time:duration / 2, alpha:a, transition:"linear" } );
		}
		
	}

}