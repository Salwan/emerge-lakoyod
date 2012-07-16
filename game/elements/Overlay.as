package game.elements 
{
	import cmg.MovieClipEx;
	import cmg.World;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class Overlay extends MovieClipEx
	{
		private var bmpOverlay:Bitmap;
		
		public function Overlay() 
		{
			
		}
		
		override protected function onAdded():void 
		{		
			bmpOverlay = new Embed.Bitmap_Overlay();
			bmpOverlay.blendMode = BlendMode.OVERLAY;
			bmpOverlay.alpha = 0.05;
			addChild(bmpOverlay);
		}
		
	}

}