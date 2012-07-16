package cmg
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class LoaderQueueEvent extends Event
	{
		protected var mLoadedData:Dictionary = null;
		
		public function LoaderQueueEvent(loadedData:Dictionary) 
		{
			super(LoaderQueue.QUEUE_LOADING_COMPLETE);
			mLoadedData = loadedData;
		}
		
		public function get data():Dictionary
		{
			return mLoadedData;
		}
		
	}

}