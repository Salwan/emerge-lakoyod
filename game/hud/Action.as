package game.hud 
{
	import cmg.Clock;
	import cmg.CMGSprite;
	import cmg.CMGSpriteSheet;
	import cmg.MovieClipEx;
	import cmg.tweener.Tweener;
	import cmg.Utils;
	import cmg.World;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.GameScene;
	/**
	 * ...
	 * @author ...
	 */
	public class Action extends MovieClipEx
	{
		private var sprText:CMGSprite;
		private var sprCircle:Bitmap;
		private var sprBuildup:Sprite;
		private var nBuildupSpeed:Number = 2;
		private var nDieOutSpeed:Number = 0.2;
		
		public function Action() 
		{
			
		}
		
		override protected function onAdded():void 
		{
			mouseEnabled = true;
			
			x = Utils.randomNumber(145, World.stageWidth - 145);
			y = Utils.randomNumber(World.stageHeight - 130, World.stageHeight - 70);
			
			var bmp:Bitmap = new Embed.Bitmap_ActionText();
			var ss:CMGSpriteSheet = new CMGSpriteSheet(bmp.bitmapData);
			ss.defineSprite("anger1", 0, 0, 88, 31);
			ss.defineSprite("anger2", 88, 0, 102, 31);
			ss.defineSprite("anger3", 0, 31, 100, 31);
			sprText = new CMGSprite(ss);
			sprText.x -= sprText.currentBitmap.width / 2;
			sprText.y -= sprText.currentBitmap.height / 2;
			//sprText.blendMode = BlendMode.ADD;
			
			sprCircle = new Embed.Bitmap_ActionCircle();
			sprCircle.x = -sprCircle.width / 2;
			sprCircle.y = -sprCircle.height / 2;
			
			bmp = new Embed.Bitmap_ActionCircle_Buildup();
			bmp.x = -bmp.width / 2;
			bmp.y = -bmp.height / 2;			
			sprBuildup = new Sprite();
			sprBuildup.addChild(bmp);
			sprBuildup.scaleX = 0.0;
			sprBuildup.scaleY = 0.0;
			sprBuildup.blendMode = BlendMode.ADD;
			
			addChild(sprCircle);
			addChild(sprBuildup);
			addChild(sprText);
			
			blendMode = BlendMode.ADD;
			alpha = 0;
			Tweener.addTween(this, { time:1, alpha:1, transition:"linear" } );
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
		}
		
		override protected function onRemoved():void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
		}
		
		override protected function onUpdate():void 
		{
			buildup -= nDieOutSpeed * Clock.deltaTime;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			buildup += nBuildupSpeed * Clock.deltaTime;
		}
		
		/////////////////////////////////////////// Accessors
		public function get buildup():Number
		{
			return sprBuildup.scaleX;
		}
		
		public function set buildup(value:Number):void
		{
			if (value >= 0.0)
			{
				if (value >= 1.0)
				{
					GameScene.instance.shout(x, y);
					stage.removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
					Tweener.addTween(this, { time:1, alpha:0, transition:"linear", onComplete:kill } );
				}
				sprBuildup.scaleX = Utils.cap(value, 1.0, 0.0);
				sprBuildup.scaleY = Utils.cap(value, 1.0, 0.0);
			}
		}
		
	}

}