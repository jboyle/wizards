package com.wizards.levels
{
	import flash.display.MovieClip;

	public class Room extends MovieClip
	{
		static public const LEFT:uint = 0;
		static public const RIGHT:uint = 1;
		
		public static var NORTH:uint = 0;
		public static var EAST:uint = 1;
		public static var SOUTH:uint = 2;
		public static var WEST:uint = 3;
		
		protected var _views:Array;
		protected var _currentView:View;
		protected var _direction:uint;
		public function Room()
		{
			_views = new Array();
		}
		
		public function addView(view:View,direction:uint){
			view.addEventListener(LevelEvent.CHANGE_DIRECTION, handleDirectionChange);
			view.addEventListener(LevelEvent.CHANGE_ROOM, handleRoomChange);
			view.addEventListener(LevelEvent.CHANGE_LEVEL, handleLevelChange);
			_views[direction] = view;
		}
		
		public function update():void{
			_currentView.update();
		}
		public function set direction(nd:uint):void{
			removeCurrentView();
			if(_views[nd] != undefined){
				_currentView = _views[nd];
				addChild(_currentView);
			}
			_direction = nd;
		}
		
		public function get direction():uint{
			return _direction;
		}
		
		public function getView(direction:uint){
			return _views[direction];
		}
		
		protected function removeCurrentView():Boolean{
			var ret = true;
			if(_currentView != null){
				try{
					removeChild(_currentView);
				} catch(er:ArgumentError){
					ret = false;
				}
			} else {
				ret = false;
			}
			return ret;
		}
		
		protected function handleDirectionChange(ev:LevelEvent){
			var dir = ev.direction;
			var nd:uint = direction;
			if(dir == RIGHT){
				nd++;
			} else {
				nd--;
			}
			if(nd == 4){
				nd = 0;
			}
			if(nd > 4){
				nd = 3;
			}
			direction = nd;
		}
		
		protected function handleRoomChange(ev:LevelEvent){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_ROOM);
			evt.room = ev.room;
			evt.direction = ev.direction;
			dispatchEvent(evt);
		}
		
		protected function handleLevelChange(ev:LevelEvent){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = ev.level;
			evt.room = ev.room;
			evt.direction = ev.direction;
			dispatchEvent(evt);
		}
		
	}
}