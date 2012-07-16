package game.elements 
{
	import cmg.Clock;
	import cmg.CMGSprite;
	import cmg.CMGSpriteSheet;
	import cmg.MovieClipEx;
	import cmg.SoundContainer;
	import cmg.Utils;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import game.GameScene;
	import game.PixelCollider;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Cover extends PixelCollider
	{
		public static const EVENT_EMERGED:String = "emerged";
		public static const EVENT_DISPOSED:String = "disposed";
		
		private var bmpCoverSS:Bitmap;
		private var bmpCover:Bitmap;
		private var sprCover:Sprite;
		private var spriteSheet:CMGSpriteSheet;
		private var nRaiseAmount:Number = 0.0;
		private var nRaiseSpeed:Number = 2.0;
		private var nSinkSpeed:Number = 0.75;
		private var nRaiseAccum:Number = 0.0;
		private var nSinkAccum:Number = 0.0;
		private var bEmerged:Boolean = false;
		private var bDisposed:Boolean = false;
		private var iFinalY:int;
		private var iPrevFrame:int;
		private var sndTear:SoundContainer;
		
		public function Cover() 
		{
			name = "cover";
		}
		
		override protected function onAdded():void 
		{
			sndTear = new SoundContainer(Embed.Sound_Tear);
			
			bmpCoverSS = new Embed.Bitmap_Cover_SpriteSheet();			
			spriteSheet = new CMGSpriteSheet(bmpCoverSS.bitmapData);
			spriteSheet.defineSpriteSheet(8, 409, 126, "cov");
			sprCover = new Sprite();
			sprCover.addChild(new Bitmap(spriteSheet.getSpriteByNumber(0)));
			iPrevFrame = 0;
			addChild(sprCover);
			
			bmpCover = new Embed.Bitmap_Cover();
			bmpCover.visible = false;
			addChild(bmpCover);
			
			
			x = 181;
			y = 335;
			bmpCollision = bmpCover;
		}
		
		override protected function onUpdate():void 
		{
			if (!bEmerged && y + bmpCover.height <= 335)
			{
				bEmerged = true;
				GameScene.instance.transition();
				dispatchEvent(new Event(EVENT_EMERGED));
				iFinalY = y;
				nRaiseAmount = 0.0;
			}
			if (bEmerged && !bDisposed)
			{
				var rx:int = Utils.randomInt( -3, 3);
				var ry:int = Utils.randomInt( -1, 1);
				x = 181 + rx;
				y = iFinalY + ry;
				var f:int = Math.floor((nRaiseAmount / 100.0) * spriteSheet.spriteCount);
				f = Utils.cap(f, spriteSheet.spriteCount - 1, 0);
				if (f != iPrevFrame)
				{
					if (f > iPrevFrame)
					{
						sndTear.play();
					}
					removeChild(sprCover);
					sprCover = new Sprite();
					sprCover.addChild(new Bitmap(spriteSheet.getSpriteByNumber(f)));
					iPrevFrame = f;
					addChild(sprCover);
				}
				Console.log(f.toString());
				if (nRaiseAmount >= 100.0)
				{
					bDisposed = true;
					dispatchEvent(new Event(EVENT_DISPOSED));
					nRaiseAmount = 0.0;
					GameScene.instance.transition();
					removeChild(sprCover);
					sprCover = null;
					kill();
				}
			}
		}
		
		public function raise():void
		{
			nRaiseAccum += nRaiseSpeed * Clock.deltaTime;
			if (nRaiseAccum >= 1.0)
			{
				if (!bEmerged)
				{
					y -= 1.0;
				}
				nRaiseAccum = 0.0;
				nRaiseAmount += 1.0;
			}
		}
		
		public function sink():void
		{
			nSinkAccum += nSinkSpeed * Clock.deltaTime;
			if (nSinkAccum >= 1.0)
			{
				if (!bEmerged)
				{
					y += 1.0;
				}
				nSinkAccum = 0.0;
				nRaiseAmount = Math.max(nRaiseAmount - 1.0, 0.0);
			}
		}
		
		//////////////////////////////////////////// Accessors
		public function get raiseAmount():Number
		{
			return nRaiseAmount;
		}
		
		public function get disposed():Boolean		
		{
			return bDisposed;
		}
		
	}

}