package cmg.molehill 
{
	import cmg.tweener.Tweener;
	import cmg.World;
	import flash.system.System;
	import flash.system.Capabilities;
	import flash.system.ApplicationDomain;
	import com.adobe.utils.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import flash.events.*;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	/**
	 * Manages molehill high level operations.
	 * @author ZenithSal
	 */
	public class Molehill extends MovieClip
	{
		public static var context:Context3D = null;
		
		protected var context3d:Context3D = null;
		protected var mcDebug:DebugMolehill = null;
		
		public function Molehill() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		protected function init():void
		{
			mcDebug = new DebugMolehill();
			addChild(mcDebug);
			
			trace("__________________________");
			trace("CMG:Molehill Initializing \\");
			var hasStage3D:Boolean = ApplicationDomain.currentDomain.getDefinition("flash.display.Stage3D");
			trace("- Stage3D found: " + hasStage3D.toString());
			
			if (hasStage3D)
			{
				stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated, false, 0, true);
				stage.stage3Ds[0].addEventListener(ErrorEvent.ERROR, onStage3DError, false, 0, true);
				stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO);
			}
			else
			{
				mcDebug.traceError('Flash 11 Required. Your version: ' + Capabilities.version
				              + ' This game uses Stage3D. Please upgrade to Flash 11');
			}
			
		}
		
		protected function onStage3DError(e:Event):void
		{
			stage.stage3Ds[0].removeEventListener(ErrorEvent.ERROR, onStage3DError);
			mcDebug.visible = true;
			mcDebug.traceError('Embed Error Detected! you have hardware 3D turned OFF. Is wmode=direct in the html?');
		}
		
		protected function onContext3DCreated(e:Event):void
		{
			stage.stage3Ds[0].removeEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var stage3d:Stage3D = Stage3D(e.currentTarget);
			context3d = stage3d.context3D;
			context = context3d;
			
			if (context3d == null)
			{
				mcDebug.traceError("No Context3D found! Driver problem?");
			}
			else
			{
				if (context3d.driverInfo == Context3DRenderMode.SOFTWARE || context3d.driverInfo.indexOf('oftware') > -1)
				{
					mcDebug.traceError('Embed Error Detected! you have hardware 3D turned OFF. Is wmode=direct in the html?');
				}
				else
				{	
					context3d.configureBackBuffer(World.stageWidth, World.stageHeight, 0, true);
					context3d.enableErrorChecking = false;
					CONFIG::debug
					{
						context3d.enableErrorChecking = true;
					}
					
					mcDebug.trace("Molehill was initialized successfully, driver: " + context3d.driverInfo + " debug mode: " + context3d.enableErrorChecking);
					
					trace("Molehill Initialized");
					
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
	}

}