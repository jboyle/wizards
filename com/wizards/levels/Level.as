package com.wizards.levels
{
	import com.wizards.GameObject;
	import com.wizards.WizardsU;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class Level extends MovieClip
	{
		
		private var _rooms:Object;
		private var _currentRoom:Room;
		
		public function Level()
		{
			_rooms = new Object();
		}
		
		public function addRoom(name:String, room:Room):void{
			room.addEventListener(LevelEvent.CHANGE_DIRECTION, handleDirectionChange);
			room.addEventListener(LevelEvent.CHANGE_ROOM, handleRoomChange);
			room.addEventListener(LevelEvent.CHANGE_LEVEL, handleLevelChange);
			_rooms[name] = room;
		}
		
		public function setRoom(name:String, direction:uint = 5, fadeIn:Boolean = false):void{
			removeCurrentRoom();
			_currentRoom = _rooms[name];
			if(direction != 5){
				_currentRoom.direction = direction;
			} else {
				_currentRoom.direction = Room.NORTH;
			}
			if(fadeIn){
				//_currentRoom.currentView.fader.alpha = 1;
				_currentRoom.currentView.fadeIn(1);
			}
			addChild(_currentRoom);
		}
		
		public function update():void{
			_currentRoom.update();
		}
		
		public function getSpellCollision(tx:Number, ty:Number):GameObject{
			return _currentRoom.getSpellCollision(tx,ty);
		}
		
		protected function removeCurrentRoom():Boolean{
			var ret = true;
			if(_currentRoom != null){
				try{
					removeChild(_currentRoom);
				} catch (er:ArgumentError){
					ret = false;
				}
			} else {
				ret = false;
			}
			return ret;
		}
		
		protected function handleDirectionChange(ev:LevelEvent){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_DIRECTION);
			evt.level = ev.level;
			evt.room = ev.room;
			evt.direction = ev.direction;
			evt.fadeIn = ev.fadeIn;
			dispatchEvent(evt);
		}
		protected function handleRoomChange(ev:LevelEvent){
			setRoom(ev.room,ev.direction, ev.fadeIn);
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_ROOM);
			evt.level = ev.level;
			evt.room = ev.room;
			evt.direction = ev.direction;
			evt.fadeIn = ev.fadeIn;
			dispatchEvent(evt);
		}
		
		protected function handleLevelChange(ev:LevelEvent){
			//trace("receiveing levelChangeEvent");
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = ev.level;
			evt.room = ev.room;
			evt.direction = ev.direction;
			evt.fadeIn = ev.fadeIn;
			dispatchEvent(evt);
		}
		
		protected function linkRooms(r1:String, r2:String, direction1:uint, direction2:uint, r1ClickRect:Rectangle, r2ClickRect:Rectangle){
			var linkClip1:MovieClip = new MovieClip();
			WizardsU.drawRect(r1ClickRect,0xffffff,linkClip1);
			linkClip1.alpha = 0;
			
			var linkClip2:MovieClip = new MovieClip();
			WizardsU.drawRect(r2ClickRect, 0xffffff,linkClip2);
			linkClip2.alpha = 0;
			
			var room1:Room = _rooms[r1] as Room;
			var room2:Room = _rooms[r2] as Room;
			
			var v1:View = room1.getView(direction1);
			v1.setHitArea(linkClip1,r2,direction1);
			
			var v2:View = room2.getView(direction2);
			v2.setHitArea(linkClip2,r1,direction2);
		}
	}
}