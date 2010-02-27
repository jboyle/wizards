package com.wizards.rooms
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Room2Bk extends Room
	{
		public var clickArea:MovieClip;
		public function Room2Bk()
		{
			super();
			
			clickArea.buttonMode = true;
			
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
			clickArea.addEventListener(MouseEvent.CLICK,handleClick);
			
			setForwardArea(clickArea);
		}
		
		private function handleClick(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("1_bk",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
		private function handleTurnAround(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("2_ft",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
	}
}