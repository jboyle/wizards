package com.wizards
{
	import com.wizards.levels.intro.IntroLevel;
	import com.wizards.levels.onecloud.Level1;
	import com.wizards.levels.scenarios.FightScenario;
	import com.wizards.levels.scenarios.Training;
	
	import flash.display.MovieClip;
	
	public class ARGameController extends MovieClip
	{
		public static const DELAY_REMOVE:Number = 2;
		
		private var _markerReader:MarkerReader;
		private var _spellController:SpellController;
		private var _levelController:LevelController;
		
		private var _soundManager:SoundManager;
		
		private var _player:GameObject;
		
		private var _healthIndicator:MovieClip;
		
		public function ARGameController()
		{
			_markerReader = new MarkerReader();
			_levelController = new LevelController();
			_spellController = new SpellController(_levelController);
			
			_soundManager = new SoundManager();
			
			_player = new GameObject();
			WizardsG.PLAYER_OBJECT = _player;
			
			_levelController.addLevel(new IntroLevel());	// Level O
			_levelController.addLevel(new Level1());		// Level 1
			_levelController.addLevel(new Training());		// Level 2 'tilting' tutorial + 'rotation?'
			_levelController.addLevel(new FightScenario());	// Level 3 ...
			
			_healthIndicator = new HealthIndicator();
			_healthIndicator.mouseEnabled = false;
			_healthIndicator.alpha = 0;
			
			addChild(_levelController);
			addChild(_spellController);
			addChild(_healthIndicator);
			
		}
		
		public function update(){
			_levelController.update();
			_spellController.update();
			_soundManager.update();
			_player.update();
		
		}
		
		public function updatePhrases(detectedMarkers:Array, detectedNum:int){
			_markerReader.updateSymbolTable(detectedMarkers,detectedNum);
		}
		
		/*private function handleLevelClear(ev:LevelEvent){
			trace("ARGameController received LevelEvent.CLEAR event from LevelController");
			_spellController.clearAllPhrases();
			
			var p:Phrase;
			var toRemove = _activePhrases.slice();
			for(var i = 0; i < toRemove.length; i++){
				p = _activePhrases[i] as Phrase;
				var ind = _activePhrases.indexOf(p);
				_activePhrases.splice(ind,1);
				_activeIds.splice(ind,1);
				_activeTimers.splice(ind,1);
			}
		}*/
	}
}
