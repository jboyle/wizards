package com.wizards.rooms
{
	import flash.events.Event;

	public class RoomEvent extends Event
	{
		public static const CHANGE_ROOM:String = "changeRoom";
		
		
		public var roomName:String;
		public function RoomEvent(roomName:String, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.roomName = roomName;
			super(type, bubbles, cancelable);
		}
		
	}
}