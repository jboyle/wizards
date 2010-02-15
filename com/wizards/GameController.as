package com.wizards
{
	import flash.display.MovieClip;

	public class GameController extends MovieClip
	{
		private var _inputManager:InputManager;
		
		private var _leftDisplayArea:SlottedDisplayArea;
		private var _rightDisplayArea:SlottedDisplayArea;
		
		private var _leftSpellController:SpellController;
		private var _rightSpellController:SpellController;
		
		private var _data:XML;
		
		private var _activeWords:Array;
		
		public function GameController(inputManager:InputManager, data:XML)
		{
			super();
			
			_inputManager = inputManager;
			_data = data;
			
			_activeWords = new Array();
			
			_leftDisplayArea = new SlottedDisplayArea();
			_rightDisplayArea = new SlottedDisplayArea();
			
			_leftSpellController = new SpellController(_leftDisplayArea,_data.phraseTree,_data.wordTiming);
			_rightSpellController = new SpellController(_rightDisplayArea,_data.phraseTree,_data.wordTiming);
			
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
			
			_leftSpellController.update();
			_rightSpellController.update();
			
			_leftDisplayArea.update();
			_rightDisplayArea.update();
		}
		
		private function handlePress(obj:Object){
			//trace("press: " + obj.word);
			var symbol:Symbol = new Symbol(obj.word);
			if(obj.side == InputManager.LEFT){
				_leftSpellController.startCast(symbol);
			} else if(obj.side == InputManager.RIGHT){
				_rightSpellController.startCast(symbol);
			}
		}
		
		private function handleRelease(obj:Object){
			//trace("release: "+obj.word);
			if(obj.side == InputManager.LEFT){
				_leftSpellController.stopCast();
			} else if(obj.side == InputManager.RIGHT){
				_rightSpellController.stopCast();
			}
		}
		
	}
}