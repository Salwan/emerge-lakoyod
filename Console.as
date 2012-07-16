package  
{
	import cmg.DebugBar;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Salwan
	 */
	public class Console 
	{
		public static var debugBar:DebugBar;
		
		public function Console() 
		{
			
		}
		
		public static function log(message:String):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.log", message);
			}
			else
			{
				trace(message);
			}
		}		
	}

}