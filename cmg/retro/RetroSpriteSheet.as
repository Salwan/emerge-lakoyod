package cmg.retro 
{
	import cmg.collections.Map;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class RetroSpriteSheet 
	{
		protected var mBitmap:BitmapData = null;
		protected var mSprites:Map = null;
		protected var mBitmapMap:Map = null;
		protected var mSpritesByNumber:Vector.<String> = null;
		
		public function RetroSpriteSheet(bitmap:BitmapData) 
		{
			mBitmap = bitmap;
			mSprites = new Map();
			mBitmapMap = new Map();
			mSpritesByNumber = new Vector.<String>();
		}
		
		public function defineSprite(sprite_name:String, x:Number, y:Number, width:Number, height:Number):void
		{
			mSprites.add(sprite_name, new Rectangle(x, y, width, height));
			mSpritesByNumber.push(sprite_name);
			createBitmap(sprite_name);
		}
		
		public function defineSpriteSheet(sprite_count:int, sprite_width:int, sprite_height:int, sprite_prefix:String):void
		{
			var count:int = 0;
			var sx:int = mBitmap.width / sprite_width;
			var sy:int = mBitmap.height / sprite_height;
			for (var j:int = 0; j < sy; ++j)
			{
				for (var i:int = 0; i < sx; ++i)
				{
					defineSprite(sprite_prefix + count.toString(), 
								Number(i * sprite_width), Number(j * sprite_height), 
								Number(sprite_width), Number(sprite_height));
					
					count++;
					if (count >= sprite_count)
					{
						return;
					}
				}
			}
		}
		
		public function getSprite(sprite_name:String):BitmapData
		{
			if (!mSprites.hasKey(sprite_name))
			{
				return null;
			}
			return mBitmapMap.itemFor(sprite_name);
		}
		
		public function getSpriteByNumber(sprite_number:int):BitmapData
		{
			return getSprite(mSpritesByNumber[sprite_number]);
		}
		
		public function getSpriteName(sprite_number:int):String
		{
			return mSpritesByNumber[sprite_number];
		}
		
		public function createNewBitmap(sprite_name:String, position:Point = null):Bitmap
		{
			if (!mSprites.hasKey(sprite_name))
			{
				return null;
			}
			var bmp:Bitmap = new Bitmap(mBitmapMap.itemFor(sprite_name));
			if (position)
			{
				bmp.x = position.x;
				bmp.y = position.y;
			}
			return bmp;
		}
		
		protected function createBitmap(sprite_name:String):void
		{
			var rect:Rectangle = mSprites.itemFor(sprite_name);
			var bmp:BitmapData = new BitmapData(rect.width, rect.height);
			bmp.copyPixels(mBitmap, rect, new Point());
			mBitmapMap.add(sprite_name, bmp);
		}
		
		public function get spriteCount():int
		{
			return mSpritesByNumber.length;
		}
		
	}

}