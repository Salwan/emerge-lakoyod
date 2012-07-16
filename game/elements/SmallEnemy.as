package game.elements 
{
	import cmg.Clock;
	import cmg.CMGSprite;
	import cmg.CMGSpriteSheet;
	import cmg.MovieClipEx;
	import cmg.SoundContainer;
	import cmg.StateMachine;
	import cmg.StateMachineEvent;
	import cmg.tweener.Tweener;
	import cmg.Utils;
	import cmg.World;
	import embed.Embed;
	import flash.display.Bitmap;
	import game.GameScene;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class SmallEnemy extends Enemy
	{		
		private var nSpeed:Number = 100.0;
		private var nDropSpeed:Number = 100.0;
		private var sndDie:SoundContainer;
		private var sndHit:SoundContainer;
		private var sndLand:SoundContainer;
		private var dropLocation:Point;
		
		public function SmallEnemy(drop_location:Point = null) 
		{
			dropLocation = drop_location;
			sndDie = new SoundContainer(Embed.Sound_SmallEnemy_Die);
			sndHit = new SoundContainer(Embed.Sound_Hit_1);
			var bmp:Bitmap = new Embed.Bitmap_Enemy_Small();
			var ss:CMGSpriteSheet = new CMGSpriteSheet(bmp.bitmapData);
			ss.defineSpriteSheet(64, 32, 32, "ensm");
			sprite = new CMGSprite(ss);
			sprite.defineAnimation("idle", [0, 1, 2, 3]);
			sprite.defineAnimation("walk", [8, 9, 10, 11]);
			sprite.defineAnimation("stomp", [16, 17, 18, 19, 20]);
			sprite.defineAnimation("hit", [24, 25]);
			sprite.defineAnimation("hurt", [32]);
			sprite.defineAnimation("die", [40, 41, 42, 43]);
			sprite.playAnimation("idle", 0.25);
			addChild(sprite);
		}
		
		override protected function onAdded():void 
		{
			super.onAdded();
		}
		
		////////////////////////////////////////////////// State Machine
		//--------------------------------------------------------------
		
		//////////////////////////////////////////////////////////// SPAWN
		override protected function onSpawnEnter(e:StateMachineEvent):void 
		{
			super.onSpawnEnter(e);
			sprite.y = -32;
			if (!dropLocation)
			{
				y = 335;				
				if (Utils.chance())
				{
					x = Utils.randomInt( -96, -32);
				}
				else
				{
					x =  Utils.randomInt(World.stageWidth + 32, World.stageWidth + 96);
				}				
				moveLocation = new Point(Utils.randomInt(100, World.stageWidth - 100), 335);
				_stateMachine.changeState("move");
			}
			else
			{
				x = dropLocation.x;
				y = dropLocation.y;
			}
		}
		
		override protected function onSpawnUpdate(e:StateMachineEvent):void 
		{
			super.onSpawnUpdate(e);
			y += nDropSpeed * Clock.deltaTime;
			if (GameScene.instance.collidesWithGround(x, y))
			{
				sndLand = new SoundContainer(Embed.Sound_Land);
				sndLand.play();
				_stateMachine.changeState("think");
			}
			
			if (y > World.stageHeight + 32)
			{
				kill();
			}
		}
		
		//////////////////////////////////////////////////////////// MOVE
		override protected function onMoveEnter(e:StateMachineEvent):void 
		{
			super.onMoveEnter(e);
			sprite.playAnimation("walk", 0.25);
		}
		
		override protected function onMoveUpdate(e:StateMachineEvent):void 
		{
			super.onMoveUpdate(e);
			var a:Array = GameScene.instance.findGround(x);			
			if (x < moveLocation.x)
			{
				x += nSpeed * Clock.deltaTime;
				y = Math.min(Number(a[0]) + 4, 335);
			}
			else if(x > moveLocation.x + 16)
			{
				x -= nSpeed * Clock.deltaTime;
				y = Math.min(Number(a[0]) + 4, 335);
			}
			else
			{
				_stateMachine.changeState("think");
			}
		}
		
		/////////////////////////////////////////////////////////// THINK
		override protected function onThinkEnter(e:StateMachineEvent):void 
		{
			super.onThinkEnter(e);
			sprite.playAnimation("idle", 0.25);
			var a:Array = GameScene.instance.findGround(x);
			y = Math.min(Number(a[0]) + 4, 335);
			if (MovieClipEx(a[1]).name == "cover")
			{
				_stateMachine.changeState("attack");
			}
			else
			{
				Tweener.addTween(this, { time:Utils.randomNumber(7.5, 25.0), onComplete:_thinkMove } );
			}
		}
		
		override protected function onThinkUpdate(e:StateMachineEvent):void 
		{
			super.onThinkUpdate(e);
			var a:Array = GameScene.instance.findGround(x);
			y = Math.min(Number(a[0]) + 4, 335);
		}
		
		private function _thinkMove():void		
		{
			moveLocation = new Point(Utils.randomInt(100, World.stageWidth - 100), 335);
			_stateMachine.changeState("move");
		}
		
		//////////////////////////////////////////////////////////// ATTACK
		private var _attack_hitSound:Number;
		
		override protected function onAttackEnter(e:StateMachineEvent):void 
		{
			super.onAttackEnter(e);
			sprite.playAnimation("hit", 0.25);
			_attack_hitSound = 0.25;
		}
		
		override protected function onAttackUpdate(e:StateMachineEvent):void 
		{
			super.onAttackUpdate(e);
			var a:Array = GameScene.instance.findGround(x);
			y = Math.min(Number(a[0]) + 4, 335);
			if (MovieClipEx(a[1]).name != "cover")
			{
				_stateMachine.changeState("think");
			}
			else
			{
				GameScene.instance.damage();
			}
			
			_attack_hitSound -= Clock.deltaTime;
			if (_attack_hitSound <= 0.0)
			{
				sndHit.play();
				_attack_hitSound = 0.5;
			}
		}
		
		//////////////////////////////////////////////////////////// DIE
		override protected function onDieEnter(e:StateMachineEvent):void 
		{
			super.onDieEnter(e);
			sndDie.play();
		}
		
	}

}