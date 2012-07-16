package cmg
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	/**
	 * Game world parameters and objects.
	 * @author Zenith
	 */
	public class World 
	{
		public static const LAYER_DEBUG:String = "debug";
		public static const LAYER_TOP:String = "top";
		public static const LAYER_ROOT:String = "root";
		public static const LAYER_MOUSE:String = "mouse";
		public static const LAYER_HUD:String = "hud";
		public static const LAYER_EFFECTS:String = "effects";
		public static const LAYER_FRONTGAME:String = "frontGame";
		public static const LAYER_GAME:String = "game";
		public static const LAYER_BACKGAME:String = "backGame";
		public static const LAYER_BACKGROUND:String = "background";
		
		public static var theStage:Stage = null;
		public static var main:DisplayObjectContainer = null;
		public static var stageWidth:int = 800.0;
		public static var stageHeight:int = 500.0;
		public static var gravity:Number = 150.0;
		public static var layers:Dictionary = new Dictionary(true);
		public static var globals:Dictionary = new Dictionary(true);
		public static var version:uint = 0;
		
		public function World(_main:DisplayObject) 
		{
			
		}
		
		public static function init(_main:DisplayObjectContainer, _width:Number, _height:Number, _version:uint = 0):void
		{
			main = _main;
			theStage = main.stage;
			stageWidth = _width;
			stageHeight = _height;
			version = _version;
			layers["debug"] = new Sprite();
			layers["top"] = new Sprite();
			layers["root"] = new Sprite();
			layers["mouse"] = new Sprite();
			layers["hud"] = new Sprite();
			layers["effects"] = new Sprite();
			layers["frontGame"] = new Sprite();
			layers["game"] = new Sprite();
			layers["backGame"] = new Sprite();
			layers["background"] = new Sprite();
	
			main.addChild(layers.background);
			main.addChild(layers.backGame);
			main.addChild(layers.game);
			main.addChild(layers.frontGame);
			main.addChild(layers.effects);
			main.addChild(layers.hud);
			main.addChild(layers.mouse);
			main.addChild(layers.root);
			main.addChild(layers.top);
			main.addChild(layers.debug);
		}
		
		public static function addChildTo(layer:String, child:DisplayObject):void
		{
			Sprite(layers[layer]).addChild(child);
		}
		
		public static function removeChildFrom(layer:String, child:DisplayObject):void
		{
			Sprite(layers[layer]).removeChild(child);
		}
		
		public static function getLayer(layer:String):Sprite
		{
			return Sprite(layers[layer]);
		}
		
		public static function dump():void
		{
			trace("World Parameters");
			trace("- Stage Width:  " + World.stageWidth);
			trace("- Stage Height: " + World.stageHeight);
			trace("- Gravity:      " + World.gravity);
		}
		
		////////////////////////////////////////////// Accessors
		
	}

}