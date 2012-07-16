package cmg 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.BreakOpportunity;
	/**
	 * Numorous utilities.
	 * @author ZenithSal
	 */
	public class Utils
	{
		public static const toDeg:Number = 57.2957;
		public static const toRad:Number = 0.01745;
		
		public function Utils() 
		{
			
		}
		
		public static function lerp(a:Number, b:Number, alpha:Number):Number
		{
			return a + ((b - a) * alpha)
		}
		
		public static function saturate(n:Number):Number
		{
			return n < 0.5? 0.0 : 1.0;
		}
		
		public static function cap(n:Number, max:Number, min:Number):Number
		{
			return (n > max? max : (n < min? min : n));
		}
		
		/**
		 * random int in range [min, max]
		 */
		public static function randomInt(min:int, max:int):int
		{
			return int(Math.floor((Math.random() * (Math.abs(max - min) + 1)) + min));
		}
		
		/**
		 * Random Number in range [min, max]
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function randomNumber(min:Number, max:Number):Number
		{
			return (Math.random() * Math.abs(max - min)) + min;
		}
		
		public static function randomDir2D():Vector2D
		{
			var x:Number = randomNumber( -1, 1);
			var y:Number = randomNumber( -1, 1);
			return (new Vector2D(x, y)).normalize();
		}
		
		public static function randomPointInRect(rect:Rectangle):Point
		{
			return new Point(randomNumber(rect.left, rect.right), randomNumber(rect.top, rect.bottom));
		}
		
		// A Boolean dice
		public static function chance(percent:Number = 0.5, total:Number = 1.0):Boolean
		{
			var dice:Number = Math.random() * total;
			var h:Number = Math.random();
			if (h >= 0.66) // High
			{
				if (dice >= (total - percent))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else if(h >= 0.33) // Low
			{
				if (dice <= percent)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else // Medium
			{
				var n:Number = (total / 2) - (percent / 2);
				if (dice >= n && dice <= n + percent)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		/*
		 * Extracts the alpha only from a 32-bit color
		 */
		public static function ALPHA(color:uint):uint
		{			
			return cap(int(((color & 0xff000000) >> 24) & 0x000000ff), 255, 0);
		}
		
		/*
		 * Eliminates the alpha value from a 32-bit color
		 */
		public static function RGB(color:uint):uint
		{
			return uint(color & 0x00ffffff);
		}
		
		/*
		 * Adds difference to color components.
		 */
		public static function colorBrightenRGB(color:uint, difference:uint):uint
		{
			var r:uint = cap(((color & 0x00ff0000) >> 16) + difference, 255, 0);
			var g:uint = cap(((color & 0x0000ff00) >> 8) + difference, 255, 0);
			var b:uint = cap(((color & 0x000000ff)) + difference, 255, 0);
			return b + (g << 8) + (r << 16);
		}
		
		/*
		 * Subtracts difference from color components.
		 */
		public static function colorDarkenRGB(color:uint, difference:int):uint
		{
			var r:int = cap(int((color & 0x00ff0000) >> 16) - difference, 255, 0);
			var g:int = cap(int((color & 0x0000ff00) >> 8) - difference, 255, 0);
			var b:int = cap(int(color & 0x000000ff) - difference, 255, 0);			
			return b + (g << 8) + (r << 16);
		}
		
		/*
		 * Linearl interpolation between two uint colors
		 */
		public static function colorLerp(a:uint, b:uint, alpha:Number):uint
		{
			var ar:uint = cap(((a & 0x00ff0000) >> 16), 255, 0);
			var ag:uint = cap(((a & 0x0000ff00) >> 8), 255, 0);
			var ab:uint = cap(((a & 0x000000ff)), 255, 0);
			
			var br:uint = cap(((b & 0x00ff0000) >> 16), 255, 0);
			var bg:uint = cap(((b & 0x0000ff00) >> 8), 255, 0);
			var bb:uint = cap(((b & 0x000000ff)), 255, 0);
			
			return uint(lerp(ab, bb, alpha)) + (uint(lerp(ag, bg, alpha)) << 8) + (uint(lerp(ar, br, alpha)) << 16);
		}
		
		/*
		 * Creates a new bitmap by cloning the bitmapData from another bitmap.
		 */
		public static function cloneBitmap(bitmap:Bitmap):Bitmap
		{
			return new Bitmap(bitmap.bitmapData.clone());
		}
		
		/*
		 * Checks for rectangle overlap between two display objects in the same space.
		 */
		public static function checkOverlap(do1:DisplayObject, do2:DisplayObject):Boolean
		{			
			if (do1.x > do2.x + do2.width || do1.x + do1.width < do2.x || 
				do1.y > do2.y + do2.height || do1.y + do1.height < do2.y)
			{
				return false;
			}
			else 
			{
				return true;
			}				
		}
		
		public static function spawnInRectangle(object_class:Class, spawn_rectangle:Rectangle):Object
		{
			var x:Number = randomNumber(spawn_rectangle.left, spawn_rectangle.right);
			var y:Number = randomNumber(spawn_rectangle.top, spawn_rectangle.bottom);
			var obj:Object = new object_class();
			obj.x = x;
			obj.y = y;
			//trace("spawn in :" + x.toString() + " , " + y.toString());
			return obj;
		}
		
	}

}