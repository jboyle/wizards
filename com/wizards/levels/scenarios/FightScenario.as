package com.wizards.levels.scenarios
{
	import com.wizards.SoundManager;
	import com.wizards.WSound;
	import com.wizards.entities.Wraith;
	import com.wizards.levels.Level;
	import com.wizards.levels.LevelEvent;
	import com.wizards.levels.Room;
	import com.wizards.levels.SceneRoom;
	import com.wizards.levels.TextSequence;
	import com.wizards.levels.View;
	
	import flash.events.Event;

	public class FightScenario extends Level
	{
		private var wraith:Wraith;
		private var view:View;
		public function FightScenario()
		{
			super();
			
			var or:SceneRoom = new SceneRoom();
			or.addView(new TextSequence("" + 
					"You must use this magic\n" + 
					"To defeat your foes\n" + 
					"Tilt the book towards them\n" + 
					"And they will not excape your grasp", "1", Room.NORTH),Room.NORTH);
			
			var r1:Room = new Room();
			view = new V2S();
			view.disableMovement();
			wraith = new Wraith();
			wraith.setPosition(400,300);
			wraith.tags["attackable"];
			wraith.addEventListener("killed",handleDeadWraith);
			view.addChild(wraith);
			view.addSpellTarget(wraith);
			
			r1.addView(view,Room.NORTH);
			
			addRoom("intro", or);
			addRoom("1",r1);
			
			setRoom("intro", Room.NORTH);
			
			view.fader.addEventListener(Event.COMPLETE, startMusic);
			
			SoundManager.MANAGER.loadSound("bossBattle","data/sounds/bossBattle.mp3");
					
				
		}
		
		private function startMusic(ev:Event){
			SoundManager.MANAGER.stopSound("ambientWind");
			var s:WSound = SoundManager.MANAGER.playSound("bossBattle");
			s.looped = true;
			view.fader.removeEventListener(Event.COMPLETE, startMusic);
		}
		
		private function handleDeadWraith(ev:Event){
			SoundManager.MANAGER.fadeOutSound("bossBattle",.1);
			view.removeChild(wraith);
			view.removeSpellTarget(wraith);
			view.fadeOut(1);
			view.fader.addEventListener(Event.COMPLETE, handleFadeComplete);
		}
		
		
		private function handleFadeComplete(ev:Event){
			trace("boss battle fade out");
			var evt:LevelEvent = new LevelEvent(LevelEvent.RESET);
			dispatchEvent(evt);
		}
	
	}
}