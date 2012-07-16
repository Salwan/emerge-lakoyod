package cmg 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.engine.FontLookup;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	
	/**
	 * ...
	 * @author Salwan
	 */
	public class CMGLabel extends Sprite
	{
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		public function CMGLabel(text_format:TextFormat = null, text_field_autosize:String = TextFieldAutoSize.LEFT, text_field_size:Point = null) 
		{
			if (text_format)
			{
				textFormat = text_format;
			}
			else
			{
				textFormat = new TextFormat("arial", 12, 0xffffff, false, false, false);
			}
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
			
			textField = new TextField();
			textField.autoSize = text_field_autosize;
			textField.embedFonts = true;
			textField.textColor = textFormat.color as uint;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
			textField.mouseEnabled = false;
			textField.selectable = false;
			textField.wordWrap = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			
			if (text_field_size)
			{
				textField.width = text_field_size.x;
				textField.height = text_field_size.y;
			}
			
			addChild(textField);
			mouseEnabled = false;
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
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false);
			
			onRemoved();
		}
		
		private function _onEnterFrame(e:Event):void
		{
			onUpdate();
		}
		
		public function setScale(scale:Number):void
		{
			scaleX = scale;
			scaleY = scale;
		}
		
		public function setCenterPosition(pos_x:Number, pos_y:Number):void
		{
			x = pos_x - (textField.textWidth / 2.0) - 3;
			y = pos_y - (textField.textHeight / 2.0);
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
		
		protected function onEnabled():void
		{
			
		}
		
		protected function onDisabled():void
		{
			
		}
		
		protected function onUpdate():void
		{
			
		}
		
		//////////////////////////////////////////////// Accessors
		public function set text(value:String):void
		{
			textField.text = value;
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function set textFilter(value:Object):void
		{
			var fa:Array = new Array(value);
			textField.filters = fa;
		}
		
		public function set textFilters(value:Array):void
		{
			textField.filters = value;
		}
		
		public function get textObject():TextField
		{
			return textField;
		}
	}
}