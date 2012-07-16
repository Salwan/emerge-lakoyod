package cmg.retro 
{
	import cmg.Collisions;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * A scene from the game, could be anything.
	 * @author ZenithSal
	 */
	public class RetroScene extends Sprite
	{
		private var _input:RetroInput;
		
		private var mLevel:RetroLevel = null;
		private var bLevelStarted:Boolean = false;
		
		public function RetroScene() 
		{
			_input = new RetroInput();
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
			addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false, 0, true);
		}
		
		private function _onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			start();
		}
		
		private function _onEnterFrame(e:Event):void
		{
			update();
			if (bLevelStarted && mLevel)
			{
				mLevel.update();
			}
		}
		
		private function _onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			level = null;
			end();
		}
		
		public function addEntity(entity:RetroEntity):void
		{
			addChild(entity);
		}
		
		public function removeEntity(entity:RetroEntity):void
		{
			removeChild(entity);
		}
		
		public function init():void
		{
			
		}
		
		protected function start():void
		{

		}
		
		protected function update():void
		{
			
		}
		
		protected function end():void
		{
			
		}
		
		protected function startLevel():void
		{
			if (!bLevelStarted && mLevel)
			{
				mLevel.start();
				bLevelStarted = true;
			}
		}
		
		protected function stopLevel():void
		{
			if (bLevelStarted && mLevel)
			{
				mLevel.end();
				bLevelStarted = false;
			}
		}
		
		/////////////////////////////////////////////////// Accessors
		public function get level():RetroLevel
		{
			return mLevel;
		}
		
		public function set level(value:RetroLevel):void
		{
			if (mLevel)
			{
				removeChild(mLevel);
				if (bLevelStarted)
				{
					mLevel.end();
					mLevel = null;
					bLevelStarted = false;
				}
			}
			mLevel = value;
			if (mLevel)
			{
				mLevel.init();
				addChild(mLevel);
			}
		}
		
		public function get input():RetroInput
		{
			return _input;
		}
		
	}

}