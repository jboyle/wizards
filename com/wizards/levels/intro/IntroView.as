package com.wizards.levels.intro
{
	import com.wizards.levels.LevelEvent;
	import com.wizards.levels.Room;
	import com.wizards.levels.View;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class IntroView extends View
	{
		public var playButton:MovieClip;
		public function IntroView()
		{
			super();
			_turnLeftArea.visible = false;
			_turnRightArea.visible = false;
			
			playButton.buttonMode = true;
			playButton.gotoAndStop(1);
			
			playButton.addEventListener(MouseEvent.MOUSE_OVER, playButtonMouseOver);
			playButton.addEventListener(MouseEvent.MOUSE_OUT, playButtonMouseOut);
			playButton.addEventListener(MouseEvent.CLICK, playButtonClick);
		}
		
		private function playButtonMouseOver(ev:MouseEvent){
			playButton.gotoAndStop(2);
		}
		
		private function playButtonMouseOut(ev:MouseEvent){
			playButton.gotoAndStop(1);
		}
		
		private function playButtonClick(ev:MouseEvent){
			_fader.addEventListener(Event.COMPLETE, handleFadeOut);
			fadeOut(1);
		}
		
		private function handleFadeOut(ev:Event){
			dispatchChangeLevelEvent();
		}
		
		private function dispatchChangeLevelEvent(){
			var ev:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			ev.level = 1;
			ev.room = "1";
			ev.direction = Room.NORTH;
			ev.fadeIn = true;
			dispatchEvent(ev);
		}

	}
}