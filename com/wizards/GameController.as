package com.wizards
{
	
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class GameController extends MovieClip
	{
		private var _inputManager:InputManager;
		
		private var _leftDisplayArea:SlottedDisplayArea;
		private var _rightDisplayArea:SlottedDisplayArea;
		
		private var _leftSpellController:SpellController;
		private var _rightSpellController:SpellController;
		
		private var _leftPlayer:GameObject;
		private var _rightPlayer:GameObject;
		
		//private var _data:XML;
		
		private var _activeWords:Array;
		
		public function GameController(inputManager:InputManager)
		{
			super();
			
			_inputManager = inputManager;
			//_data = data;
			
			//SpellFactory.spellData = _data.spells;
			
			_activeWords = new Array();
			
			_leftDisplayArea = new SlottedDisplayArea();
			_rightDisplayArea = new SlottedDisplayArea();
			
			_leftSpellController = new SpellController(_leftDisplayArea);
			_rightSpellController = new SpellController(_rightDisplayArea);
			
			_leftPlayer = new GameObject();
			_rightPlayer = new GameObject();
			/*
			var hp1:HitPoints = new HitPoints(null, 10);
			_leftPlayer.addTagEffect("HitPoints",hp1);
			
			var hp2:HitPoints = new HitPoints(null, 10);
			_rightPlayer.addTagEffect("HitPoints",hp2);
			*/
			
			var _leftEffect:HitPoints = new HitPoints(10, Effect.DURATION_FOREVER, 0);
			var _rightEffect:HitPoints = new HitPoints(10, Effect.DURATION_FOREVER, 0);
			
			_leftEffect.addTag("hit_points");
			_rightEffect.addTag("hit_points");
			
			_leftPlayer.addEffect(_leftEffect);
			_rightPlayer.addEffect(_rightEffect);
			
			_leftSpellController.target = _rightPlayer;
			_rightSpellController.target = _leftPlayer;
			_leftSpellController.selfTarget = _leftPlayer;
			_rightSpellController.selfTarget = _rightPlayer;
			
			addChild(_leftDisplayArea);
			_rightDisplayArea.x = 400;
			addChild(_rightDisplayArea);
		}
		
		public function update(){
			//look for keyDowns
			for(var i = 0; i < _inputManager.activeWords.length; i++){
				if(_activeWords.indexOf(_inputManager.activeWords[i]) == -1){
					_activeWords.push(_inputManager.activeWords[i]);
					handlePress(_inputManager.activeWords[i]);
				}
			}
			
			//look for keyUps
			var toRemove:Array = new Array();
			for(i = 0; i < _activeWords.length; i++){
				if(_inputManager.activeWords.indexOf(_activeWords[i]) == -1){
					toRemove.push(_activeWords[i]);
					handleRelease(_activeWords[i]);
				}
			}
			for(i = 0; i < toRemove.length; i++){
				_activeWords.splice(_activeWords.indexOf(toRemove[i]),1);
			}
			
			_leftDisplayArea.update();
			_rightDisplayArea.update();
			
			_leftSpellController.update();
			_rightSpellController.update();
			
			_leftPlayer.update();
			_rightPlayer.update();
			
			var searchArray:Array = ["hit_points"];
			var lhp:HitPoints = _leftPlayer.getFirstEffect(searchArray, Effect.MATCH_PERFECT) as HitPoints;
			var rhp:HitPoints = _rightPlayer.getFirstEffect(searchArray, Effect.MATCH_PERFECT) as HitPoints;
			
			var ev:Event;
			if(lhp.hitPoints <= 0){
				trace("left");
				_rightDisplayArea.addChild(new Winner());
				ev = new Event("gameOver");
				dispatchEvent(ev);
			} else if(rhp.hitPoints <= 0){
				trace("right");
				_leftDisplayArea.addChild(new Winner());
				ev = new Event("gameOver");
				dispatchEvent(ev);
			}
		}
		
		private function handlePress(obj:Object){
			//trace("press: " + obj.word);
			var slot:int = -1;
			switch(obj.word){
				case "slot1":
					slot = 0;
					break;
				case "slot2":
					slot = 1;
					break;
				case "slot3":
					slot = 2;
					break;
			}
			var phrase:Phrase = new Phrase(obj.word);
			if(obj.side == InputManager.LEFT){
				if(slot == -1){
					_leftSpellController.startCast(phrase);
				} else {
					_leftDisplayArea.slot = slot;
				}
			} else if(obj.side == InputManager.RIGHT){
				if(slot == -1){
					_rightSpellController.startCast(phrase);
				} else {
					_rightDisplayArea.slot = slot;
				}
			}
		}
		
		private function handleRelease(obj:Object){
			//trace("release: "+obj.word);
			switch(obj.word){
				case "slot1":
				case "slot2":
				case "slot3":
					break;
				default:
					if(obj.side == InputManager.LEFT){
						_leftSpellController.stopCast();
					} else if(obj.side == InputManager.RIGHT){
						_rightSpellController.stopCast();
					}
					break;
			}
			
		}
		
		public function get leftPlayerHP():Number{
			var effects:Array = _leftPlayer.getAllEffects(["hit_points"],Effect.MATCH_ONE);
			var num:Number = 0;
			for(var i in effects){
				var e:HitPoints = effects[i] as HitPoints;
				num += e.hitPoints;
			}
			return num;
		}
		
		public function get rightPlayerHP():Number{
			var effects:Array = _rightPlayer.getAllEffects(["hit_points"],Effect.MATCH_ONE);
			var num:Number = 0;
			for(var i in effects){
				var e:HitPoints = effects[i] as HitPoints;
				num += e.hitPoints;
			}
			return num;
		}
		
	}
}