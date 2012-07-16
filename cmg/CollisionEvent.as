package cmg
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	public class CollisionEvent extends Event
	{	
		public static const ON_COLLISION:String = "onCollision";
		public var otherGroup:String;
		public var otherSprite:DisplayObject;
		
		public function CollisionEvent(group:String, sprite:DisplayObject)
		{
			super(CollisionEvent.ON_COLLISION, false, false);
			otherGroup = group;
			otherSprite = sprite;
		}		
	}
}