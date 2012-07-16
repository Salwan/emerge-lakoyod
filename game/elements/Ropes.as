package game.elements 
{
	import cmg.Clock;
	import cmg.CMGSpriteSheet;
	import cmg.MovieClipEx;
	import cmg.SoundContainer;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import game.GameScene;
	/**
	 * ...
	 * @author ...
	 */
	public class Ropes extends MovieClipEx
	{
		public static const EVENT_ROPE_REMOVED:String = "ropekill";
		
		private var sndRopeCut:SoundContainer;
		private var spriteSheet:CMGSpriteSheet;
		private var sprRope:Sprite;
		private var iPrevFrame:int;
		private var nCutAccum:Number;
		private var nFixAccum:Number;
		private var nCutAmount:Number;
		private var bRemoved:Boolean;
		
		public function Ropes() 
		{
			bRemoved = false;
			sndRopeCut = new SoundContainer(Embed.Sound_RopeSnap);
		}
		
		override protected function onAdded():void 
		{
			nFixAccum = 0.0;
			nCutAccum = 0.0;
			nCutAmount = 0.0;
			bRemoved = false;
			
			var bmp:Bitmap = new Embed.Bitmap_Rope_SpriteSheet();
			spriteSheet = new CMGSpriteSheet(bmp.bitmapData);
			spriteSheet.defineSpriteSheet(8, 390, 118, "rop");
			
			sprRope = new Sprite();
			sprRope.addChild(new Bitmap(spriteSheet.getSpriteByNumber(0)));
			iPrevFrame = 0;
			
			x = 191;
			y = 219;
			
			addChild(sprRope);
		}
		
		override protected function onUpdate():void 
		{
			if (!bRemoved && nCutAmount > 5.0)
			{
				nCutAmount = 0.0;
				iPrevFrame += 1;
				if (iPrevFrame < spriteSheet.spriteCount)
				{
					if (sprRope) removeChild(sprRope);
					sprRope = new Sprite();
					sprRope.addChild(new Bitmap(spriteSheet.getSpriteByNumber(iPrevFrame)));
					addChild(sprRope);
					sndRopeCut.play();
				}
				else
				{
					bRemoved = true;
					dispatchEvent(new Event(EVENT_ROPE_REMOVED));
					sndRopeCut.play();
					GameScene.instance.transition();
					kill();
				}
			}
		}
		
		public function cut(multiplier:Number = 1.0):void
		{
			nCutAccum += Clock.deltaTime * multiplier;
			if (nCutAccum > 1.0)
			{
				nCutAmount += 1;
				nCutAccum = 0;
			}
		}
		
		public function fix(multiplier:Number = 1.0):void
		{
			nFixAccum += multiplier * Clock.deltaTime;
			if (nFixAccum > 1.0)
			{
				nCutAmount -= 1;
				if (nCutAmount < 0.0) nCutAmount = 0.0;
				nFixAccum = 0;
			}
		}
		
	}

}