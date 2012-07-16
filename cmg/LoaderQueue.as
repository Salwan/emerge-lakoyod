package cmg
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.LoaderInfo;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * Loads a bunch of files at once (instead of loading one at a time)
	 * @author ZenithSal
	 */
	public class LoaderQueue extends EventDispatcher
	{
		public static const QUEUE_LOADING_COMPLETE:String = "queue_loaded";
		
		protected var isLoading:Boolean = false;
		protected var doneLoading:Boolean = false;
		protected var mFileNames:Vector.<String> = null;
		protected var mLoadedData:Dictionary = null;
		protected var mCurrentFile:String;
		protected var mLoader:URLLoader = null;
		
		public function LoaderQueue() 
		{
			mFileNames = new Vector.<String>();
			mLoadedData = new Dictionary();
		}
		
		public function addFile(filename:String):void
		{
			if (!isLoading)
			{
				mFileNames.push(filename);
			}
		}
		
		public function loadAll():void
		{
			isLoading = true;
			loadNextFile();
		}
		
		protected function loadNextFile():void
		{
			if (mFileNames.length > 0)
			{
				mCurrentFile = mFileNames.pop();
				var request:URLRequest = new URLRequest(mCurrentFile);
				mLoader:URLLoader = new URLLoader();
				mLoader.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
				mLoader.load(request);
			}
			else
			{
				isLoading = false;
				doneLoading = true;
				dispatchEvent(new LoaderQueueEvent(mLoadedData));
			}
		}
		
		protected function onLoadComplete(e:Event):void
		{
			mLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
			mLoadedData[mCurrentFile] = e.target.data;
			loadNextFile();
		}
		
		public function get loadedData():Dictionary
		{
			return mLoadedData;
		}
		
		public function get isDataLoaded():Boolean
		{
			return doneLoading;
		}
	}

}