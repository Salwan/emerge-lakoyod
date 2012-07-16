package cmg.retro 
{
	import cmg.Clock;
	import cmg.collections.Map;
	import cmg.Collisions;
	import cmg.Perform;
	import cmg.tweener.Tweener;
	import cmg.World;
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * The guy who does everything.
	 * Responsibilities:
		 * Setting up the different game scenes
		 * Showing the final result on screen (with scaling and whatnot)
	 * @author ZenithSal
	 */
	public class RetroGame extends Sprite
	{
		public static var ScreenWidth:int = 800;	// draw width
		public static var ScreenHeight:int = 500;	// draw height
		public static var scene:RetroScene;
		
		protected var mClock:Clock = null;
		protected var mPerform:Perform = null;		
		
		protected var mSceneClasses:Map = null;
		protected var mScene:RetroScene = null;
		protected var sprDraw:Sprite = null;
		protected var mCollisions:Collisions = null;
		protected var strGameTitle:String = "Retro Game";
		protected var nDrawWidth:Number = 800.0;
		protected var nDrawHeight:Number = 500.0;
		protected var nWidthScale:Number = 1.0;
		protected var nHeightScale:Number = 1.0;
		
		protected var txtNotify:TextField;
		protected var sprNotifyText:Sprite;
		
		public function RetroGame() 
		{
			mSceneClasses = new Map();
			World.globals["game"] = this;
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
		}
		
		public function init(_title:String, swf_width:int, swf_height:int, draw_width:int, draw_height:int):void
		{	
			mCollisions = new Collisions();
			mClock = new Clock();
			strGameTitle = _title;
			
			World.stageWidth = swf_width;
			World.stageHeight = swf_height;
			
			nDrawWidth = draw_width;
			nDrawHeight = draw_height;
			ScreenWidth = nDrawWidth;
			ScreenHeight = nDrawHeight;
			nWidthScale = Number(World.stageWidth) / nDrawWidth;
			nHeightScale = Number(World.stageHeight) / nDrawHeight;
			
			sprDraw = new Sprite();
			sprDraw.width = nDrawWidth;
			sprDraw.height = nDrawHeight;
			sprDraw.graphics.beginFill(0x000000);
			sprDraw.graphics.drawRect(0, 0, nDrawWidth, nDrawHeight);
			sprDraw.graphics.endFill();
			sprDraw.scaleX = nWidthScale;
			sprDraw.scaleY = nHeightScale;
			addChild(sprDraw);
			
			// Notify text
			sprNotifyText = new Sprite();
			sprNotifyText.graphics.beginFill(0x333333);
			sprNotifyText.graphics.drawRect(0, 0, World.stageWidth, 15);
			sprNotifyText.graphics.endFill();
			sprNotifyText.y = World.stageHeight - 15;
			sprNotifyText.mouseChildren = false;
			sprNotifyText.mouseEnabled = false;
			sprNotifyText.alpha = 0;
			
			txtNotify = new TextField();
			txtNotify.width = World.stageWidth;
			var fmt:TextFormat = new TextFormat("Tahoma", 11, 0xcccccc, false);
			fmt.align = TextFormatAlign.LEFT;
			txtNotify.setTextFormat(fmt);
			txtNotify.defaultTextFormat = fmt;
			txtNotify.text = "Nothing";
			txtNotify.y = -2;
			
			sprNotifyText.addChild(txtNotify);
			addChild(sprNotifyText);
		}
		
		private function _onAddedToStage(e:Event):void
		{
			mPerform = new Perform(stage);
			World.theStage = stage;
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp, false, 0, true);
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);
			
			trace("___________________");
			trace("Retro Game         \\\n");
			trace("Title:     " + strGameTitle);
			trace("SWF Size:  " + World.stageWidth.toString() + "x" + World.stageHeight.toString());
			trace("Draw Size: " + nDrawWidth.toString() + "x" + nDrawHeight.toString());
			trace("Scale:     " + nWidthScale.toString() + "x" + nHeightScale.toString());
			trace("___________________\n");
			
			doSetupStrings();		
			doSetupScenes();
		}
		
		protected function doSetupStrings():void
		{
			
		}
		
		protected function doSetupScenes():void
		{
			
		}
		
		protected function _onEnterFrame(e:Event):void
		{
			mClock.tick();
			mPerform.tick();
			mCollisions.process();
			
			update();
		}
		
		protected function _onKeyDown(e:KeyboardEvent):void
		{
			if (RetroInput.Instance)
			{
				RetroInput.Instance._onKeyDown(e);
			}
		}
		
		protected function _onKeyUp(e:KeyboardEvent):void
		{
			if (RetroInput.Instance)
			{
				RetroInput.Instance._onKeyUp(e);
			}
		}
		
		protected function update():void
		{
			
		}
		
		protected function defineScene(name:String, sceneClass:Class):void
		{
			mSceneClasses.add(name, sceneClass);
		}
		
		public function changeScene(name:String):void
		{
			if (_scene)
			{
				drawSprite.removeChild(_scene);
				_scene = null;
			}
			Collisions.cleanup();
			var sceneClass:Class = mSceneClasses.itemFor(name);
			_scene = new sceneClass();
			_scene.init();
			drawSprite.addChild(_scene);
		}
		
		public function notify(text:String, time:Number = 2.0):void
		{
			Tweener.removeTweens(sprNotifyText);
			txtNotify.text = text;
			Tweener.addTween(sprNotifyText, { time:0.5, alpha:1, transition:"linear" } );
			Tweener.addTween(sprNotifyText, { delay:time + 0.5, time:0.5, alpha:0, transition:"linear" } );
		}
		
		/////////////////////////////////////////////// Accessors
		public function get drawSprite():Sprite
		{
			return sprDraw;
		}
		
		private function get _scene():RetroScene
		{
			return mScene;
		}
		
		private function set _scene(value:RetroScene):void
		{
			mScene = value;
			scene = value;
		}
	}

}