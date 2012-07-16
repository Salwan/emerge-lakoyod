package cmg.retro 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class RetroText extends TextField
	{
		
		public function RetroText(use_embedded_font:Boolean, font:String, size:Number, color:uint = 0xffffff, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false, align:String = TextFormatAlign.LEFT) 
		{
			super();
			this.embedFonts = use_embedded_font;
			var fmt:TextFormat = new TextFormat(font, size, color, bold, italic, underline, null, null, align);
			setTextFormat(fmt);
			defaultTextFormat = fmt;
		}
		
	}

}