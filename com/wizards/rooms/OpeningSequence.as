package com.wizards.rooms
{
	import com.wizards.WizardsG;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class OpeningSequence extends Room
	{
		public var clickArea:MovieClip;
		
		public var msg1:MovieClip;
		public var msg2:MovieClip;
		public var msg3:MovieClip;
		public var msg4:MovieClip;
		
		private var stepper:Number;
		private var messages:Array;
		
		private var waitTime:Number;
		private var waitTimer:Number;
		private var showFirst:Boolean;
		public function OpeningSequence()
		{
			super();
			
			clickArea.buttonMode = true;
			
			waitTime = 3;
			waitTimer = 0;
			showFirst = false;
			
			stepper = 0;
			messages = new Array();
			
			messages.push(msg1);
			messages.push(msg2);
			messages.push(msg3);
			messages.push(msg4);
			
			var msg:MovieClip;
			for(var i in messages){
				msg = messages[i] as MovieClip;
				msg.stop();
			}
			
			clickArea.addEventListener(MouseEvent.CLICK, handleClick);
			playNextClip();
		}
		
		private function handleClick(ev:MouseEvent){
			playNextClip();
			
		}
		
		private function playNextClip(){
			if(stepper < messages.length){
				var clip:MovieClip = messages[stepper] as MovieClip;
				clip.play();
				stepper++;
			} else {
				var evt:RoomEvent = new RoomEvent("1_bk",RoomEvent.CHANGE_ROOM);
				dispatchEvent(evt);
			}
		}
		override public function update():void{

			if(waitTimer < waitTime){
				waitTimer += WizardsG.TIME_DIFF;
			} else {
				waitTimer = 0;
				playNextClip();
			}
		
		}
		
	}
}