package cmg 
{
	import flash.display.Stage;
	import flash.system.System;
	import flash.utils.getTimer;
	
	/**
	 * Performance unit
	 * Includes a performance index rating 1 - 10
	 * - 1 being incredibly slow (~10% of default framerate)
	 * - 10 being incredibly fast (~100% of default framerate)
	 * This index can be used by different game components to
	 * tune up or down the details of the effect to run at best
	 * performance on any computer, even my netbook! :D
	 * @author Zenith
	 */
	public class Perform 
	{
		static public var DefaultFrameRate:int = 0;
		static public var ActualFrameRate:int = 0;
		static public var TimeDelta:Number = 0.0;
		static public var MemoryUsage:uint = 0;
		static public var PerformIndex:int = 10;
		static public var AveragePerformIndex:int = 10;
		
		protected var stage:Stage = null;
		protected var timeAccum:Number = 0.0;
		protected var frameCount:int = 0;
		protected var prevTime:int = 0;
		protected var piList:Vector.<Number> = null; 
		
		public function Perform(the_stage:Stage) 
		{
			stage = the_stage;
			Perform.DefaultFrameRate = the_stage.frameRate;
			Perform.MemoryUsage = System.totalMemory;
			piList = new Vector.<Number>();
		}
		
		public function tick():void
		{			
			var curTime:int = getTimer();
			var dt:Number = curTime - prevTime;
			prevTime = curTime;
			Perform.TimeDelta = dt / 1000.0;
			
			timeAccum += Perform.TimeDelta;
			frameCount += 1;
			
			if (timeAccum >= 1.0)
			{
				Perform.MemoryUsage = System.totalMemory;
				Perform.DefaultFrameRate = stage.frameRate;
				Perform.ActualFrameRate = frameCount;
				
				calculateIndex();
				timeAccum = 0.0;
				frameCount = 0;
			}
		}
		
		/**
		 * Averages last 10 readings (last 10 seconds)
		 */
		protected function calculateIndex():void
		{
			piList.push(ActualFrameRate / DefaultFrameRate);
			if (piList.length > 10)
			{
				piList.shift();
			}
			var sum:Number = 0.0;
			for (var i:int = 0; i < piList.length; ++i)
			{
				sum += piList[i];
			}
			Perform.PerformIndex = (sum / piList.length) * 10;
			Perform.AveragePerformIndex = Math.floor((Perform.AveragePerformIndex + Perform.PerformIndex) / 2);
		}
	}

}