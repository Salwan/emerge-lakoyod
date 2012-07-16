package  
{
	import cmg.EventDispatcherEx;
	import cmg.SoundContainer;
	import cmg.World;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class GameMusic extends  EventDispatcherEx
	{
		public static const GAMEMUSIC_NEXT:String = "gmqnext";
		public static const GAMEMUSIC_FINISHED:String = "gmfinish";
		private static var _music:SoundContainer;
		private static var _queue:Array = new Array();
		private static var _eventDispatcher:EventDispatcherEx;
		
		public static function play(music_class:Class, loops:int = -1):void
		{
			if (_music != null)
			{
				_music.stop();
			}
			_music = new SoundContainer(music_class);
			_music.play(0, loops);
			_music.addEventListener(SoundContainer.SOUND_FINISHED, onMusicFinished, false, 0, true);
		}
		
		public static function queue(music_class:Class, loops:int = -1):void
		{
			var obj:Object = new Object();
			obj["class"] = music_class;
			obj["loops"] = loops;
			_queue.push(obj);
		}
		
		public static function stop():void
		{
			if (_eventDispatcher == null)
			{
				_eventDispatcher = new EventDispatcherEx();
			}
			if (_music != null)
			{
				_music.removeEventListener(SoundContainer.SOUND_FINISHED, onMusicFinished); // stopping music will automatically play next, so I remove the event first
				_music.stop(); 
				_eventDispatcher.dispatchEvent(new Event(GAMEMUSIC_FINISHED));
			}
			_music = null;
		}
		
		public static function next():void
		{
			if (_music != null)
			{
				_music.stop();
				//_music.removeEventListener(SoundContainer.SOUND_FINISHED, onMusicFinished);
				//onMusicFinished(new Event("musicfinished"));
			}
		}
		
		private static function onMusicFinished(e:Event):void
		{
			if (_eventDispatcher == null)
			{
				_eventDispatcher = new EventDispatcherEx();
			}
			if (_queue.length > 0)
			{
				var m:Object = _queue[0];
				play(Class(m["class"]), int(m["loops"]));
				_queue = _queue.slice(1);
				_eventDispatcher.dispatchEvent(new Event(GAMEMUSIC_NEXT));
			}
			else
			{
				_music = null;
				_eventDispatcher.dispatchEvent(new Event(GAMEMUSIC_FINISHED));
			}
		}
		
		///////////////////////////////////////////////////// Accessors
		public static function get eventDispatcher():EventDispatcherEx
		{
			if (_eventDispatcher == null)
			{
				_eventDispatcher = new EventDispatcherEx();
			}
			return _eventDispatcher;
		}
		
		public static function get currentMusic():SoundContainer
		{
			return _music;
		}
	}

}