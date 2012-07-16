package cmg 
{
	import cmg.flintparticles.common.counters.Counter;
	import cmg.flintparticles.threeD.papervision3d.initializers.ApplyMaterial;
	import cmg.WeakRef;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * Flash Sound object with support for:
	 * - Pausing/resuming/groups: done using WeakRef to store created sounds, with tags for grouping
	 * - Sound has no ability to loop indefinitely, SoundEx can loop indefinitely when given -1 as loop count
	 * @author Zenith
	 */
	public class SoundEx extends Sound
	{
		protected static var _isInit:Boolean = false;
		protected static var _sndList:Vector.<WeakRef> = null;
		
		public var tag:String = "";
		
		protected var iLoops:int = 0;
		protected var iPausePos:int = 0;
		protected var isPlaying:Boolean = false;
		protected var isPaused:Boolean = false;
		protected var mSoundChannel:SoundChannel = null;
		protected var mSoundTransform:SoundTransform = null;
		protected var isInfiniteLoop:Boolean = false;
		
		public function SoundEx() 
		{
			super();
			
			if (!_isInit)
			{
				SoundEx._init();
			}
		}
		
		protected static function _init():void
		{
			_sndList = new Vector.<WeakRef>();
			_isInit = true;
		}
		
		public static function pauseAll(tagged:String = ""):void
		{
			if (!_isInit)
			{
				return;
			}
			var pausedCount:int = 0;
			var mark:Boolean = false;
			var s:SoundEx = null;
			var t:* = null;
			for (var i:int = 0; i < _sndList.length; ++i)
			{
				t = _sndList[i].get();
				if (t)
				{
					s = SoundEx(t)
					if (s.tag == tagged)
					{
						pausedCount += 1;
						s.pause();
					}
				}
				else
				{
					// Sound has been garbage collected, dispose
					mark = true;
				}
			}
			if (mark)
			{
				sweepDead();
			}
			
			trace("PAUSED " + pausedCount + " SoundEx");
		}
		
		public static function resumeAll(tagged:String = ""):void
		{
			if (!_isInit)
			{
				return;
			}
			var pausedCount:int = 0;
			var mark:Boolean = false;
			var s:SoundEx = null;
			for (var i:int = 0; i < _sndList.length; ++i)
			{
				if (_sndList[i].get())
				{
					s = SoundEx(_sndList[i].get())
					if (s.tag == tagged)
					{
						pausedCount += 1;
						s.resume();
					}
				}
				else
				{
					// Sound has been garbage collected, dispose
					mark = true;
				}
			}
			if (mark)
			{
				sweepDead();
			}
			
			trace("RESUMED " + pausedCount + " SoundEx");
		}
		
		public static function sweepDead():void
		{
			var before:int = _sndList.length;
			_sndList = _sndList.filter(callbackIsSoundDead);
			trace("SWEEPING " + (before - _sndList.length).toString() + " DEAD SoundEx");
		}
		
		public static function dump():void
		{
			trace("## SoundEx Dump ##");
			trace("SoundEx has ", _sndList.length, " elements in sound list");
			trace("of which:");
			var valid:int = 0;
			var invalid:int = 0;
			for (var i:int = 0; i < _sndList.length; ++i)
			{
				if (_sndList[i].get() != null)
				{
					valid += 1;
				}
				else
				{
					invalid += 1;
				}
			}
			trace("- ", valid.toString(), " valid sounds");
			trace("- ", invalid.toString(), "invalid sounds");
		}
		
		protected static function callbackIsSoundDead(element:*, index:int, vec:Vector.<WeakRef>):Boolean
		{
			return WeakRef(element).get() != null? true : false;
		}
		
		override public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel 
		{
			if (isPlaying)
			{
				stop();
			}
			
			iLoops = loops; // SoundEx does the loops itself
			mSoundTransform = sndTransform;
			mSoundChannel = super.play(startTime, 0, sndTransform);
			mSoundChannel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
			isPlaying = true;
			
			// Keep it in active sounds list
			_sndList.push(new WeakRef(this));
			
			return mSoundChannel;
		}
		
		public function pause():void
		{
			if (!isPaused && isPlaying)
			{
				isPaused = true;
				if (mSoundChannel)
				{
					iPausePos = mSoundChannel.position;
					mSoundChannel.removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false);
					mSoundChannel.stop();
					mSoundChannel = null;
				}
			}
		}
		
		public function resume():SoundChannel
		{
			if (isPaused)
			{
				isPaused = false;
				if (!mSoundChannel)
				{
					mSoundChannel = play(iPausePos, iLoops, mSoundTransform);
					return mSoundChannel;
				}
			}
			return mSoundChannel;
		}
		
		public function stop():void
		{
			isPlaying = false;
			if (mSoundChannel)
			{
				mSoundChannel.removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false);
				mSoundChannel.stop();
				mSoundChannel = null;
			}
			mSoundTransform = null;
			iLoops = 0;
			isPaused = false;
		}
		
		protected function _onSoundComplete(e:Event):void
		{
			if (!isPaused)
			{
				if (iLoops > 0)
				{
					iLoops -= 1;
				}
				if (iLoops != 0)
				{
					mSoundChannel = super.play(0, 0, mSoundTransform);
					mSoundChannel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
				}
				else
				{
					mSoundChannel.removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false);
				}
			}
		}
		
		public function get playing():Boolean
		{
			return isPlaying;
		}
	}

}