package game 
{
	import cmg.Clock;
	import cmg.CMGLabel;
	import cmg.CMGScene;
	import cmg.CMGTLFLabel;
	import cmg.Keys;
	import game.effects.CircleBuilt;
	import game.elements.MediumEnemy;
	import game.elements.Ropes;
	import game.hud.Action;
	import cmg.SoundContainer;
	import cmg.StateMachine;
	import cmg.StateMachineEvent;
	import cmg.tweener.Tweener;
	import cmg.Utils;
	import cmg.World;
	import embed.Embed;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import game.effects.DarknessMask;
	import game.effects.Lightening;
	import game.effects.LighteningMask;
	import game.elements.Arm;
	import game.elements.Background;
	import game.elements.Clouds;
	import game.elements.Cover;
	import game.elements.Enemy;
	import game.elements.Ground;
	import game.elements.Overlay;
	import game.elements.SmallEnemy;
	import game.hud.Circle;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ZenithSal
	 */
	public class GameScene extends CMGScene
	{
		public static var instance:GameScene = null;
		
		private var _patternOverlay:Overlay;
		private var _background:Background;
		private var _arm:Arm;
		private var _cover:Cover;
		private var _ground:Ground;
		private var _darkMask:DarknessMask;
		private var _lightningMask:LighteningMask;
		private var _clouds:Clouds
		private var nMouseCooldown:Number = 0.0;
		private const MouseCooldownTime:Number = 0.1;
		private var bClickEnable:Boolean = false;
		private var nTimeTillMouseBack:Number = 0.0;
		private var _enemies:Vector.<Enemy>;
		private var sndShout:SoundContainer;
		private var nShoutDuration:Number = 0.0;
		private var _action:Action = null;
		private var nAngerMeter:Number = 0.0;
		private var _rope:Ropes;
		private var bStopLightening:Boolean = false;
		private var txtGameTitle:CMGTLFLabel;
		private var txtAuthor:CMGTLFLabel;
		
		private var _stateMachine:StateMachine;
		
		public function GameScene() 
		{
			instance = this;
			
			sndShout = new SoundContainer(Embed.Sound_WarCry);
			
			_enemies = new Vector.<Enemy>();
			_stateMachine = new StateMachine("Game", true);
			_stateMachine.addState("start", { update:onStart, from:"*" } );
			_stateMachine.addState("firstclk", { enter:onFirstClickEnter, from:"*" } );
			_stateMachine.addState("secondclk", { enter:onSecondClickEnter, from:"*" } );
			_stateMachine.addState("thirdclk", { enter:onThirdClickEnter, from:"*" } );
			_stateMachine.addState("show", { enter:onShowEnter, from:"*" } );
			_stateMachine.addState("begin", { enter:onBeginEnter, update:onBeginUpdate, exit:onBeginExit, from:"*" } );
			_stateMachine.addState("emerge", { enter:onEmergeEnter, update:onEmergeUpdate, exit:onEmergeExit, from:"*" } );
			_stateMachine.addState("firstshout", { enter:onFirstShoutEnter, update:onFirstShoutUpdate, exit:onFirstShoutExit, from:"*" } );
			_stateMachine.addState("stage1", { enter:onStage1Enter, update:onStage1Update, exit:onStage1Exit, from:"*" } );
			_stateMachine.addState("stage2", { enter:onStage2Enter, update:onStage2Update, exit:onStage2Exit, from:"*" } );
			_stateMachine.addState("stage3", { enter:onStage3Enter, update:onStage3Update, exit:onStage3Exit, from:"*" } );		
			_stateMachine.addState("stage4", { enter:onStage4Enter, update:onStage4Update, exit:onStage4Exit, from:"*" } );		
			_stateMachine.addState("epilog", { enter:onEpilogEnter, update:onEpilogUpdate, from:"*" } );
			_stateMachine.initialState = "start";
			
			txtGameTitle = new CMGTLFLabel("game_font", 24, 0xffffff);
			txtGameTitle.text = StringTable.GameName;
			txtGameTitle.setCenterPosition(World.stageWidth / 2, World.stageHeight / 2);
			txtGameTitle.alpha = 0;
			txtGameTitle.visible = false;
			
			txtAuthor = new CMGTLFLabel("game_font", 24, 0xffffff);
			txtAuthor.text = StringTable.Author;
			txtAuthor.setCenterPosition(World.stageWidth / 2, World.stageHeight / 2);
			txtAuthor.alpha = 0;
			txtAuthor.visible = false;
		}
		
		override protected function onInit():void 
		{	
			// Set mouse cursor
			var mcd:MouseCursorData = new MouseCursorData();
			var bmp_cursor:Bitmap = new Embed.Bitmap_Cursor();
			var curs:Vector.<BitmapData> = new Vector.<BitmapData>();
			curs.push(bmp_cursor.bitmapData);
			mcd.data = curs;
			mcd.hotSpot = new Point(0, 0);
			
			Mouse.registerCursor("emerge", mcd);
			Mouse.cursor = "emerge";
			
			mcd = new MouseCursorData();
			bmp_cursor = new Embed.Bitmap_Cursor_Disabled();
			curs = new Vector.<BitmapData>();
			curs.push(bmp_cursor.bitmapData);
			mcd.data = curs;
			mcd.hotSpot = new Point(0, 0);
			
			Mouse.registerCursor("unemerge", mcd);
			
			//stage.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onClick, false, 0, true);
			
			GameMusic.play(Embed.Sound_Earth);
			GameMusic.currentMusic.soundTransform.volume = 0.0;
			Tweener.addTween(GameMusic.currentMusic.soundTransform, { time:5, volume:0.3, transition:"linear" } );
			
			// intro
			var t1:CMGTLFLabel = new CMGTLFLabel("game_font", 32, 0xffffff);
			t1.text = StringTable.Poem1;
			t1.setCenterPosition(World.stageWidth / 2, (World.stageHeight / 2) - 18);
			
			var t2:CMGTLFLabel = new CMGTLFLabel("game_font", 32, 0xffffff);
			t2.text = StringTable.Poem2;
			t2.setCenterPosition(World.stageWidth / 2, (World.stageHeight / 2) + 18);
			
			World.addChildTo(World.LAYER_HUD, t1);
			World.addChildTo(World.LAYER_HUD, t2);
			
			t1.alpha = 0;
			t2.alpha = 0;
			
			Tweener.addTween(t1, { delay:1, time:2, alpha:1, transition:"linear" } );
			Tweener.addTween(t2, { delay:3, time:2, alpha:1, transition:"linear" } );
			Tweener.addTween(t1, { delay:8, time:2, alpha:0, transition:"linear", onComplete:function():void { t1.visible = false; t1.parent.removeChild(t1); }} );
			Tweener.addTween(t2, { delay:9, time:2, alpha:0, transition:"linear", onComplete:function():void { t2.visible = false; t2.parent.removeChild(t2); }} );
			//Tweener.addTween(this, { time:7, onComplete:function():void { bClickEnable = true; } } );
			disableMouse(0.1);
		}
		
		override protected function onAdded():void 
		{			
			// Overlay
			_patternOverlay = new Overlay();
			World.addChildTo(World.LAYER_EFFECTS, _patternOverlay);
			
			// Background
			_background = new Background(6, 0x8c693a, 0x998c58, 0x909b8c);
			World.addChildTo(World.LAYER_BACKGROUND, _background);
			
			// Clouds
			_clouds = new Clouds([0x606060, 0x585858, 0x505050]);
			World.addChildTo(World.LAYER_FRONTGAME, _clouds);
			
			// Arm
			_arm = new Arm();
			World.addChildTo(World.LAYER_GAME, _arm);
			
			// Ropes
			_rope = new Ropes();
			World.addChildTo(World.LAYER_GAME, _rope);
			_rope.visible = false;
			
			// Cover
			_cover = new Cover();
			World.addChildTo(World.LAYER_GAME, _cover);
			
			// Ground
			_ground = new Ground();
			World.addChildTo(World.LAYER_GAME, _ground);
			
			// Darkness Mask
			_darkMask = new DarknessMask();
			World.addChildTo(World.LAYER_FRONTGAME, _darkMask);
			_darkMask.alpha = 1.0;
			
			// Lightening Mask
			_lightningMask = new LighteningMask();
			World.addChildTo(World.LAYER_FRONTGAME, _lightningMask);
			_lightningMask.alpha = 0.0;
			
			TARGET::DEBUG
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onTestKey, false, 0, true);
			}
			
			// Text
			World.addChildTo(World.LAYER_HUD, txtGameTitle);
			World.addChildTo(World.LAYER_HUD, txtAuthor);
			
			Tweener.addTween(this, { delay:10, onComplete:showGameTitle } );
			Tweener.addTween(this, { delay:17, onComplete:showAuthor } );
		}
		
		private function showGameTitle():void
		{
			txtGameTitle.visible = true;
			Tweener.addTween(txtGameTitle, { time:0.5, alpha:1, transition:"linear" } );
			Tweener.addTween(txtGameTitle, { delay:5, time:0.5, alpha:0, transition:"linear" } );
		}
		
		private function showAuthor():void
		{
			txtGameTitle.visible = false;
			txtAuthor.visible = true;
			Tweener.addTween(txtAuthor, { time:0.5, alpha:1, transition:"linear" } );
			Tweener.addTween(txtAuthor, { delay:5, time:0.5, alpha:0, transition:"linear", onComplete:removeAuthor } );
		}
		
		private function removeAuthor():void
		{
			txtAuthor.visible = false;
		}
		
		override protected function onUpdate():void
		{
			_stateMachine.update();
			if (nMouseCooldown > 0.0)
			{
				nMouseCooldown -= Clock.deltaTime;
			}
			if (nTimeTillMouseBack > 0.0)
			{
				nTimeTillMouseBack -= Clock.deltaTime;
				if (nTimeTillMouseBack <= 0.0)
				{
					nTimeTillMouseBack = 0.0;
					enableMouse();
				}
			}
			
			if (nShoutDuration > 0.0)
			{
				nShoutDuration -= Clock.deltaTime;
				if (_enemies.length > 0)
				{
					var victim:Enemy = _enemies[Utils.randomInt(0, _enemies.length - 1)];
					victim.health -= 35;
					if (victim.health <= 0)
					{
						victim.justDie();
					}
				}
				if (nShoutDuration <= 0.0 && _stateMachine.state == "firstshout")
				{
					transition();
				}
			}
		}
		
		override protected function onRemoved():void 
		{
			
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (nMouseCooldown < 0.001 && bClickEnable)
			{
				nMouseCooldown = MouseCooldownTime;
				
				var circle:Circle = new Circle();
				circle.x = e.stageX;
				circle.y = e.stageY;
				World.addChildTo(World.LAYER_HUD, circle);
				
				var snd:SoundContainer = new SoundContainer(Embed.Sound_BoomNom);
				snd.play();
				
				doClick();
			}
		}
		
		private function groundQueryTest():void
		{
			var rx:int = Utils.randomInt(100, World.stageWidth - 100);
			var ss:int = _ground.roughRay(rx);
			
			var r:flash.display.Sprite = new flash.display.Sprite();
			r.graphics.beginFill(Utils.randomInt(0xff0000, 0x00ff00));
			r.graphics.drawRect(rx, ss, 1, 1);
			r.graphics.endFill();
			World.addChildTo(World.LAYER_FRONTGAME, r);
		}
		
		////////////////////////////////////////////////////////////// Actions
		
		public function disableMouse(howlong:Number = -1.0):void
		{
			bClickEnable = false;
			Mouse.cursor = "unemerge";
			if (howlong > 0.0)
			{
				nTimeTillMouseBack = howlong;
			}
		}
		
		public function enableMouse():void
		{
			bClickEnable = true;
			Mouse.cursor = "emerge";
		}
		
		public function flash(intensity:Number = 1.0, duration:Number = 0.1):void
		{
			Tweener.removeTweens(_darkMask);
			var a:Number = _darkMask.alpha;
			Tweener.addTween(_darkMask, { time:duration/2, alpha:1.0 - intensity, transition:"linear" } );
			Tweener.addTween(_darkMask, { delay:duration / 2, time:duration / 2, alpha:a, transition:"linear" } );
			Main(World.main).shake(0.1, duration);
		}
		
		public function doClick():void
		{
			switch(_stateMachine.state)
			{
				case "start":
				case "firstclk":
				case "secondclk":
					transition();
					break;
					
				default:
					Main(World.main).shake(0.05, MouseCooldownTime * 2);
					clickEnemies();
					//groundQueryTest();
			}
		}
		
		private function clickEnemies():void
		{
			for (var i:int = 0; i < _enemies.length; ++i)
			{
				if (_enemies[i].onMouseClick(mouseX, mouseY)) break;
			}
		}
		
		public function addEnemy(enemy:Enemy):void
		{
			_enemies.push(enemy);
		}
		
		public function removeEnemy(enemy:Enemy):void
		{
			for (var i:int = 0; i < _enemies.length; ++i)
			{
				if (_enemies[i] == enemy)
				{
					_enemies.splice(i, 1);
					break;
				}
			}
		}
		
		public function damage(multiplier:Number = 1.0):void
		{
			if (_cover && !_cover.disposed)
			{
				_cover.sink();
			}
			if (_stateMachine.state != "firstshout")
			{
				angerMeter += multiplier * 0.1;
			}
		}
		
		public function findGround(rx:int):Array
		{
			var obj:PixelCollider = null;
			
			var ry:int;
			var ay:int = World.stageHeight;
			if (_cover && !_cover.disposed)
			{
				ry = _cover.roughRay(rx);
				if (ry < ay)
				{
					ay = ry;
					obj = _cover;
				}
			}
			if (_ground)
			{
				ry = _ground.roughRay(rx);
				if (ry < ay)
				{
					ay = ry;
					obj = _ground;
				}
			}
			return [ay, obj];
		}
		
		public function collidesWithGround(px:int, py:int):Boolean
		{
			if (_cover && !_cover.disposed && _cover.collide(px, py))
			{
				return true;
			}
			if (_ground.collide(px, py))
			{
				return true;
			}
			return false;
		}
		
		public function shout(px:int, py:int):void		
		{
			var b:CircleBuilt = new CircleBuilt(px, py);
			World.addChildTo(World.LAYER_EFFECTS, b);
			sndShout.play();
			Main(World.main).shake(0.2, 3.5);
			disableMouse(3.0);
			nShoutDuration = 3.5;
			if (_action)
			{
				_action = null;
			}
		}
		
		public function anger():void
		{
			_action = new Action();
			World.addChildTo(World.LAYER_HUD, _action);
		}
		
		public function goGreen():void
		{
			_ground.goGreen();
			var greenbg:Background = new Background(10, 0x1259d5, 0x55b2ed, 0x7fd5f6);
			greenbg.alpha = 0;
			World.addChildTo(World.LAYER_BACKGROUND, greenbg);
			Tweener.addTween(greenbg, { time:4, alpha:1, transition:"linear" } );
		}
		
		////////////////////////////////////////////////////// Accessors
		public function get lightening():LighteningMask
		{
			return _lightningMask;
		}
		
		public function get angerMeter():Number
		{
			return nAngerMeter;
		}
		
		public function set angerMeter(value:Number):void
		{
			nAngerMeter = value;
			if (nAngerMeter >= 100.0 && !_action)
			{
				nAngerMeter = 0.0;
				anger();
			}
		}
		
		///////////////////////////////////////////////////////////////// State Machine
		public function transition():void
		{
			switch(_stateMachine.state)
			{
				case "start":
					_stateMachine.changeState("firstclk");
					break;
					
				case "firstclk":
					_stateMachine.changeState("secondclk");
					break;
					
				case "secondclk":
					_stateMachine.changeState("thirdclk");
					break;
					
				case "firstshout":
					_stateMachine.changeState("stage1");
					break;
					
				case "stage1":
					_stateMachine.changeState("stage2");
					break;
					
				case "stage2":
					_stateMachine.changeState("stage3");
					break;
					
				case "stage3":
					_stateMachine.changeState("stage4");
					break;
					
				case "stage4":
					_stateMachine.changeState("epilog");
					break;
					
			}
		}
		
		private function onStart(e:StateMachineEvent):void
		{
			
		}
		
		private function onFirstClickEnter(e:StateMachineEvent):void
		{
			flash(0.1, 0.2);
			disableMouse(0.5);
		}
		
		private function onSecondClickEnter(e:StateMachineEvent):void
		{
			flash(0.2, 0.2);
			disableMouse(0.5);
		}
		
		private function onThirdClickEnter(e:StateMachineEvent):void
		{
			flash(0.3, 0.3);
			_stateMachine.changeState("show");
		}
		
		/////////////////////////////////////////////////// Show
		private function onShowEnter(e:StateMachineEvent):void
		{
			Tweener.addTween(_darkMask, { delay:0.4, time:4.0, alpha:0.5, transition:"linear", onComplete:_showFinished } );
			disableMouse(4.0);
		}
		
		private function _showFinished():void
		{
			_stateMachine.changeState("begin");
		}
		
		private function continuousLightening():void
		{
			var lightening:Lightening = new Lightening();
			lightening.x = Utils.randomNumber(100.0, World.stageWidth - 100.0);
			lightening.y = Utils.randomNumber(50.0, 100.0);
			World.addChildTo(World.LAYER_EFFECTS, lightening);
			if (!bStopLightening)
			{
				Tweener.addTween(this, { time:Utils.randomNumber(12.0, 25.0), onComplete:continuousLightening } );
			}
		}
		
		//////////////////////////////////////////////////// Begin
		private function onBeginEnter(e:StateMachineEvent):void
		{
			var enemy:SmallEnemy;
			for (var i:int = 0; i < 4; ++i)
			{
				enemy = new SmallEnemy();
				World.addChildTo(World.LAYER_GAME, enemy);
			}
			
			continuousLightening();
			
			//var ac:Action = new Action();
			//World.addChildTo(World.LAYER_HUD, ac);
		}
		
		private function onBeginUpdate(e:StateMachineEvent):void
		{
			if (_enemies.length == 0)
			{
				_stateMachine.changeState("emerge");
			}
		}
		
		private function onBeginExit(e:StateMachineEvent):void
		{
			
		}
		
		//////////////////////////////////////////////////// EMERGE
		private var _emerge_raise:Number;
		private var _emerge_firstSpawn:Boolean = false;
		
		private function onEmergeEnter(e:StateMachineEvent):void
		{
			Main(World.main).shake(0.1, 5.0);
			disableMouse(5.0);
			Tweener.addTween(this, { time:2.0, onComplete:_emergeSpawn } );
			_emerge_raise = 6.0;
		}
		
		private function onEmergeUpdate(e:StateMachineEvent):void
		{
			if (_emerge_raise > 0.0)
			{
				_emerge_raise -= Clock.deltaTime;				
				_cover.raise();
			}
			else if (_cover.raiseAmount < 5.0)
			{
				_stateMachine.changeState("firstshout");
			}
			
			if (_emerge_firstSpawn && _enemies.length == 0)
			{
				_emergeSpawn(2);
				Main(World.main).shake(0.1, 2.0);
				disableMouse(2.0);
			}
		}
		
		private function onEmergeExit(e:StateMachineEvent):void
		{
			
		}
		
		private function _emergeSpawn(multiplier:Number = 1.0):void
		{
			_emerge_firstSpawn = true;
			var enemy:SmallEnemy;
			for (var i:int = 0; i < 7 * multiplier; ++i)
			{
				enemy = new SmallEnemy();
				World.addChildTo(World.LAYER_GAME, enemy);
			}
			enemy = new SmallEnemy(new flash.geom.Point(400, -50));
			World.addChildTo(World.LAYER_GAME, enemy);
		}
		
		//////////////////////////////////////////////////// FIRST SHOUTE
		private function onFirstShoutEnter(e:StateMachineEvent):void
		{
			var ac:Action = new Action();
			World.addChildTo(World.LAYER_HUD, ac);
			
			var enemy:SmallEnemy;
			for (var i:int = 0; i < 7; ++i)
			{
				enemy = new SmallEnemy();
				World.addChildTo(World.LAYER_GAME, enemy);
			}
			for (i = 0; i < 4; ++i)
			{
				enemy = new SmallEnemy(new flash.geom.Point(Utils.randomNumber(100, World.stageWidth - 100), -50));
				World.addChildTo(World.LAYER_GAME, enemy);
			}
		}
		
		private function onFirstShoutUpdate(e:StateMachineEvent):void
		{
			
		}
		
		private function onFirstShoutExit(e:StateMachineEvent):void
		{
			
		}
		
		//////////////////////////////////////////////////// STAGE1
		private function onStage1Enter(e:StateMachineEvent):void
		{
			Console.log("STAGE 1: START");
			_emergeSpawn();
		}
		
		private function onStage1Update(e:StateMachineEvent):void
		{
			_cover.raise();
			if (_enemies.length < 3)
			{
				_emergeSpawn(2.0);
			}
		}
		
		private function onStage1Exit(e:StateMachineEvent):void
		{
			
		}
		
		//////////////////////////////////////////////////// STAGE1
		private function onStage2Enter(e:StateMachineEvent):void
		{
			Console.log("STAGE 2: START");
			_emergeSpawn();
			_arm.x = 358;
			_arm.y = 492;
			_arm.visible = true;
		}
		
		private function onStage2Update(e:StateMachineEvent):void
		{
			_cover.raise();
			if (_enemies.length < 3)
			{
				_emergeSpawn(2);
			}
		}
		
		private function onStage2Exit(e:StateMachineEvent):void
		{
			
		}
		
		//////////////////////////////////////////////////// STAGE3
		private function onStage3Enter(e:StateMachineEvent):void
		{
			_emergeSpawnMedium();
			Console.log("STAGE 3: START");
			_rope.visible = true;
			_arm.x = 358;
			_arm.y = 492;
			_arm.visible = true;
		}
		
		private function onStage3Update(e:StateMachineEvent):void
		{
			_rope.cut(2);
			if (_enemies.length < 3)
			{
				_emergeSpawnMedium(2);
			}
		}
		
		private function onStage3Exit(e:StateMachineEvent):void
		{
			
		}
		
		private function _emergeSpawnMedium(multiplier:Number = 1.0):void
		{
			_emerge_firstSpawn = true;
			var enemy:MediumEnemy;
			for (var i:int = 0; i < 7 * multiplier; ++i)
			{
				enemy = new MediumEnemy();
				World.addChildTo(World.LAYER_GAME, enemy);
			}
			enemy = new MediumEnemy(new Point(400, -50));
			World.addChildTo(World.LAYER_GAME, enemy);
		}
		
		//////////////////////////////////////////////////// STAGE4
		private function onStage4Enter(e:StateMachineEvent):void
		{
			_emergeSpawnMedium();
			Console.log("STAGE 4: START");
			_rope.visible = false;
			_arm.x = 358;
			_arm.y = 492;
			_arm.visible = true;
			_arm.ropeBreak();
			
			bStopLightening = true;
			_clouds.goAway();
			Tweener.addTween(_darkMask, { time:1, alpha:0.0, transition:"linear" } );
		}
		
		private function onStage4Update(e:StateMachineEvent):void
		{
			if (_enemies.length < 3)
			{
				_emergeSpawnMedium(2);
			}
		}
		
		private function onStage4Exit(e:StateMachineEvent):void
		{
			
		}
		
		///////////////////////////////////////////////// EPILOG
		private function onEpilogEnter(e:StateMachineEvent):void
		{
			goGreen();
			Main(World.main).shake(0.2, 1.5);
			for (var i:int = 0; i < _enemies.length; ++i)
			{
				_enemies[i].justDie();
			}
			Tweener.addTween(this, { delay:5, time:4, alpha:0, transition:"linear", onComplete:_toEnd } );
		}
		
		private function onEpilogUpdate(e:StateMachineEvent):void
		{

		}
		
		private function _toEnd():void
		{
			Main(World.main).changeScene("end");
		}
		
		////////////////////// TEST
		private function onTestKey(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keys.KC_H:
					_arm.x = 358;
					_arm.y = 492;
					_arm.visible = true;
					World.addChildTo(World.LAYER_DEBUG, _arm);
					break;
					
				case Keys.KC_C:
					_cover.x = 400;
					_cover.y = 100;
					World.addChildTo(World.LAYER_DEBUG, _cover);
			}
		}
	}

}