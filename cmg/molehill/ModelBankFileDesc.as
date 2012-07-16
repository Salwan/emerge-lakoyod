package cmg.molehill 
{
	/**
	 * Description of a model bank file
	 * @author ZenithSal
	 */
	public class ModelBankFileDesc 
	{
		protected var mType:int;
		protected var mFile:String;
		
		public function ModelBankFileDesc(thefile:String, thetype:int) 
		{
			mFile = thefile;
			mType = thetype;
		}
		
		public function get file():String
		{
			return mFile;
		}
		
		public function get type():int
		{
			return mType;
		}
		
	}

}