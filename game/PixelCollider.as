package game 
{
	import cmg.MovieClipEx;
	import cmg.Utils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import cmg.World;
	/**
	 * ...
	 * @author ...
	 */
	public class PixelCollider extends MovieClipEx
	{
		protected var bmpCollision:Bitmap;
		
		public function PixelCollider() 
		{
			
		}
		
		public function collide(cx:int, cy:int):Boolean
		{
			if (bmpCollision)
			{
				if (bmpCollision.hitTestPoint(cx, cy))
				{
					var p:Point = bmpCollision.globalToLocal(new Point(cx, cy));
					var bd:BitmapData = bmpCollision.bitmapData;
					var c:uint = bd.getPixel32(p.x, p.y);
					var a:uint = Utils.ALPHA(c);
					var RGB:uint = Utils.RGB(c);
					if (a > 128)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function roughRay(rx:int):int
		{
			var ss:int = 0;
			var se:int = World.stageHeight;
			var a:Array = _roughRay(rx, ss, se, 50);
			ss = a[0];
			se = a[1];
			a = _roughRay(rx, ss, se, 10);
			ss = a[0];
			se = a[1];
			a = _roughRay(rx, ss, se, 1);
			ss = a[0];
			se = a[1];
			
			return se;
		}
		
		private function _roughRay(rx:int, start:int, end:int, step:int):Array
		{
			for (var i:int = start; i < end; i += step)
			{
				if (collide(rx, i))
				{
					end = i;
					break;
				}
				start = i;
			}
			return [start, end];
		}
	}

}