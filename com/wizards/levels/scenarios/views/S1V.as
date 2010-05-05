package com.wizards.levels.scenarios.views
{
	import com.wizards.SoundManager;
	import com.wizards.WSound;
	import com.wizards.entities.Wraith;
	import com.wizards.levels.LevelEvent;
	import com.wizards.levels.Room;
	import com.wizards.levels.View;
	
	import flash.events.Event;

	public class S1V extends View
	{
		public var wraith:Wraith;
		private var _wraithKilled:Boolean;
		
		
		public function S1V()
		{
			super();
			
			var wraith:Wraith = new Wraith();
			wraith.setPosition(100,200);
			wraith.tags = ["attackable"];
			wraith.addEventListener("killed",killWraith);
			addChild(wraith);
			addSpellTarget(wraith);
			
			SoundManager.MANAGER.loadSound("bossBattle", "data/sounds/bossBattle.mp3");
		}
		
		override public function update():void{
			super.update();
			
			trace("wraith hp: "+wraith.hp);
		}
		
		private function killWraith(ev:Event){
			SoundManager.MANAGER.fadeOutSound("ambientWind",1);
			_wraithKilled = true;
			_fader.addEventListener(Event.COMPLETE,handleFadeComplete);
			fadeOut(1);
		}
		
		private function handleFadeComplete(ev:Event){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = 0;
			evt.room = "intro";
			evt.direction = Room.NORTH;
			evt.fadeIn = true;
			dispatchEvent(evt);
		}
		
		override public function activate():void{
			trace("fight-activate!!");
			SoundManager.MANAGER.stopSound("ambientWind");
			var s:WSound = SoundManager.MANAGER.playSound("bossBattle");
			s.looped = true;
			super.activate();
		}
		
		override public function deactivate():void{
			SoundManager.MANAGER.stopSound("bossBattle");
			super.activate();
		}
		
	}
}