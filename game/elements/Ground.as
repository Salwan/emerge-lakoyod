package game.elements 
{
	import cmg.MovieClipEx;
	import cmg.tweener.Tweener;
	import cmg.World;
	import embed.Embed;
	import flash.display.Bitmap;
	import game.PixelCollider;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class Ground extends PixelCollider
	{
		private var bmpGround:Bitmap;
		private var bmpGreenGround:Bitmap;
		
		public function Ground() 
		{
			name = "ground";
		}
		
		override protected function onAdded():void 
		{
			bmpGreenGround = new Embed.Bitmap_GreenGround();
			bmpGreenGround.x = 0;
			bmpGreenGround.y = World.stageHeight - bmpGreenGround.height;
			addChild(bmpGreenGround);
			bmpGreenGround.alpha 0.0;
			bmpGreenGround.visible = false;
			
			bmpGround = new Embed.Bitmap_Ground();
			bmpGround.y = World.stageHeight - bmpGround.height;
			bmpGround.x -= 50;
			addChild(bmpGround);
			bmpCollision = bmpGround;
			
		}
		
		public function goGreen():void
		{
			bmpGreenGround.alpha = 1.0;
			bmpGreenGround.visible = true;
			
			Tweener.addTween(bmpGround, { time:2, alpha:0, transition:"linear", onComplete:_remove } );
		}
		
		private function _remove():void
		{
			removeChild(bmpGround);
		}
		
	}

}