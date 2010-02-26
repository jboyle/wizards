package com.wizards.rooms
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Room3Bk extends Room
	{
		public var clickArea:MovieClip;
		public var iceMessage:MovieClip;
		public var iceMessage_c:MovieClip;
		
		public function Room3Bk()
		{
			super();
			
			iceMessage_c.visible = false;
			
			iceMessage.buttonMode = true;
			iceMessage_c.buttonMode = true;
			clickArea.buttonMode = true;
			
			iceMessage.addEventListener(MouseEvent.CLICK, showIceMessage);
			iceMessage_c.addEventListener(MouseEvent.CLICK, hideIceMessage);
			clickArea.addEventListener(MouseEvent.CLICK, handleClick);
			_turnAroundArea.addEventListener(MouseEvent.CLICK,handleTurnAround);
		}
		
		private function handleTurnAround(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("3_ft",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
		private function showIceMessage(ev:MouseEvent){
			iceMessage_c.visible = true;
		}
		
		private function hideIceMessage(ev:MouseEvent){
			iceMessage_c.visible = false;
		}
		
		private function handleClick(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("2_bk",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
	}
}