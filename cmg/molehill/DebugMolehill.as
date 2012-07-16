package cmg.molehill 
{
	import cmg.tweener.Tweener;
	import cmg.World;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * Shows messages on screen in case of errors in molehill.
	 * @author ZenithSal
	 */
	public class DebugMolehill extends MovieClip
	{
		protected var mText:TextField = null;
		protected var isLocked:Boolean = false;
		
		public function DebugMolehill() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			graphics.beginFill(0x505050, 0.5);
			graphics.drawRect(0, World.stageHeight - 15, World.stageWidth, 15);
			graphics.endFill();
			
			mText = new TextField();
			mText.width = World.stageWidth;
			mText.x = 0;
			mText.y = World.stageHeight - 15;
			var fmt:TextFormat = new TextFormat("Arial", 9, 0x80AAAAAA, true);
			fmt.align = TextFormatAlign.LEFT;
			mText.setTextFormat(fmt);
			mText.defaultTextFormat = fmt;
			mText.text = "Debug MovieClip ready.";
			addChild(mText);
			
			alpha = 0;
		}
		
		public function trace(text:String):void
		{
			if (!isLocked)
			{
				mText.text = text;
				Tweener.removeTweens(this);
				alpha = 0;
				Tweener.addTween(this, { time:0.25, alpha:1, transition:"linear" } );
				Tweener.addTween(this, { delay:2, time:1, alpha:0, transition:"linear" } );
			}
		}		
		
		public function traceError(text:String):void
		{
			if (!isLocked)
			{
				mText.textColor = 0xFF3333;
				mText.text = text;
				alpha = 1;
				isLocked = true;
			}
		}
		
	}

}