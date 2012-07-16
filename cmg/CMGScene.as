package cmg 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * Represents a single game scene.
	 * @author Salwan
	 */
	public class CMGScene extends MovieClip
	{		
		public function CMGScene() 
		{
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
		}
		
		private function _onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false, 0, true);
			addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);
			onInit();
			onAdded();
		}
		
		private function _onRemovedFromStage(e:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame, false);
			onRemoved();
		}
		
		private function _onEnterFrame(e:Event):void
		{
			onUpdate();
		}
		
		////////////////////////////////////////////////////// Callbacks
		protected function onInit():void
		{
			
		}
		
		protected function onAdded():void
		{
			
		}
		
		protected function onUpdate():void
		{
			
		}
		
		protected function onRemoved():void
		{
			
		}
		
		// Called when scene starts closing to transition to another scene
		protected function onClosing():void
		{
			
		}
		
	}

}