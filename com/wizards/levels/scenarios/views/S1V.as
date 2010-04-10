package com.wizards.levels.scenarios.views
{
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
			addChild(wraith);
			addSpellTarget(wraith);
		}
		
		override public function update():void{
			super.update();
			
			if(!wraith.alive && !_wraithKilled){
				_wraithKilled = true;
				_fader.addEventListener(Event.COMPLETE,handleFadeComplete);
				fadeOut(1);
			}
		}
		
		private function handleFadeComplete(ev:Event){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = 3;
			evt.room = "or";
			evt.direction = Room.NORTH;
			evt.fadeIn = true;
			dispatchEvent(evt);
		}
		
	}
}