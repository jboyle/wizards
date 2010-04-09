package com.wizards
{
	import com.wizards.levels.Level;
	import com.wizards.levels.LevelEvent;
	
	import flash.display.MovieClip;
	
	public class LevelController extends MovieClip
	{
		private var _levels:Array;
		private var _currentLevel:uint;
		public function LevelController()
		{
			_levels = new Array();
			_currentLevel = 0;
		}
		
		public function update():void{
			var l:Level = _levels[_currentLevel] as Level;
			l.update();
		}
		
		public function addLevel(newLevel:Level){
			newLevel.addEventListener(LevelEvent.CHANGE_LEVEL, handleLevelChange);
			if(_levels.push(newLevel) == 1){
				level = 0;
			}
		}
		
		private function handleLevelChange(ev:LevelEvent){
			level = ev.level;
		}
		
		private function removeCurrentLevel():Boolean{
			var ret = true;
			try{
				removeChild(_levels[_currentLevel]);
			} catch(er:ArgumentError){
				ret = false;
			}
			return ret;
		}
		
		public function set level(nl:uint):void{
			if(nl < _levels.length){
				removeCurrentLevel();
				_currentLevel = nl;
				addChild(_levels[_currentLevel]);
			}
		}
		
		public function get level():uint{
			return _currentLevel;
		}
	}
}