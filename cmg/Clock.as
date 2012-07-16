package cmg
{
	import flash.utils.getTimer;
	
	/**
	 * Centarlized system clock
	 * @author Zenith
	 */
	public class Clock 
	{
		public static var deltaTime:Number = 0.0; 		// Can be paused (use for game stuff;
		public static var sysDeltaTime:Number = 0.0; 	// Cannot be paused (use for system stuff)
		
		protected const highestDeltaTime:Number = 0.1;	// Any value higher than this, is trimmed for deltaTime
														// sysDeltaTime will not be processed
		
		protected var iPrevTime:int = 0;
		protected var isPaused:Boolean = false;
		protected var iPausedTime:int = 0;		
		protected var iSysPrevTime:int = 0;
		
		public function Clock() 
		{
			iPrevTime = getTimer();
			iSysPrevTime = iPrevTime;
		}
		
		public function tick():void
		{
			var curTime:int = getTimer();

			// System clock
			var dt:Number = curTime - iSysPrevTime;
			iSysPrevTime = curTime;
			Clock.sysDeltaTime = dt / 1000.0;
			
			// Game clock
			if (!isPaused)
			{				
				dt = curTime - iPrevTime;
				iPrevTime = curTime;
				Clock.deltaTime = Math.min(dt / 1000.0, highestDeltaTime);
			}
		}
		
		public function pause():void
		{
			isPaused = true;
			iPausedTime = getTimer();
			deltaTime = 0.0;
		}
		
		public function resume():void
		{
			isPaused = false;
			iPrevTime = iPausedTime;
		}
		
	}

}