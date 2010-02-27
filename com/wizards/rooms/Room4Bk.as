package com.wizards.rooms
{
	import com.wizards.GameObject;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Room4Bk extends Room
	{
		public var clickArea:MovieClip;
		public var river:MovieClip;
		
		public var iceBridge:GameObject;
		public function Room4Bk()
		{
			super();
			
			clickArea.addEventListener(MouseEvent.CLICK, handleClick);
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
			
			setForwardArea(clickArea);
		}
		
		private function handleClick(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("3_bk",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
		private function handleTurnAround(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("4_ft",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
	}
}