package game.elements 
{
	import cmg.CMGAnimationType;
	import cmg.CMGSprite;
	import cmg.MovieClipEx;
	import cmg.StateMachine;
	import cmg.StateMachineEvent;
	import cmg.Utils;
	import cmg.World;
	import flash.events.Event;
	import flash.geom.Point;
	import game.GameScene;
	/**
	 * ...
	 * @author ...
	 */
	public class Enemy extends MovieClipEx
	{
		protected var sprite:CMGSprite;
		protected var _stateMachine:StateMachine;
		protected var moveLocation:Point;
		
		public function Enemy() 
		{
			
		}
		
		override protected function onAdded():void 
		{
			GameScene.instance.addEnemy(this);
		}
		
		override protected function onRemoved():void 
		{
			GameScene.instance.removeEnemy(this);
		}
		
		override protected function onInit():void 
		{
			super.onInit();
			_stateMachine = new StateMachine("enemy");
			_stateMachine.addState("spawn", { enter:onSpawnEnter, update:onSpawnUpdate, exit:onSpawnExit, from:"*" } );
			_stateMachine.addState("move", { enter:onMoveEnter, update:onMoveUpdate, exit:onMoveExit, from:"*" } );
			_stateMachine.addState("think", { enter:onThinkEnter, update:onThinkUpdate, exit:onThinkExit, from:"*" } );
			_stateMachine.addState("attack", { enter:onAttackEnter, update:onAttackUpdate, exit:onAttackExit, from:"*" } );
			_stateMachine.addState("die", { enter:onDieEnter, update:onDieUpdate, exit:onDieExit, from:"*" } );
			_stateMachine.initialState = "spawn";
		}
		
		override protected function onUpdate():void 
		{
			_stateMachine.update();
		}
		
		public function onMouseClick(mx:Number, my:Number):Boolean
		{
			if (hitTestPoint(mx, my) && _stateMachine.state != "die")
			{
				_stateMachine.changeState("die");
				return true;
			}
			return false;
		}
		
		public function justDie():void
		{
			_stateMachine.changeState("die");
		}
		
		////////////////////////////////////////////////////// State events
		//-----------------------------------------------------------------
		
		////////////////////////////////////////////////////// SPAWN
		protected function onSpawnEnter(e:StateMachineEvent):void
		{
			
		}
		
		protected function onSpawnUpdate(e:StateMachineEvent):void
		{
			
		}
		
		protected function onSpawnExit(e:StateMachineEvent):void
		{
			
		}
		
		////////////////////////////////////////////////////// MOVE
		protected function onMoveEnter(e:StateMachineEvent):void
		{
			
		}
		
		protected function onMoveUpdate(e:StateMachineEvent):void
		{
			
		}
		
		protected function onMoveExit(e:StateMachineEvent):void
		{
			
		}
		
		////////////////////////////////////////////////////// THINK
		protected function onThinkEnter(e:StateMachineEvent):void
		{
			
		}
		
		protected function onThinkUpdate(e:StateMachineEvent):void
		{
			
		}
		
		protected function onThinkExit(e:StateMachineEvent):void
		{
			
		}
		
		////////////////////////////////////////////////////// ATTACK
		protected function onAttackEnter(e:StateMachineEvent):void
		{
			
		}
		
		protected function onAttackUpdate(e:StateMachineEvent):void
		{
			
		}
		
		protected function onAttackExit(e:StateMachineEvent):void
		{
			
		}
		
		////////////////////////////////////////////////////// DIE
		protected function onDieEnter(e:StateMachineEvent):void
		{
			sprite.addEventListener(CMGSprite.EVENT_ANIMATION_FINISH, _dieNow);
			sprite.playAnimation("die", 0.25, CMGAnimationType.ANIMATION_ONE);
		}
		
		private function _dieNow(e:Event):void
		{
			kill();
		}
		
		protected function onDieUpdate(e:StateMachineEvent):void
		{
			
		}
		
		protected function onDieExit(e:StateMachineEvent):void
		{
			
		}
	}

}