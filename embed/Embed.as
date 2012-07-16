package embed 
{
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class Embed 
	{
		////////////////////////////////////////////////// Fonts
		[Embed(source = "fonts/ae_AlYarmook.ttf", fontName = "game_font", embedAsCFF = "true", fontStyle = "Regular", mimeType = "application/x-font")]
		public static var Font_Game:Class;
		
		////////////////////////////////////////////////// HUD Bitmaps
		[Embed(source = "mouse/cursor.png")]
		public static var Bitmap_Cursor:Class;
		
		[Embed(source = "mouse/cursor_disabled.png")]
		public static var Bitmap_Cursor_Disabled:Class;
		
		[Embed(source = "mouse/circle.png")]
		public static var Bitmap_Circle:Class;
		
		////////////////////////////////////////////////// Music
		[Embed(source = "sfx/earth.mp3")]
		public static var Sound_Earth:Class;
		
		//---------------------------------------------------------
		///////////////////////////////////////////////// Game
		
		///////////////////////////////////////////////// Bitmaps
		[Embed(source = "bitmaps/clouds.png")]
		public static var Bitmap_Cloud:Class;
		
		[Embed(source = "bitmaps/overlay_pattern.jpg")]
		public static var Bitmap_Overlay:Class; 
		
		[Embed(source = "bitmaps/basic_ground.png")]
		public static var Bitmap_Ground:Class;
		
		[Embed(source = "bitmaps/enemy_small.png")]
		public static var Bitmap_Enemy_Small:Class;
		
		[Embed(source = "bitmaps/hand_sheet.png")]
		public static var Bitmap_Hand_Sheet:Class;
		
		[Embed(source = "bitmaps/cover_ss.png")]
		public static var Bitmap_Cover_SpriteSheet:Class;
		
		[Embed(source = "bitmaps/cover.png")]
		public static var Bitmap_Cover:Class;
		
		[Embed(source = "bitmaps/action_circle.png")]
		public static var Bitmap_ActionCircle:Class;
		
		[Embed(source = "bitmaps/action_buildup_circle.png")]
		public static var Bitmap_ActionCircle_Buildup:Class;
		
		[Embed(source = "bitmaps/text.png")]
		public static var Bitmap_ActionText:Class;
		
		[Embed(source = "bitmaps/circle_built.png")]
		public static var Bitmap_ActionCircle_Built:Class;
		
		[Embed(source = "bitmaps/ropes_ss.png")]
		public static var Bitmap_Rope_SpriteSheet:Class;
		
		[Embed(source = "bitmaps/green_ground.png")]
		public static var Bitmap_GreenGround:Class;
		
		///////////////////////////////////////////////// SFX
		[Embed(source = "sfx/boomnom.mp3")]
		public static var Sound_BoomNom:Class;
		
		[Embed(source = "sfx/earthquake.mp3")]
		public static var Sound_EarthQuake:Class;
		
		[Embed(source = "sfx/thunder.mp3")]
		public static var Sound_Thunder:Class;
		
		[Embed(source = "sfx/small_soldier_die.mp3")]
		public static var Sound_SmallEnemy_Die:Class;
		
		[Embed(source = "sfx/hit1.mp3")]
		public static var Sound_Hit_1:Class;
		
		[Embed(source = "sfx/land.mp3")]
		public static var Sound_Land:Class;
		
		[Embed(source = "sfx/warcry.mp3")]
		public static var Sound_WarCry:Class;
		
		[Embed(source = "sfx/tear.mp3")]
		public static var Sound_Tear:Class;
		
		[Embed(source = "sfx/rope_snap.mp3")]
		public static var Sound_RopeSnap:Class;
		
		//---------------------------------------------------------
		
		public function Embed() 
		{
			
		}
		
	}

}