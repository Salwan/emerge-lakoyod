package cmg 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	/**
	 * Provides extra functionality by keeping track of all registered events
	 * @author ZenithSal
	 */
	public class EventDispatcherEx extends EventDispatcher
	{
		protected var _eventList:Vector.<Object> = null;
		
		public function EventDispatcherEx(target:IEventDispatcher = null)
		{
			_eventList = new Vector.<Object>();
			super(target);
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
		 * Removes all registered events
		 */
		public function removeAllEvents(exclude:String = null):void
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
		
	}

}