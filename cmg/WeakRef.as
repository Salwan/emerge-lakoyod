package cmg 
{
	import flash.utils.Dictionary;
	
	/**
	 * WeakRef is a weak container of objects, once the garbage collector dispose of
	 * the original object, WeakRef will return null.
	 * It uses Dictionary weak keys to acheive this goal, a hack of sorts.
	 * TODO: find a way to optimize it, right now every ref equals one Dictionary object
	 * @author Zenith
	 */
	public class WeakRef 
	{
		protected var refDict:Dictionary = null;
		
		public function WeakRef(obj:*) 
		{
			refDict = new Dictionary(true);
			refDict[obj] = 1;
		}
		
		public function get():*
		{
			for (var key:* in refDict)
			{
				return key;
			}
			return null;
		}
		
	}

}