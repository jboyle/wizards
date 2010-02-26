package com.wizards.rooms
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Room1Bk extends Room
	{
		
		public var scrap1:MovieClip;
		public var scrap1_c:MovieClip;
		public function Room1Bk()
		{
			super();
			scrap1_c.visible =false;
			
			scrap1.buttonMode = true;
			scrap1_c.buttonMode = true;
			
			scrap1.addEventListener(MouseEvent.CLICK,handleScrap1Click);
			scrap1_c.addEventListener(MouseEvent.CLICK,handleScrap1CClick);
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
		}
		
		private function handleScrap1Click(ev:Event){
			scrap1.visible = false;
			scrap1_c.visible = true;
		}
		
		private function handleScrap1CClick(ev:Event){
			scrap1.visible = true;
			scrap1_c.visible = false;
		}
		
		private function handleTurnAround(ev:Event){
			var evt:RoomEvent = new RoomEvent("1_ft",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
	}
}