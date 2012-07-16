package game.effects 
{
	import cmg.MovieClipEx;
	import cmg.tweener.Tweener;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author ...
	 */
	public class CircleBuilt extends MovieClipEx
	{
		private var bmp:Bitmap;
		
		public function CircleBuilt(px:int, py:int) 
		{
			bmp = new Embed.Bitmap_ActionCircle_Built();
			bmp.x = -bmp.width / 2;
			bmp.y = -bmp.height / 2;
			bmp.blendMode = BlendMode.ADD;
			addChild(bmp);
			x = px;
			y = py;
		}
		
		override protected function onAdded():void 
		{
			alpha = 0;
			scaleX = 0;
			scaleY = 0;
			
			Tweener.addTween(this, { time:1, alpha:1, scaleX:1, scaleY:1, transition:"easeOut", onComplete:kill } );
		}
		
	}

}