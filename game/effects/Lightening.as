package game.effects 
{
	import cmg.Clock;
	import cmg.MovieClipEx;
	import cmg.SoundContainer;
	import cmg.tweener.Tweener;
	import cmg.Utils;
	import cmg.World;
	import embed.Embed;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import game.GameScene;
	/**
	 * ...
	 * @author ...
	 */
	public class Lightening extends MovieClipEx
	{
		private var sndThunder:SoundContainer;
		private var sprDraw:Sprite;
		private var nEnergy:Number;
		private var nTimer:Number;
		private var bOnce:Boolean = false;
		private var bSound:Boolean = false;
		
		public function Lightening(energy:Number = 100.0) 
		{
			nTimer = 0.0;
			sndThunder = new SoundContainer(Embed.Sound_Thunder);
			sndThunder.addEventListener(SoundContainer.SOUND_FINISHED, _remove);
			nEnergy = energy;
		}
		
		override protected function onAdded():void 
		{
			sprDraw = new Sprite();
			var ly:Number = 0.0;
			sprDraw.graphics.moveTo(0, 0);
			for (var en:Number = nEnergy; en > 0.1; en -= 20.0)
			{
				ly += Utils.randomNumber(15.0, 35.0);
				en = Math.max(en, 0.0);
				sprDraw.graphics.lineStyle((en / 20.0) * 2.0, 0xffffff);
				sprDraw.graphics.lineTo(Utils.randomNumber( -50.0, 50.0), ly);
			}
			sprDraw.graphics.lineStyle();
			addChild(sprDraw);
			sprDraw.filters = new Array(new GlowFilter(0xffffff, 1, 4, 4, 3));
			sprDraw.visible = false;
			
			GameScene.instance.lightening.strike(nEnergy / 200.0, 0.1);
		}
		
		override protected function onUpdate():void 
		{
			nTimer += Clock.deltaTime;
			if (sprDraw.visible)
			{
				sprDraw.visible = false;
			}
			if (nTimer >= 0.05 && !bOnce)
			{
				bOnce = true;
				sprDraw.visible = true;
			}
			if (nTimer >= 0.4 && !bSound)
			{
				bSound = true;
				sndThunder.play();
			}
		}
		
		private function _remove(e:Event):void
		{
			kill();
		}
		
	}

}