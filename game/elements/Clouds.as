package game.elements 
{
	import cmg.MovieClipEx;
	import cmg.tweener.Tweener;
	import cmg.Utils;
	import embed.Embed;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class Clouds extends MovieClipEx
	{
		private var _clouds:Vector.<Cloud>;
		private var iCloudCount:int = 3;
		private var _colors:Vector.<uint>;
		
		public function Clouds(colors:Array) 
		{
			_clouds = new Vector.<Cloud>();
			_colors = new Vector.<uint>();
			for (var s:String in colors)
			{
				_colors.push(colors[s]);
			}
			iCloudCount = _colors.length;
			var nStart:Number = -50;
			var nEnd:Number = -150;
			for (var i:int = 0; i < iCloudCount; ++i)
			{
				var c:Cloud = new Cloud(_colors[i]);
				c.y = Utils.lerp(nStart, nEnd, i / Number(iCloudCount));
				_clouds.push(c);
				addChild(c);
			}
		}
		
		public function goAway():void
		{
			Tweener.addTween(this, { time:1.0, y: -height - 1, transition:"linear", onComplete:kill } );
		}
		
	}

}