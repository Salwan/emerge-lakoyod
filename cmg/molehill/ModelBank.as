package cmg.molehill 
{
	import cmg.collections.Map;
	import cmg.LoaderQueue;
	import cmg.LoaderQueueEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * Responsible for managing model files/textures etc
	 * - Can load obj + mtl + textures
	 * - Using the MeshParser, it can parse the files and create the Mesh object
	 * (future) - transparent support for embedded data required at release time
	 * @author ZenithSal
	 */
	public class ModelBank extends EventDispatcher
	{
		public static const BANK_LOADING_COMPLETE:String = "mb_complete";
		
		protected var contentBank:Map = null;
		protected var loadedRawData:Dictionary = null; // TODO get rid of this because it's temp
		protected var loadedProcessedData:Dictionary = null;
		protected var iItemCount:int = 0;
		protected var mLoaderQueue:LoaderQueue = null;
		
		public function ModelBank() 
		{
			contentBank = new Map();
		}
		
		/*
		 * type is in ModelBankFileType object.
		 */
		public function addFile(file:String, type:int):void
		{
			var desc:ModelBankFileDesc = new ModelBankFileDesc(file, type);
			contentBank.add(file, desc);
		}
		
		public function loadAll():void
		{
			// Load the stuff
			mLoaderQueue = new LoaderQueue();
			var files:Array = contentBank.toArray();
			for (var i:String in files)
			{
				mLoaderQueue.addFile(ModelBankFileDesc(files[i]).file);
			}
			mLoaderQueue.addEventListener(LoaderQueue.QUEUE_LOADING_COMPLETE, onQueueLoaded, false, 0, true);
			mLoaderQueue.loadAll();
		}
		
		protected function onQueueLoaded(e:LoaderQueueEvent):void
		{
			if (mLoaderQueue)
			{
				mLoaderQueue.removeEventListener(LoaderQueue.QUEUE_LOADING_COMPLETE, onQueueLoaded);
				mLoaderQueue = null;
			}
			
			// Convert data into useful format for usage
			// - Iterate over loaded data
			loadedRawData = e.data;
			for (var k:Object in loadedRawData)
			{
				iItemCount += 1;
				trace("ModelBank loaded: " + String(k));
				
				// - Based on type, create a useful representation
				switch(ModelBankFileDesc(contentBank.itemFor(k)).type)
				{
					case ModelBankFileType.MBFT_GENERIC:
						// store it as is
						loadedProcessedData[k] = loadedRawData[k];
						break;
					
					case ModelBankFileType.MBFT_MATERIAL:
					case ModelBankFileType.MBFT_OBJ_MODEL:
						// store it as string
						loadedProcessedData[k] = String(loadedRawData[k]);
						break;
						
					case ModelBankFileType.MBFT_TEXTURE:
						// TODO store it as texture
						loadedProcessedData[k] = loadedRawData[k];
						break;
				}
				// - Store processed data
			}
			
			// clean up
			loadedRawData = null;
			
			// Dispatch load complete event
			dispatchEvent(new Event(BANK_LOADING_COMPLETE, false, false));
		}
		
		public function get itemCount():int
		{
			return iItemCount;
		}
		
	}

}