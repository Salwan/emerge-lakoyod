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
	
	import flashx.textLayout.factory.StringTextLineFactory;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flash.text.engine.TextLine;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Salwan
	 */
	public class CMGTLFLabel extends Sprite
	{
		private var _textLines:Vector.<TextLine>;
		private var _textLayoutFormat:TextLayoutFormat;
		private var _text:String;

		public function CMGTLFLabel(font_name:String, font_size:Number = 16, font_color:uint = 0xffffff)  
		{
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
			
			_textLayoutFormat = new TextLayoutFormat();
			_textLayoutFormat.fontSize = font_size;
			_textLayoutFormat.direction = Direction.RTL;
			_textLayoutFormat.textAlign = TextAlign.RIGHT;
			_textLayoutFormat.color = font_color;
			_textLayoutFormat.fontFamily = font_name;
			_textLayoutFormat.fontLookup = FontLookup.EMBEDDED_CFF;
		}
		
		private function _onAddedToStage(e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false, 0, true);
			
			mouseEnabled = false;
			
			onInit();
			onAdded();
		}
		
		private function _onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
			
			onRemoved();
		}
		
		public function setScale(scale:Number):void
		{
			scaleX = scale;
			scaleY = scale;
		}
		
		public function setCenterPosition(pos_x:Number, pos_y:Number):void
		{
			x = pos_x - (width / 2.0) - 3;
			y = pos_y - (height / 2.0);
		}
		
		private function onNewLine(text_line:TextLine):void
		{
			_textLines.push(text_line);
			addChild(text_line);
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
			// Clear old
			if (_textLines && _textLines.length > 0)
			{
				for (var i:int = 0; i < _textLines.length; ++i)
				{
					removeChild(_textLines[i]);
				}
			}
			
			// Create new
			_textLines = new Vector.<TextLine>();
			_text = value;
			var factory:StringTextLineFactory = new StringTextLineFactory();
			factory.text = _text;
			factory.compositionBounds = new Rectangle(0, 0, World.stageWidth, 100);
			factory.spanFormat = _textLayoutFormat;
			factory.createTextLines(onNewLine);
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set textFilter(value:Object):void
		{
			var fa:Array = new Array(value);
			filters = fa;
		}
		
		public function set textFilters(value:Array):void
		{
			filters = value;
		}
	}
}