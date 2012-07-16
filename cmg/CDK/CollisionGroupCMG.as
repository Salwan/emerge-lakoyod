package cmg.CDK 
{
	/**
	 * CDK adapter for CMG collision system
	 * Performs per-pixel collision detection on specific elements
	 * @author Zenith
	 */
	import flash.display.DisplayObject;

	public class CollisionGroupCMG extends CDK
	{
		public function CollisionGroupCMG():void 
		{
			//for(var i:uint = 0; i < objs.length; i++)
			//{
			//	addItem(objs[i]);
			//}
		}
		
		public function checkCollisions(otherGroup:CollisionGroupCMG):Array
		{
			clearArrays();
			
			var s1:DisplayObject, s2:DisplayObject;
			for (var i:uint = 0; i < objectArray.length; ++i)
			{
				s1 = objectArray[i];
				
				for (var j:int = 0; j < otherGroup.objectArray.length; ++j)
				{
					s2 = otherGroup.objectArray[j];
					
					if (s1.hitTestObject(s2))
					{
						if ((s2.width * s2.height) > (s1.width * s1.height))
						{
							findCollisions(s1, s2);
						}
						else
						{
							var before:uint = objectCollisionArray.length;
							findCollisions(s2, s1);
							if (objectCollisionArray.length > before)
							{
								// flip last item to keep dispatcher/receiver relationship intact
								// notice this might affect correctness of angle (if I ever used it)
								var o1:DisplayObject = objectCollisionArray[objectCollisionArray.length - 1]["object1"];
								var o2:DisplayObject = objectCollisionArray[objectCollisionArray.length - 1]["object2"];
								objectCollisionArray[objectCollisionArray.length - 1]["object1"] = o2;
								objectCollisionArray[objectCollisionArray.length - 1]["object2"] = o1;
							}
						}
					}
				}
			}
			
			return objectCollisionArray;
		}
		
		public function checkCollisionsSelf():Array
		{
			clearArrays();
			
			var NUM_OBJS:uint = objectArray.length, item1:DisplayObject, item2:DisplayObject;
			for(var i:uint = 0; i < NUM_OBJS - 1; i++)
			{
				item1 = DisplayObject(objectArray[i]);
				
				for(var j:uint = i + 1; j < NUM_OBJS; j++)
				{
					item2 = DisplayObject(objectArray[j]);
					
					if(item1.hitTestObject(item2))
					{
						if((item2.width * item2.height) > (item1.width * item1.height))
						{
							objectCheckArray.push([item1,item2])
						}
						else
						{
							objectCheckArray.push([item2,item1]);
						}
					}
				}
			}
			
			NUM_OBJS = objectCheckArray.length;
			for(i = 0; i < NUM_OBJS; i++)
			{
				findCollisions(DisplayObject(objectCheckArray[i][0]), DisplayObject(objectCheckArray[i][1]));
			}
			
			return objectCollisionArray;
		}
	}

}