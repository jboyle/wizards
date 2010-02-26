package com.wizards
{
	
	import com.wizards.rooms.*;
	
	import flash.display.MovieClip;

	public class RoomController extends MovieClip
	{
		private var _rooms:Object;
		
		private var _currentRoom:Room;
		public function RoomController()
		{
			super();
			_rooms = new Object();
			
			_rooms["1_bk"] = new Room1Bk();
			_rooms["1_ft"] = new Room1Ft();
			_rooms["2_bk"] = new Room2Bk();
			_rooms["2_ft"] = new Room2Ft();
			_rooms["3_bk"] = new Room3Bk();
			_rooms["3_ft"] = new Room3Ft();
			_rooms["4_bk"] = new Room4Bk();
			_rooms["4_ft"] = new Room4Ft();
			_rooms["5_ft"] = new Room5Ft();
			
			var room:Room;
			for(var i in _rooms){
				room = _rooms[i] as Room;
				room.addEventListener(RoomEvent.CHANGE_ROOM, handleChangeRoom);
			}
			
			_currentRoom = _rooms["5_ft"];
			addChild(_currentRoom);
		}
		
		private function handleChangeRoom(ev:RoomEvent){
			trace("changing to: "+ev.roomName);
			changeRoomTo(ev.roomName);
		}
		
		public function changeRoomTo(roomName:String){
			if(_rooms[roomName]){
				removeChild(_currentRoom);
				_currentRoom = _rooms[roomName];
				addChild(_currentRoom);
			}
		}
		
		public function update(){
			_currentRoom.update();
		}
		
		
	}
}