package cmg 
{
	import cmg.collections.Map;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	/**
	 * A MovieClipEx sprite that uses a spritesheet to display things.
	 * @author Salwan
	 */
	public class CMGSprite extends MovieClipEx
	{
		public static const EVENT_ANIMATION_CYCLE:String = "animcycle";
		public static const EVENT_ANIMATION_FINISH:String = "animfin";
		
		private var _spriteSheet:CMGSpriteSheet;
		private var animations:Map;
		private var iAnimationType:int;
		private var currentAnimation:String;
		private var currentAnimationFrames:Array;
		private var allFrames:Array;
		private var nFrameTime:Number;
		private var currentAnimationType:int;
		private var iFrameIndex:int;
		private var bIsPlaying:Boolean;
		private var nAnimationTimer:Number;
		private var currentSprite:Bitmap;
		private var bPingPong:Boolean = false;
		
		public function CMGSprite(spritesheet:CMGSpriteSheet) 
		{
			_spriteSheet = spritesheet;
			animations = new Map();
			iAnimationType = 0;
			
			allFrames = new Array();
			for (var i:int = 0; i < _spriteSheet.spriteCount; ++i)
			{
				allFrames.push(i);
			}
			animations.add("all", allFrames);
			playAnimation();
		}
		
		public function defineAnimation(name:String, frames:Array):void
		{
			animations.add(name, frames);
		}
		
		public function playAnimation(animation:String = "all", frameTime:Number = 0.5, type:int = CMGAnimationType.ANIMATION_LOOP):void
		{
			if (animations.hasKey(animation))
			{
				currentAnimation = animation;
				currentAnimationFrames = animations.itemFor(animation);
				nFrameTime = frameTime;
				currentAnimationType = type;
				bIsPlaying = true;
				nAnimationTimer = 0.0;
				frameIndex = 0;
			}
			else
			{
				throw new String("CMGSprite->Animation:" + animation + " is not defined!");
			}
		}
		
		public function stopAnimation():void
		{
			bIsPlaying = false;
		}
		
		override protected function onUpdate():void 
		{
			if (!currentAnimation) return;
			
			nAnimationTimer += Clock.deltaTime;
			if (nAnimationTimer >= nFrameTime)
			{
				switch(currentAnimationType)
				{
					case CMGAnimationType.ANIMATION_LOOP:
					case CMGAnimationType.ANIMATION_ONE:
						frameIndex += 1;
						break;
					
					case CMGAnimationType.ANIMATION_PINGPONG:
						if (!bPingPong)
						{
							frameIndex += 1;
						}
						else
						{
							frameIndex -= 1;
						}
						break;
				}
				nAnimationTimer = 0.0;
			}
		}
		
		protected function onAnimationCycle():void
		{
			dispatchEvent(new Event(EVENT_ANIMATION_CYCLE));
		}
		
		protected function onAnimationFinished():void
		{
			dispatchEvent(new Event(EVENT_ANIMATION_FINISH));
		}
		
		public function setFrame(frame_index:int):void
		{
			// update looks
			if (currentSprite)
			{
				removeChild(currentSprite);
			}
			currentSprite = new Bitmap(_spriteSheet.getSpriteByNumber(frame_index));
			addChild(currentSprite);
		}
		
		/////////////////////////////////////////////////////// Accessors
		private function get frameIndex():int
		{
			return iFrameIndex;
		}
		
		private function set frameIndex(value:int):void
		{
			// TODO: create ping-pong animation
			if (currentAnimationType == CMGAnimationType.ANIMATION_LOOP)
			{
				iFrameIndex = value;
				if (iFrameIndex >= currentAnimationFrames.length)
				{
					iFrameIndex = 0;
					onAnimationCycle();
				}
			}
			else if (currentAnimationType == CMGAnimationType.ANIMATION_PINGPONG)
			{
				iFrameIndex = value;
				if (iFrameIndex >= currentAnimationFrames.length)				
				{
					iFrameIndex -= 1;
					onAnimationCycle();
					bPingPong = !bPingPong;
				}
				else if (iFrameIndex < 0)
				{
					iFrameIndex = 1;
					onAnimationCycle();
					bPingPong = !bPingPong;
				}
			}
			else if (currentAnimationType == CMGAnimationType.ANIMATION_ONE)
			{
				iFrameIndex = value;
				if (iFrameIndex >= currentAnimationFrames.length)
				{
					iFrameIndex = currentAnimationFrames.length - 1;
					onAnimationFinished();
					currentAnimation = null;
					bIsPlaying = false;
				}
			}
			
			// update looks
			if (currentSprite)
			{
				removeChild(currentSprite);
			}
			currentSprite = new Bitmap(_spriteSheet.getSpriteByNumber(currentAnimationFrames[iFrameIndex]));
			addChild(currentSprite);
		}
		
		////////////////////////////////////////////////////// Accessors
		public function get spriteSheet():CMGSpriteSheet
		{
			return _spriteSheet;
		}
		
		public function get currentBitmap():Bitmap
		{
			return currentSprite;
		}
	}

}