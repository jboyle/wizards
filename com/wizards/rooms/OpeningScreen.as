package com.wizards.rooms
{
	
	import com.wizards.WizardsG;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class OpeningScreen extends Room
	{
		
		public var fader:MovieClip;
		public var playButton:MovieClip;
		
		private const fadeTime:Number = 1.3;
		private var fading:Boolean;
		private var fadeU:Number;
		
		public function OpeningScreen()
		{
			
			fader.alpha = 0;
			fader.mouseEnabled = false;
			playButton.gotoAndStop(1);
			
			playButton.buttonMode = true;
			playButton.addEventListener(MouseEvent.ROLL_OVER,playRollOver);
			playButton.addEventListener(MouseEvent.ROLL_OUT, playRollOut);
			
			_turnAroundArea.mouseEnabled = false;
			playButton.addEventListener(MouseEvent.CLICK, handleClick);
			
			fading = false;
			fadeU = 0;
		}

		protected function playRollOver(ev:MouseEvent){
			playButton.gotoAndStop(2);
		}
		
		protected function playRollOut(ev:MouseEvent){
			playButton.gotoAndStop(1);
		}
		
		protected function handleClick(ev:MouseEvent){
			fading = true;
		}
		
		override public function update():void{
			if(fading){
				fadeU += WizardsG.TIME_DIFF / fadeTime;
				fader.alpha = fadeU * fadeU;
				if(fadeU >= 1){
					fader.alpha = 1;
					var evt:RoomEvent = new RoomEvent("o_sequence",RoomEvent.CHANGE_ROOM);
					dispatchEvent(evt);
				}
			}
			
		}
		
	}
}