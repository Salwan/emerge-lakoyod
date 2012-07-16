package 
{
	import cmg.Clock;
	import cmg.CMGScene;
	import cmg.Perform;
	import cmg.SoundContainer;
	import cmg.StateMachine;
	import cmg.tweener.properties.FilterShortcuts;
	import cmg.tweener.Tweener;
	import cmg.Utils;
	import cmg.World;
	import cmg.DebugBar;
	import embed.Embed;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import game.GameScene;
	import end.EndScene;
	
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class Main extends Sprite 
	{
		public static const FADE_COMPLETE:String = "fadecomplete";
		public static const SHAKE_START:String = "shk1";
		public static const SHAKE_UPDATE:String = "shk2";
		public static const SHAKE_END:String = "shk3";
		
		private var _perform:Perform;
		private var _clock:Clock;
		private var _debugBar:DebugBar;
		private var _stateMachine:StateMachine;
		private var _top:Sprite;
		private var _root:Sprite;		
		private var _scene:CMGScene;
		private var sprFade:Sprite;
		private var nShakeIntensity:Number = 0.0;
		private var nShakeDuration:Number = 0.0;		
		private var sndEarthQuake:SoundContainer;
		
		
		public function Main():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		private function onAddedToStage(e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false , 0, true);
			
			// Setup stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			
			// World init
			World.init(this, 800, 500);
			
			// Register fonts
			Font.registerFont(Embed.Font_Game);
			
			// Activate filter tweener shortcuts
			FilterShortcuts.init();
			
			// Main components
			_perform = new Perform(stage);
			_clock = new Clock();
			
			// Main layers
			_root = World.getLayer(World.LAYER_ROOT);
			_top = World.getLayer(World.LAYER_TOP);
			
			// Debug bar
			_debugBar = new DebugBar();
			Console.debugBar = _debugBar;
			World.addChildTo(World.LAYER_DEBUG, _debugBar);
			
			// State machine
			_stateMachine = new StateMachine("Main");
			_stateMachine.addState("game", { enter:onGameEnter, update:onGameUpdate, exit:onGameExit, from:"*" } );	
			_stateMachine.addState("end", { enter:onEndEnter, update:onEndUpdate, exit:onEndExit, from:"*" } );
			_stateMachine.initialState = "game";
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			// Sounds
			sndEarthQuake = new SoundContainer(Embed.Sound_EarthQuake);
		}
		
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_clock.tick();
			_perform.tick();
			
			// Shake
			if (nShakeDuration > 0.0)
			{
				nShakeDuration -= Clock.deltaTime;
				if (nShakeDuration <= 0.0)
				{
					x = 0.0;
					y = 0.0;
				}
				else
				{
					var a:Number = 100.0 * nShakeIntensity;
					x = Utils.randomNumber(0.0, a) - (a / 2);
					y = Utils.randomNumber(0.0, a) - (a / 2);
					dispatchEvent(new Event(SHAKE_UPDATE));
				}
			}
		}
		
		private function _startScene(scene_class:Class):void
		{
			if (_scene != null)
			{
				_root.removeChild(_scene);
				_scene = null;
			}
			_scene = new scene_class();
			_root.addChild(_scene);
		}
		
		private function _endScene():void
		{
			if (scene)
			{
				_root.removeChild(scene);
				_scene = null;
			}
		}
		
		public function changeScene(scene_name:String):void
		{
			_stateMachine.changeState(scene_name);
		}
		
		public function fadeInFill(fade_time:Number = 0.5, fill_color:uint = 0x000000):void
		{
			if (sprFade)
			{
				Tweener.removeTweens(sprFade);
				_top.removeChild(sprFade);
				sprFade = null;
			}
			sprFade = new Sprite();
			sprFade.graphics.beginFill(fill_color);
			sprFade.graphics.drawRect(0, 0, World.stageWidth, World.stageHeight);
			sprFade.graphics.endFill();
			_top.addChild(sprFade);
			sprFade.alpha = 0;
			Tweener.addTween(sprFade, { time:fade_time, alpha:1, transition:"linear", onComplete:_onFadeComplete } );
		}
		
		public function fadeOutFill(fade_time:Number = 0.5, fill_color:uint = 0x000000):void
		{
			if (sprFade == null)
			{
				sprFade = new Sprite();
				sprFade.graphics.beginFill(fill_color);
				sprFade.graphics.drawRect(0, 0, World.stageWidth, World.stageHeight);
				sprFade.graphics.endFill();
				_top.addChild(sprFade);
			}
			Tweener.removeTweens(sprFade);
			Tweener.addTween(sprFade, { time:fade_time, alpha:0, transition:"linear", onComplete:_onFadeComplete } );
		}
		
		private function _onFadeComplete():void
		{
			dispatchEvent(new Event(FADE_COMPLETE));
			_top.removeChild(sprFade);
			sprFade = null;
		}
		
		public function shake(intensity:Number = 0.1, duration:Number = 0.5):void
		{			
			if (nShakeDuration > 0.0)
			{
				_endShake();
			}
			Tweener.addTween(this, { time:duration, onComplete:_endShake } );
			sndEarthQuake.play(0, -1);
			//sndEarthQuake.soundTransform.volume = 0.3;
			nShakeIntensity = intensity;
			nShakeDuration = duration;
			dispatchEvent(new Event(SHAKE_START));
		}
		
		private function _endShake():void
		{
			sndEarthQuake.stop();
			dispatchEvent(new Event(SHAKE_END));
		}
		
		public function setShakeIntensity(intensity:Number):void
		{
			nShakeIntensity = intensity;
		}
		
		//====================================================
		//////////////////////////////////////////////// State Game
		private function onGameEnter(e:Event):void
		{
			_startScene(GameScene);
		}
		
		private function onGameUpdate(e:Event):void
		{
			
		}
		
		private function onGameExit(e:Event):void
		{
			_endScene();
		}
		
		//////////////////////////////////////////////// State End
		private function onEndEnter(e:Event):void
		{
			_startScene(EndScene);
		}
		
		private function onEndUpdate(e:Event):void
		{
			
		}
		
		private function onEndExit(e:Event):void
		{
			_endScene();
		}
		
		//////////////////////////////////////////////// Accessors
		public function get debugBar():DebugBar
		{
			return _debugBar;
		}	
		
		public function get scene():CMGScene
		{
			return _scene;
		}
		
	}
	
}