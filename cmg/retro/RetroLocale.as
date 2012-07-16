package cmg.retro 
{
	import cmg.collections.Map;
	/**
	 * Locale is the multi-language string constants container, it's a static class
	 * that doesn't change, string constants are set via the game itself.
	 * @author ZenithSal
	 */
	public class RetroLocale 
	{
		protected static var localeMap:Map = new Map();
		protected static var strActiveLocale:String;
		protected static var activeLocale:Map = null;
		
		public function RetroLocale() 
		{
			
		}
		
		public static function addLocale(code:String):void
		{
			localeMap.add(code, new Map());
			// activate first added locale
			if (localeMap.size == 1)
			{
				setLocale(code);
			}
		}
		
		public static function setLocale(code:String):void
		{
			activeLocale = localeMap.itemFor(code) as Map;
			strActiveLocale = code;
		}
		
		/*
		 * Adds string to locale.
		 */
		public static function addString(locale:String, id:String, value:String):void
		{
			Map(localeMap.itemFor(locale)).add(id, value);
		}
		
		/*
		 * Adds an Object of strings defined as: {locale:value, ...}
		 */
		public static function addStringGroup(id:String, values:Object):void
		{
			for(var locale:String in values)
			{
				Map(localeMap.itemFor(locale)).add(id, values[locale]);
			}
		}
		
		/*
		 * Gets string from active locale.
		 */
		public static function getString(id:String):String
		{
			return activeLocale.itemFor(id);
		}
		
		/////////////////////////////////////////////////////// Accessors
		public static function get currentLocale():String
		{
			return strActiveLocale;
		}
		
	}

}