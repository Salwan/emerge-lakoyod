package cmg 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import cmg.tweener.Tweener;
	
	/**
	 * This is an extended MovieClip.
	 * It allows centralized actions that apply to all MovieClips at once.
	 * - The first goal behind it's creation is to facilitate pausing all MovieClips
	 * in a given scene.
	 * - function kill() which automatically clears the movieclip off the scene
	 * - Keeps track of all registered event listeners and remove them 
	 * automatically when the movieclip is killed, it's not recommended but you can 
	 * disable this feature by setting flag: _clearEventListeners = false (enabled by default)
	 * @author ZenithSal
	 */
	public class MovieClipEx extends MovieClip
	{
		public var hitBox:Sprite = null;
		public var hitPoint:Point = null;
		public var tag:String = "";
		
		protected static var _isInit:Boolean = false;
		protected static var _mcList:Vector.<MovieClipEx> = null;
		
		protected var _clearEventListeners:Boolean = true;
		protected var _eventList:Vector.<Object> = null;
		protected var _paused:Boolean = false;
		protected var _isPlaying:Boolean = true;
		protected var _isPrevPlaying:Boolean = true;
		protected var iHealth:int = 100;		
		protected var iFullHealth:int = 100;
		protected var enteredFirstFrame:Boolean = false;
		
		public function MovieClipEx() 
		{
			super();
			if (!_isInit)
			{
				MovieClipEx._init();
			}
			
			// Disable mouse events by default (the: every movieclip intercepts mouse thing gave me a headache and wasted a day of work)
			mouseEnabled = false;
			
			_eventList = new Vector.<Object>();
			
			// Events
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false, 0, true);
		}
		
		public function set clearEventListeners(clear:Boolean):void
		{
			_clearEventListeners = clear;
		}
		
		public function get clearEventListeners():Boolean
		{
			return _clearEventListeners;
		}
		
		private function _onAddedToStage(e:Event):void
		{
			//trace("ADDED_TO_STAGE " + this);
			_mcList.push(this);
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);			
			addEventListener(Event.ENTER_FRAME, __onEnterFrame, false, 0, true);
			onInit();
			onAdded();
		}		
		
		protected function onInit():void
		{
			
		}
		
		protected function onAdded():void
		{
			
		}
		
		private function _onRemovedFromStage(e:Event):void
		{
			//trace("REMOVED_FROM_STAGE " + this);			
			onRemoved();
			
			// Remove all remaining events
			if (_clearEventListeners)
			{
				clearAllEvents();
			}
			
			// Remove if exists from MovieClipEx list:
			var indx:int = _mcList.indexOf(this);
			if (indx != -1)
			{
				_mcList.splice(indx, 1);
			}			
		}
		
		protected function onRemoved():void
		{
			
		}
		
		private function __onEnterFrame(e:Event):void
		{
			if (!enteredFirstFrame)
			{
				onFirstFrame();
				enteredFirstFrame = true;
			}
			onUpdate();
		}
		
		protected function onFirstFrame():void
		{
			
		}
		
		protected function onUpdate():void
		{
			
		}
		
		private static function _init():void
		{
			_mcList = new Vector.<MovieClipEx>();
			MovieClipEx._isInit = true;
		}
		
		public function kill():void
		{	
			// Remove any collision detection relationships
			Collisions.removeElementAll(this);
			
			// Removing all events except REMOVED_FROM_STAGE
			if (_clearEventListeners)
			{
				clearAllEvents(Event.REMOVED_FROM_STAGE);
			}
			
			// Remove from parent
			if (parent)
			{
				parent.removeChild(this);
			}
			else
			{
				trace("[ERROR] " + this + " has parent = NULL at kill()");
			}
			
			health = 0;
		}
		
		public function pause():void
		{
			if (!_paused)
			{
				// Pause all events (remove them all)
				for (var i:int = 0; i < _eventList.length; ++i)
				{
					// remove items from parent (removing them from here will also remove _eventList)
					super.removeEventListener(_eventList[i]["type"], _eventList[i]["listener"], _eventList[i]["useCapture"]);
				}
				
				// Pause all tweens
				Tweener.pauseAllTweens();
				
				// Should also pause:
				// - Sound effects related to this movie clip (SoundEx pauses itself)
				// - Flint particles emitted by this movie clip
				onPause();
				
				// Pause movie
				_isPrevPlaying = _isPlaying;
				stop();
				
				_paused = true;				
			}
		}
		
		public function resume():void
		{
			if (_paused)
			{
				// Resume all events (readd them)
				for (var i:int = 0; i < _eventList.length; ++i)
				{
					// add items to parent (adding them here will add them again to _eventList)
					super.addEventListener(_eventList[i]["type"], _eventList[i]["listener"], _eventList[i]["useCapture"], 
						_eventList[i]["priority"], _eventList[i]["useWeakReference"]);
				}
				
				// Resume all tweens
				Tweener.resumeAllTweens();
				
				// Resume:
				// - Sound effects related to this movie clip (SoundEx resume itself)
				// - Flint particles emitted by this movie clip
				onResume();
				
				// Resume playing state
				if (_isPrevPlaying)
				{
					play();
				}
				
				_paused = false;
			}
		}
		
		/**
		 * Do custom pause actions here
		 */
		protected function onPause():void
		{
		}
		
		/**
		 * Do custom resume actions here
		 */
		protected function onResume():void
		{
		}
		
		public function isPaused():Boolean
		{
			return _paused;
		}
		
		public function isPlayingEx():Boolean
		{
			return _isPlaying;
		}
		
		public static function pauseAll(_tag:String = ""):void
		{
			for (var i:int = 0; i < _mcList.length; ++i)
			{
				if (_mcList[i].tag == _tag)
				{
					_mcList[i].pause();
				}
			}
			trace("PAUSED " + _mcList.length + " MovieClipEx");
		}
		
		public static function resumeAll(_tag:String = ""):void
		{
			for (var i:int = 0; i < _mcList.length; ++i)
			{
				if (_mcList[i].tag == _tag)
				{
					_mcList[i].resume();
				}
			}
			trace("RESUMED " + _mcList.length + " MovieClipEx");
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			var obj:Object = new Object();
			obj["type"] = type;
			obj["listener"] = listener;
			obj["useCapture"] = useCapture;
			obj["priority"] = priority;
			obj["useWeakReference"] = useWeakReference;
			_eventList.push(obj);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
			
			var index:int = -1;
			for (var i:int = 0; i < _eventList.length; ++i)
			{
				if (_eventList[i]["type"] == type && _eventList[i]["listener"] == listener && _eventList[i]["useCapture"] == useCapture)
				{
					index = i;
					break;
				}
			}
			if (index > -1)
			{
				_eventList.splice(index, 1);
			}
		}
		
		/**
		 * Clears all registered events with the Flash event system
		 */
		protected function clearAllEvents(exclude:String = null):void
		{
			var tempList:Vector.<Object> = _eventList.concat();
			for (var i:int = 0; i < tempList.length; ++i)
			{
				if (tempList[i]["type"] != exclude)
				{
					removeEventListener(tempList[i]["type"], tempList[i]["listener"], tempList[i]["useCapture"]);
				}
			}
			tempList = null;
		}
		
		/**
		 * Element takes damage
		 */
		public function takeDamage(amount:int):void
		{
			health -= amount;
			if (health <= 0)
			{
				health = 0;
				kill();
			}
		}
		
		protected function onHealthChanged(past:int, future:int):void
		{
			
		}
		
		public function set health(amount:int):void
		{
			onHealthChanged(iHealth, amount);
			iHealth = amount;
		}
		
		public function get health():int
		{
			return iHealth;
		}
		
		override public function play():void 
		{
			super.play();
			_isPlaying = true;
		}
		
		override public function stop():void 
		{
			super.stop();
			_isPlaying = false;
		}
		
		override public function gotoAndPlay(frame:Object, scene:String = null):void 
		{
			super.gotoAndPlay(frame, scene);
			_isPlaying = true;
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			super.gotoAndStop(frame, scene);
			_isPlaying = false;
		}
	}

}