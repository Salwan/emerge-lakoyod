package game.hud 
{
	import cmg.MovieClipEx;
	import cmg.tweener.Tweener;
	import cmg.World;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class Circle extends MovieClipEx
	{
		private var sprContainer:Sprite;
		private var bmpCircle:Bitmap;
		private var sprColor:Sprite;
		private var uColor:uint;
		
		public function Circle(multiply_color:uint = 0xffffff) 
		{
			uColor = multiply_color;
		}
		
		override protected function onAdded():void 
		{
			sprContainer = new Sprite();
			
			bmpCircle = new Embed.Bitmap_Circle();
			bmpCircle.x = -bmpCircle.width / 2;
			bmpCircle.y = -bmpCircle.height / 2;
			bmpCircle.blendMode = BlendMode.ADD;
			sprContainer.addChild(bmpCircle);
			
			if (uColor < 0xffffff)
			{
				sprColor = new Sprite();
				sprColor.graphics.beginFill(uColor);
				sprColor.graphics.drawRect(0, 0, bmpCircle.width, bmpCircle.height);
				sprColor.graphics.endFill();
				sprColor.blendMode = BlendMode.MULTIPLY;
				sprColor.x = -sprColor.width / 2;
				sprColor.y = -sprColor.height / 2;
				sprContainer.addChild(sprColor);
			}
			
			scaleX = 0.0;
			scaleY = 0.0;
			alpha = 0.75;			
			addChild(sprContainer);
			
			Tweener.addTween(this, { time:0.5, scaleX: 0.7, scaleY: 0.7, alpha:0, transition:"linear", onComplete:kill } );
		}
		
	}

}