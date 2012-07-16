package game.elements 
{
	import cmg.Clock;
	import cmg.CMGAnimationType;
	import cmg.CMGSprite;
	import cmg.CMGSpriteSheet;
	import cmg.MovieClipEx;
	import cmg.StateMachine;
	import cmg.StateMachineEvent;
	import cmg.tweener.Tweener;
	import cmg.Utils;
	import cmg.World;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.events.Event;
	import game.GameScene;
	import game.PixelCollider;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Arm extends PixelCollider
	{
		private var nEmergence:Number = 0.0;
		private var sprite:CMGSprite;
		private var _stateMachine:StateMachine;
		
		public function Arm() 
		{
		}
		
		override protected function onAdded():void 
		{
			var bmp:Bitmap = new Embed.Bitmap_Hand_Sheet();
			var ss:CMGSpriteSheet = new CMGSpriteSheet(bmp.bitmapData);
			ss.defineSpriteSheet(12, 400, 400, "arm");
			sprite = new CMGSprite(ss);
			sprite.defineAnimation("idle", [0, 1]);
			sprite.defineAnimation("struggle", [0, 1, 2]);
			sprite.defineAnimation("tofist", [3, 4, 5]);
			sprite.defineAnimation("push", [6, 7]);
			sprite.defineAnimation("punch", [9]);
			sprite.playAnimation("idle", 0.25, CMGAnimationType.ANIMATION_PINGPONG);
			sprite.x = -200;
			sprite.y = -400;
			addChild(sprite);
			
			//x = 400;
			//y = World.stageHeight + 300;
			//y = 295 + 400;
			
			bmpCollision = sprite.currentBitmap;
			visible = false;
			
			_stateMachine = new StateMachine("Arm");
			_stateMachine.addState("bound", { enter:onBoundEnter, update:onBoundUpdate, exit:onBoundExit, from:"*" } );
			_stateMachine.addState("struggle", { enter:onStruggleEnter, update:onStruggleUpdate, exit:onStruggleExit, from:"*" } );
			_stateMachine.addState("free", { enter:onFreeEnter, update:onFreeUpdate, exit:onFreeExit, from:"*" } );
			_stateMachine.initialState = "bound";
		}
		
		override protected function onUpdate():void 
		{
			_stateMachine.update();
			bmpCollision = sprite.currentBitmap;
		}
		
		public function ropeBreak():void
		{
			_stateMachine.changeState("struggle");
		}
		
		////////////////////////////////////////////////// Accessors
		public function get emergence():Number
		{
			return nEmergence;
		}
		
		/////////////////////////////////////////////// State Machine
		//-----------------------------------------------------------
		
		/////////////////////////////////////////////// BOUND
		private var _bound_TimeTillPush:Number;
		private var _bound_initialX:Number;
		private var _bound_initialY:Number;
		
		private function onBoundEnter(e:StateMachineEvent):void
		{
			sprite.addEventListener(CMGSprite.EVENT_ANIMATION_FINISH, _boundAnimFinish);
			sprite.playAnimation("idle", 0.25, CMGAnimationType.ANIMATION_PINGPONG);
			_bound_TimeTillPush = Utils.randomNumber(4.0, 11.0);
			_bound_initialX = x;
			_bound_initialY = y;
		}
		
		private function onBoundUpdate(e:StateMachineEvent):void
		{
			//var rx:Number = Utils.randomNumber( -3, 3);
			//var ry:Number = Utils.randomNumber( -1, 1);
			//x = _bound_initialX + rx;
			//y = _bound_initialY + ry;
			
			if (_bound_TimeTillPush > 0.0)
			{
				_bound_TimeTillPush -= Clock.deltaTime;
				if (_bound_TimeTillPush <= 0.0)
				{
					_bound_TimeTillPush = Utils.randomNumber(4.0, 11.0);
					sprite.playAnimation("push", 0.25, CMGAnimationType.ANIMATION_ONE);
				}
			}
		}
		
		private function onBoundExit(e:StateMachineEvent):void
		{
			sprite.removeEventListener(CMGSprite.EVENT_ANIMATION_FINISH, _boundAnimFinish);
		}
		
		private function _boundAnimFinish(e:Event):void
		{
			sprite.playAnimation("struggle", 0.25, CMGAnimationType.ANIMATION_PINGPONG);
		}
		
		/////////////////////////////////////////////// STRUGGLE
		private function onStruggleEnter(e:StateMachineEvent):void
		{
			sprite.addEventListener(CMGSprite.EVENT_ANIMATION_FINISH, _struggleAnimFinish);
			sprite.playAnimation("tofist", 0.25, CMGAnimationType.ANIMATION_ONE);
			Tweener.addTween(this, { time:0.75, y:349, transition:"linear" } );
			
			_bound_initialX = x;
			_bound_initialY = y;
		}
		
		private function onStruggleUpdate(e:StateMachineEvent):void
		{
			var rx:Number = Utils.randomNumber( -3, 3);
			var ry:Number = Utils.randomNumber( -1, 1);
			x = _bound_initialX + rx;
			y = _bound_initialY + ry;
		}
		
		private function onStruggleExit(e:StateMachineEvent):void
		{
			sprite.removeEventListener(CMGSprite.EVENT_ANIMATION_FINISH, _struggleAnimFinish);
		}
		
		private function _struggleAnimFinish(e:Event):void
		{
			sprite.removeEventListener(CMGSprite.EVENT_ANIMATION_FINISH, _struggleAnimFinish);
			_stateMachine.changeState("free");
		}
		
		////////////////////////////////////////////////// FREE
		private function onFreeEnter(e:StateMachineEvent):void
		{
			sprite.playAnimation("punch");
			Tweener.addTween(this, { time:5, x:400, y:417, transition:"linear" } );
			GameScene.instance.transition();
		}
		
		private function onFreeUpdate(e:StateMachineEvent):void
		{
			
		}
		
		private function onFreeExit(e:StateMachineEvent):void
		{
			
		}
		
	}

}