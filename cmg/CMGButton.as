package cmg 
{
	import cmg.tweener.Tweener;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Salwan
	 */
	public class CMGButton extends Sprite
	{
		public static const BUTTON_CLICKED:String = "btnclicked";
		
		private var _bEnabled:Boolean;
		
		public function CMGButton() 
		{
			_bEnabled = true;
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
		}
		
		private function _onAddedToStage(e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, _onMouseRollOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, _onMouseRollOut, false, 0, true)
			addEventListener(MouseEvent.CLICK, _onMouseClick, false, 0, true);
			
			onInit();
			onAdded();
		}
		
		private function _onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false);
			removeEventListener(MouseEvent.ROLL_OVER, _onMouseRollOver, false);
			removeEventListener(MouseEvent.ROLL_OUT, _onMouseRollOut, false)
			removeEventListener(MouseEvent.CLICK, _onMouseClick, false);
			
			onRemoved();
		}
		
		private function _onMouseRollOver(e:MouseEvent):void
		{
			if (_bEnabled)
			{
				onHoverEnter();
			}
		}
		
		private function _onMouseRollOut(e:MouseEvent):void
		{
			if (_bEnabled)
			{
				onHoverLeave();
			}
		}
		
		private function _onMouseClick(e:MouseEvent):void
		{
			if (_bEnabled)
			{
				dispatchEvent(new Event(BUTTON_CLICKED));
				onClick();
				e.stopPropagation();
			}
		}
		
		public function setScale(scale:Number):void
		{
			scaleX = scale;
			scaleY = scale;
		}
		
		protected function onInit():void
		{
			
		}
		
		protected function onAdded():void
		{
			
		}
		
		protected function onRemoved():void
		{
			
		}
		
		protected function onHoverEnter():void
		{
			
		}
		
		protected function onHoverLeave():void
		{
			
		}
		
		protected function onClick():void
		{
			
		}
		
		protected function onEnabled():void
		{
			
		}
		
		protected function onDisabled():void
		{
			
		}
		
		//////////////////////////////////////////////// Accessors
		public function set buttonEnabled(value:Boolean):void
		{
			if (value != _bEnabled)
			{
				_bEnabled = value;
				if (_bEnabled)
				{
					onEnabled();
				}
				else 
				{
					onDisabled();
				}
			}
		}
		
		public function get buttonEnabled():Boolean
		{
			return _bEnabled;
		}
	}

}