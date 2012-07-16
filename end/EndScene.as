package end 
{
	import cmg.CMGScene;
	import cmg.CMGTLFLabel;
	import cmg.tweener.Tweener;
	import cmg.World;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class EndScene extends CMGScene
	{
		private var background:Sprite;
		private var text1:CMGTLFLabel;
		private var text2:CMGTLFLabel;
		private var text3:CMGTLFLabel;
		private var freesound:CMGTLFLabel;
		private var fs_attribs:CMGTLFLabel;
		
		public function EndScene() 
		{
			
		}
		
		override protected function onAdded():void 
		{
			background = new Sprite();
			background.graphics.beginFill(0x000000);
			background.graphics.drawRect(0, 0, World.stageWidth, World.stageHeight);
			background.graphics.endFill();
			addChild(background);
			
			text1 = new CMGTLFLabel("game_font", 36, 0xcccccc);
			text1.text = "زنقـــــــة الألعــــــاب 2012";
			text1.setCenterPosition(World.stageWidth / 2, 180);
			addChild(text1);
			text1.alpha = 0;
			Tweener.addTween(text1, { delay:1, time:1, alpha:1, transition:"linear" } );
			
			text2 = new CMGTLFLabel("game_font", 32, 0xcccccc);
			text2.text = "ســــــلوان أســــعد";
			text2.setCenterPosition(World.stageWidth / 2, 230);
			addChild(text2);
			text2.alpha = 0;
			Tweener.addTween(text2, { delay:1.5, time:1, alpha:1, transition:"linear" } );
			
			text3 = new CMGTLFLabel("game_font", 24, 0x0000cc);
			text3.text = "تمـــــت";
			text3.setCenterPosition(World.stageWidth / 2, 400);
			addChild(text3);
			text3.alpha = 0;
			Tweener.addTween(text3, { delay:3, time:2, alpha:1, transition:"linear" } );
			
			freesound = new CMGTLFLabel("game_font", 16, 0xaaaaaa);
			freesound.text = "This game uses sound effects from FreeSound.org, attributions:"
			freesound.setCenterPosition(World.stageWidth / 2, 300);
			addChild(freesound);
			freesound.alpha = 0;
			Tweener.addTween(freesound, { delay:2, time:1, alpha:1, transition:"linear" } );
			
			fs_attribs = new CMGTLFLabel("game_font", 14, 0x9999aa);
			fs_attribs.text = "nicstage, thanvannispen, rupert1073, walkter-odington, halleck, erdie, herbertboland, the-bizniss, smidoid, fotoshop, jpolito";
			fs_attribs.setCenterPosition(World.stageWidth / 2, 320);
			addChild(fs_attribs);
			fs_attribs.alpha = 0;
			Tweener.addTween(fs_attribs, { delay:2.5, time:1, alpha:1, transition:"linear" } );
			
			alpha = 0;
			Tweener.addTween(this, { time:1, alpha:1, transition:"linear" });
		}
	}

}