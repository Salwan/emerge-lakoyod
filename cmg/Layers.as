package cmg 
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	/**
	 * Manages game child layers
	 * @author ZenithSal
	 */
	public class Layers 
	{
		protected static var mLayers:Dictionary = new Dictionary(false);
		
		public function Layers() 
		{
			
		}
		
		public static function addLayer(name:String, object:DisplayObject):void
		{
			mLayers[name] = object;
		}
		
		public static function removeLayer(name:String):void
		{
			if (mLayers.hasOwnProperty(name))
			{
				delete mLayers[name];
			}
		}
		
		public static function getLayer(name:String):DisplayObject
		{
			if (mLayers.hasOwnProperty(name))
			{
				return mLayers[name];
			}
			else
			{
				throw new Error("Layer \"", name, "\" does not exist");
				return null;
			}
		}
		
	}

}