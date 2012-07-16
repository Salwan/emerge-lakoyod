package cmg
{
	import adobe.utils.CustomActions;
	import cmg.CDK.CollisionGroupCMG;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.display.Stage;
	
	/**
	 * Manages game collisions.
	 * - Define collision groups and add elements to each group ("enemies", "player", "projectiles", etc...)
	 * - Define collision relationships between groups, and one of 4 different techniques
	 * Collision system handles event dispatching via flash events.
	 * MovieClipEx elements automatically clean-up their collision relationships when they are removed.
	 * No CCD support yet.
	 * @author Zenith
	 */
	public class Collisions extends EventDispatcher
	{
		public static const COLLIDE_BOX:int = 0; // Bounding-box/Hitbox collision detection link 
		public static const COLLIDE_PERFECT:int = 1; // Pixel-perfect collision detection link (Expensive)
		public static const COLLIDE_POINT_BOX:int = 2; // Point-Box collision detection link (using hitPoint or object position)
		public static const COLLIDE_POINT_AREA:int = 3; // Point-Area collision detection link (using hitPoint or object position)
		
		protected static var groups:Dictionary = null;
		protected static var groupLinks:Array = null;
		
		public function Collisions() 
		{
			Collisions.initStaticObject();
			trace("Collision System Initialized");
		}
		
		public static function cleanup():void
		{
			// Remove all connections to all elements
			groups = new Dictionary(true);
			groupLinks = new Array();
		}
		
		public function dump():void
		{
			trace("Collisions Info:");
			for (var indx:String in groups)
			{
				trace("- Group: \"" + indx + "\": has " + groups[indx].objectArray.length + " registered elements");
			}
			
			for (var i:int = 0; i < groupLinks.length; ++i)
			{
				trace("- Collision link: " + groupLinks[i]["g1"] + " -> " + groupLinks[i]["g2"] + "(" + groupLinks[i]["ct"] + ")");
			}
		}
		
		/**
		 * Runs the collision system on registered groups/elements.
		 */
		public function process():void
		{
			var i:uint, j:uint, k:uint;
			var s1:DisplayObject, s2:DisplayObject;
			var h1:DisplayObject, h2:DisplayObject;
			var spr:Sprite;
			var p1:Point, p2:Point;
			var ce:CollisionEvent;
			
			for (i = 0; i < Collisions.groupLinks.length; ++i)
			{
				var g1:String = Collisions.groupLinks[i]["g1"]; // dispatcher
				var g2:String = Collisions.groupLinks[i]["g2"]; // receiver
				var ct:int = Collisions.groupLinks[i]["ct"];
				
				// Bounding-box collisions, uses hitBox from MovieClipEx if it's available
				if (ct == COLLIDE_BOX)
				{					
					for (j = 0; j < Collisions.groups[g1].objectArray.length; ++j)
					{
						s1 = Collisions.groups[g1].objectArray[j];
						for (k = 0; k < Collisions.groups[g2].objectArray.length; ++k)
						{
							s2 = Collisions.groups[g2].objectArray[k];
							
							// Use hitBox if it's defined
							h1 = s1.hasOwnProperty("hitBox") && s1["hitBox"]? s1["hitBox"] : s1;
							h2 = s2.hasOwnProperty("hitBox") && s2["hitBox"]? s2["hitBox"] : s2;
							
							if (h1.hitTestObject(h2))
							{
								// custom event class (CollisionEvent) that holds group info
								ce = new CollisionEvent(g1, s1);
								s2.dispatchEvent(ce);
							}
						}
					}
				}
				// Pixel-perfect collision detection (Expensive)
				else if(ct == COLLIDE_PERFECT)
				{
					// Check pixel-perfect collision
					var ca:Array = Collisions.groups[g1].checkCollisions(Collisions.groups[g2]);
					for (j = 0; j < ca.length; ++j)
					{
						ce = new CollisionEvent(g1, ca[j]["object1"]);
						ca[j]["object2"].dispatchEvent(ce);
					}
				}
				// Point->Area collision detection, hitPoint|position for point -> hitArea if it's available or the object itself
				else if (ct == COLLIDE_POINT_AREA)
				{
					for (j = 0; j < Collisions.groups[g1].objectArray.length; ++j)
					{
						s1 = Collisions.groups[g1].objectArray[j];
						for (k = 0; k < Collisions.groups[g2].objectArray.length; ++k)
						{
							s2 = Collisions.groups[g2].objectArray[k];
							
							// Use hitPoint if it's defined
							p1 = s1.hasOwnProperty("hitPoint") && s1["hitPoint"]? s1["hitPoint"] : new Point(s1.x, s1.y);
							h2 = s2;
							if (h2 is Sprite)
							{
								spr = h2 as Sprite;
								if (spr.hasOwnProperty("hitArea") && spr["hitArea"])
								{
									h2 = spr.hitArea;
								}
							}							
							p1 = s1.localToGlobal(p1);
							if (h2.hitTestPoint(p1.x, p1.y, true))
							{
								// custom event class (CollisionEvent) that holds group info
								ce = new CollisionEvent(g1, s1);
								s2.dispatchEvent(ce);
							}
						} 
					} // endfor
				} // endif
				// Point->Box collision detection, hitPoint|position for point -> hitBox from MovieClipEx if it's available
				else if (ct == COLLIDE_POINT_BOX)
				{
					for (j = 0; j < Collisions.groups[g1].objectArray.length; ++j)
					{
						s1 = Collisions.groups[g1].objectArray[j];
						for (k = 0; k < Collisions.groups[g2].objectArray.length; ++k)
						{
							s2 = Collisions.groups[g2].objectArray[k];
							
							// Use hitPoint if it's defined
							p1 = s1.hasOwnProperty("hitPoint") && s1["hitPoint"]? s1["hitPoint"] : new Point(s1.x, s1.y);
							h2 = s2.hasOwnProperty("hitBox") && s2["hitBox"]? s2["hitBox"] : s2;
							
							var rc:Rectangle = h2.getRect(cmg.World.theStage);
							if (rc.containsPoint(s1.localToGlobal(p1)))
							{
								// custom event class (CollisionEvent) that holds group info
								ce = new CollisionEvent(g1, s1);
								s2.dispatchEvent(ce);
							}
						} 
					} // endfor
				} // endif
			} // endfor
		} // endfunc
		
		protected static function initStaticObject():void
		{
			groups = new Dictionary(true);
			groupLinks = new Array();
		}
		
		public static function registerGroup(group_name:String):void
		{
			if (!groups) Collisions.initStaticObject();
			if (!groups.hasOwnProperty(group_name))
			{
				groups[group_name] = new CollisionGroupCMG();
				trace("Collisions: added new group \"" + group_name + "\"");
			}
		}
		
		public static function removeGroup(group_name:String):void 
		{
			if (groups.hasOwnProperty(group_name))
			{
				// TODO: Remove all connections to group
				delete groups[group_name];
			}
		}
		
		/**
		 * Sets collision detection between 2 registered groups (one way registerable events)
		 * @param	group1_dispatcher group the dispatches events
		 * @param	group2_receiver group the receives collision event
		 * @param	use_hitbox if true, collision uses .hitBox if it's available, otherwise bounding-box (faster)
		 * 			false uses pixel-based collision via CDK (slower, use only where it's necessary)
		 */
		public static function setCollision(group1_dispatcher:String, group2_receiver:String, collision_type:int = Collisions.COLLIDE_BOX):void
		{
			// groups exist?
			if (!groups.hasOwnProperty(group1_dispatcher) || !groups.hasOwnProperty(group2_receiver))
			{
				trace("[ERROR] Collisions.setCollision: a given group is not registered (" + group1_dispatcher + "->" + group2_receiver + ")");
				return;
			}
			// collisions link already exists?
			for (var i:int = 0; i < groupLinks.length; ++i )
			{
				if (groupLinks[i]["g1"] == group1_dispatcher && groupLinks[i]["g2"] == group2_receiver)
				{
					//// update it's info
					trace("[NOTE] Collisions.setCollision: group link already exists, updating (" + group1_dispatcher + "->" + group2_receiver + ")");
					groupLinks[i]["ct"] = collision_type;
					return;
				}
			}
			// collisions link doesn't exist?
			//// create new one
			//trace("[NOTE] Collisions.setCollision: new group link (" + group1_dispatcher + "->" + group2_receiver + ")");
			var obj:Object = new Object();
			obj["g1"] = group1_dispatcher;
			obj["g2"] = group2_receiver;
			obj["ct"] = collision_type;
			groupLinks.push(obj);
		}
		
		/**
		 * Removes collision detection between 2 registered groups
		 * @param	group1_dispatcher
		 * @param	group2_receiver
		 */
		public static function removeCollision(group1_dispatcher:String, group2_receiver:String):void
		{
			// groups exist?
			if (!groups.hasOwnProperty(group1_dispatcher) || !groups.hasOwnProperty(group2_receiver))
			{
				trace("[ERROR] Collisions.setCollision: a given group is not registered (" + group1_dispatcher + "->" + group2_receiver + ")");
				return;
			}
			
			// Search for collision link
			for (var i:int = 0; i < groupLinks.length; ++i )
			{
				if (groupLinks[i]["g1"] == group1_dispatcher && groupLinks[i]["g2"] == group2_receiver)
				{
					//// remove
					groupLinks.splice(i, 1);
					return;
				}
			}
			
			// Collision link doesn't exist
			//trace("[NOTE] Collisions.removeCollision: given collision link doesn't exist (" + group1_dispatcher + "->" + group2_receiver + ")");
		}
		
		// Registers for a collision listener, when a collision takes place an event is dispatched to handle collisions
		public static function addElement(group_name:String, sprite:DisplayObject):void
		{
			if (!groups.hasOwnProperty(group_name))
			{
				CONFIG::debug 
				{
					throw new Error("Collisions.addElement(): used group that wasn't registered.");
				}
				registerGroup(group_name);
			}
			groups[group_name].objectArray.push(sprite);
			//trace("Collisions: added element " + sprite + " instance name \"" + sprite.name + "\"");
		}
		
		/**
		 * Remove element from specified group.
		 * @param	group_name
		 * @param	sprite
		 */
		public static function removeElement(group_name:String, sprite:DisplayObject):void 
		{
			if (groups.hasOwnProperty(group_name))
			{
				var indx:int = -1;
				while ((indx = groups[group_name].objectArray.indexOf(sprite)) > -1)
				{
					groups[group_name].objectArray.splice(indx, 1);
					//trace("Collisions: removed element " + sprite + " instance name \"" + sprite.name + "\"");
				}
			}
		}
		
		/**
		 * removes everything sprite is used in (use it before you remove sprite from scene)
		 * @param	sprite
		 */
		public static function removeElementAll(sprite:DisplayObject):void 
		{
			for (var p:String in groups)
			{
				removeElement(p, sprite);
			}
		}
		
		/*
		 * removes all elements in a group.
		 * @param 	group_name
		 */
		public static function clearGroup(group_name:String):void
		{
			if (groups.hasOwnProperty(group_name))
			{
				groups[group_name].objectArray = new Array();
			}
		}
	}

}