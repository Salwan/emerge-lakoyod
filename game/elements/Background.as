package game.elements 
{
	import cmg.MovieClipEx;
	import cmg.Utils;
	import cmg.World;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class Background extends MovieClipEx
	{
		private var sprBG:Sprite;
		private var uColor1:uint;
		private var uColor2:uint;
		private var uColor3:uint;
		private var nRectCount:Number;
		
		public function Background(rect_count:Number = 10, start_color:uint = 0x808080, middle_color:uint = 0x404040, end_color:uint = 0x202020) 
		{
			uColor1 = start_color;
			uColor2 = middle_color;
			uColor3 = end_color;
			nRectCount = rect_count;
		}
	
		override protected function onAdded():void 
		{
			sprBG = new Sprite();
			var rw:Number = World.stageHeight / nRectCount;
			for (var i:Number = 0; i < nRectCount; i+=1.0)
			{			
				var c:uint;
				if (i < nRectCount / 2)
				{
					c = Utils.colorLerp(uColor1, uColor2, Utils.cap((i / nRectCount) * 2, 1.0, 0.0));
				}
				else
				{
					c = Utils.colorLerp(uColor2, uColor3, Utils.cap(((i / nRectCount) - 0.5) * 2, 1.0, 0.0));
				}
				sprBG.graphics.beginFill(c);
				sprBG.graphics.drawRect(0, i * rw, World.stageWidth, rw);
				sprBG.graphics.endFill();
			}
			
			addChild(sprBG);
		}
		
	}

}