package com.wizards
{
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	
	import flash.display.MovieClip;
	
	public class ARGameController extends MovieClip
	{
		private var _displayArea:DisplayArea;
		private var _spellController:SpellController;
		
		private var _player:GameObject;
		private var _target:GameObject;
		
		public function ARGameController()
		{
			_displayArea = new DisplayArea();
			_spellController = new SpellController(_displayArea);
			
			_player = new GameObject();
			_target = new GameObject();
			
			var playerHP = new HitPoints(10,Effect.DURATION_FOREVER,0);
			_player.addEffect(playerHP);
			
			_spellController.selfTarget = _player;
			_spellController.target = _target;
			
			addChild(_displayArea);
		}
		
		public function update(){
			_displayArea.update();
			_spellController.update();
			
			_player.update();
			_target.update();
		}
		
		public function startCast(num:int){
			
		}

	}
}