package cmg.retro 
{
	import cmg.MovieClipEx;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class RetroEntity extends MovieClipEx
	{
		
		public function RetroEntity() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);	
			init();					
		}
		
		private function onAddedToStage(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			added();
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removed();
		}
		
		private function onEnterFrame(e:Event):void
		{
			update();
		}
		
		override protected function onFirstFrame():void 
		{
			firstframe();
		}
		
		protected function init():void
		{
			
		}
		
		protected function added():void
		{
			
		}
		
		protected function firstframe():void
		{
			
		}
		
		protected function update():void
		{
			
		}
		
		protected function removed():void
		{
			
		}
		
	}

}