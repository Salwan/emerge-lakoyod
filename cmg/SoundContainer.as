package cmg 
{
	import adobe.utils.CustomActions;
	import cmg.tweener.Tweener;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import mx.core.SoundAsset;
	
	/**
	 * Used as a container for sound assets, useful to embed sounds via flex.
	 * - Provides mute and group mute
	 * - Provides pause and group pause
	 * - Manages modifying sound transform
	 * @author ZenithSal
	 */
	public class SoundContainer extends EventDispatcherEx
	{
		public static const SOUND_NEXT_LOOP:String = "sndloop";
		public static const SOUND_FINISHED:String = "sndfinished";
		
		private static var _isInit:Boolean = false;
		private static var _sndList:Vector.<WeakRef> = null;
		private static var bGameMute:Boolean = false;
		
		public var tag:String = "";
		
		private var mSound:Sound = null;		
		private var mSoundChannel:SoundChannel = null;
		private var _internalSoundTransform:SoundTransform = null;
		//private var mActiveSoundTransform:SoundTransform = null // can hold the actual sound transform or the muted one
		private var bPlaying:Boolean = false;
		private var bMuted:Boolean = false;
		private var iLoops:int = 0;
		
		public function SoundContainer(soundClass:Class) 
		{
			mSound = new soundClass() as Sound;
			if (!SoundContainer._isInit)
			{
				SoundContainer._init();
			}
			_sndList.push(new WeakRef(this));
		}
		
		private static function _init():void
		{
			_sndList = new Vector.<WeakRef>();
			_isInit = true;
		}
		
		////////////////////////////////////////////////////// Group Actions
		public static function muteAll(tagged:String = ""):void
		{
			if (!_isInit)
			{
				return;
			}
			var t:SoundContainer;
			var sweep:Boolean = false;
			for (var i:int = 0; i < _sndList.length; ++i)
			{
				t = SoundContainer(_sndList[i].get());
				if (t && t.tag == tagged)
				{
					t.mute();			
					sweep = true;
				}
			}
			
			if (sweep)
			{
				sweepDead();
			}
		}
		
		public static function unmuteAll(tagged:String = ""):void
		{
			if (!_isInit)
			{
				return;
			}
			var t:SoundContainer;
			var sweep:Boolean = false;
			for (var i:int = 0; i < _sndList.length; ++i)
			{
				t = SoundContainer(_sndList[i].get());
				if (t && t.tag == tagged)
				{
					t.unmute();
					sweep = true;
				}
			}
			
			if (sweep)
			{
				sweepDead();
			}
		}
		
		public static function pauseAll(tagged:String = ""):void
		{
			if (!_isInit)
			{
				return;
			}
		}
		
		public static function resumeAll(tagged:String = ""):void
		{
			if (!_isInit)
			{
				return;
			}
		}
		
		public static function sweepDead():void
		{
			if (!_isInit)
			{
				return;
			}
			var before:int = _sndList.length;
			_sndList = _sndList.filter(callbackIsSoundDead);
			trace("SWEEPING " + (before - _sndList.length).toString() + " DEAD SoundEx");
		}
		
		private static function callbackIsSoundDead(element:*, index:int, vec:Vector.<WeakRef>):Boolean
		{
			return WeakRef(element).get() != null? true : false;
		}
		
		////////////////////////////////////////////////////// Actions
		public function play(start_time:Number = 0, loops:int = 0, snd_transform:SoundTransform = null):void
		{
			if (isPlaying)
			{
				stop();
			}
			if (!snd_transform)
			{
				internalSoundTransform = new SoundTransform(1, 0);
			}
			else
			{
				internalSoundTransform = snd_transform;
			}
			
			//mActiveSoundTransform = internalSoundTransform;
			
			iLoops = loops;
			if (!bMuted)
			{
				mSoundChannel = mSound.play(start_time, 0, internalSoundTransform);
			}
			else
			{
				mSoundChannel = mSound.play(start_time, 0, new SoundTransform(0));
			}
			mSoundChannel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
			bPlaying = true;
			
			if (gameMute)
			{
				mute();
			}
		}
		
		public function mute():void
		{
			if (mSoundChannel && !bMuted)// && !bGameMute)
			{
				
				bMuted = true;
				//soundTransform = new SoundTransform(0);
				mSoundChannel.soundTransform = new SoundTransform(0);
			}
		}
		
		public function unmute():void
		{
			if(bMuted)
			{
				bMuted = false;
				//mActiveSoundTransform = internalSoundTransform;
				soundTransform = internalSoundTransform;				
			}
		}
		
		public function stop():void
		{
			if (isPlaying)
			{
				mSoundChannel.stop();
				mSoundChannel = null;
				bPlaying = false;
				bMuted = false;
				dispatchEvent(new Event(SOUND_FINISHED));
			}
		}
		
		private function _onSoundComplete(e:Event):void
		{
			if (mSoundChannel)
			{
				mSoundChannel.removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
				if (iLoops > 0)
				{
					iLoops -= 1;
				}
				if (iLoops != 0)
				{
					if (!bMuted)
					{
						mSoundChannel = mSound.play(0, 0, internalSoundTransform);
					}
					else
					{
						mSoundChannel = mSound.play(0, 0, new SoundTransform(0));
					}
					mSoundChannel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
					dispatchEvent(new Event(SOUND_NEXT_LOOP));
				}
				else
				{
					mSoundChannel = null;
					bPlaying = false;
					dispatchEvent(new Event(SOUND_FINISHED));
				}
			}
		}
		
		////////////////////////////////////////////////////// Accessors
		public function get isPlaying():Boolean
		{
			return bPlaying;
		}
		
		public function get internalSoundTransform():SoundTransform
		{
			return  _internalSoundTransform;
		}
		
		public function set internalSoundTransform(value:SoundTransform):void
		{
			_internalSoundTransform = value;
			//if (!bMuted)// && !bGameMute)
			//{
				//mActiveSoundTransform = _internalSoundTransform;
			//}
		}
		
		public function get soundTransform():SoundTransform
		{
			return internalSoundTransform;
		}
		
		public function set soundTransform(value:SoundTransform):void
		{
			internalSoundTransform = value;
			if (!bMuted && mSoundChannel)
			{
				mSoundChannel.soundTransform = new SoundTransform(internalSoundTransform.volume, internalSoundTransform.pan);
			}
		}
		
		public static function get gameMute():Boolean
		{
			return bGameMute;
		}
		
		public static function set gameMute(value:Boolean):void
		{
			bGameMute = value;
			//if (value)
			//{				
				//muteAll();
			//}
			//else
			//{
				//unmuteAll();
			//}
		}
	}

}
