package cmg.retro 
{
	import adobe.utils.CustomActions;
	import cmg.collections.Map;
	import cmg.EventDispatcherEx;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * Manages input and distributes events.
	 * @author ZenithSal
	 */
	public class RetroInput extends EventDispatcherEx
	{
		//public static const EVENT_KEYDOWN:String = "keydown";
		//public static const EVENT_KEYUP:String = "keyup";
		
		public static var Instance:RetroInput = null;
		
		protected var bEnabled:Boolean = true;
		protected var mKeysDown:Array;
		protected var mKeysUp:Array;
		
		public function RetroInput() 
		{
			Instance = this;
			mKeysDown = new Array();
			mKeysUp = new Array();
		}
		
		public function defineInputOnKeyDown(name:String, keys:Array):void
		{
			for (var i:String in keys)
			{
				mKeysDown[keys[i]] = name;
			}
		}
		
		public function defineInputOnKeyUp(name:String, keys:Array):void
		{
			for (var i:String in keys)
			{
				mKeysUp[keys[i]] = name;
			}
		}
		
		public function _onKeyDown(e:KeyboardEvent):void
		{
			if (bEnabled)
			{
				var action:String = mKeysDown[e.keyCode];
				if (action)
				{
					dispatchEvent(new Event(action));
				}
			}
		}
		
		public function _onKeyUp(e:KeyboardEvent):void
		{
			if (bEnabled)
			{
				var action:String = mKeysUp[e.keyCode];
				if (action)
				{
					dispatchEvent(new Event(action));
				}
			}
		}
		
		////////////////////////////////////////////////////// Accessors
		public function get enabled():Boolean
		{
			return bEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			bEnabled = value;
		}
	}

}