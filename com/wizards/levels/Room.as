package com.wizards.levels
{
	import com.wizards.GameObject;
	
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
		protected var _active:Boolean;
		
		public function Room()
		{
			_views = new Array();
			_active = false;
		}
		
		public function addView(view:View,direction:uint = 0):void{
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
				_currentView.activate();
				addChild(_currentView);
			}
			_direction = nd;
		}
		
		public function get direction():uint{
			return _direction;
		}
		
		public function get currentView():View{
			return _currentView;
		}
		
		public function getView(direction:uint):View{
			return _views[direction];
		}
		
		public function getSpellCollision(tx:Number, ty:Number):GameObject{
			return _currentView.getSpellCollision(tx,ty);
		}
		
		protected function removeCurrentView():Boolean{
			var ret = true;
			if(_currentView != null){
				try{
					_currentView.deactivate();
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
			trace("Room received CHANGE_DIRECTION event from View");
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
			
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_DIRECTION);
			evt.room = ev.room;
			evt.direction = ev.direction;
			evt.fadeIn = ev.fadeIn;
			dispatchEvent(evt);
		}
		
		protected function handleRoomChange(ev:LevelEvent){
			trace("Room received CHANGE_Room event from View");
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_ROOM);
			evt.room = ev.room;
			evt.direction = ev.direction;
			evt.fadeIn = ev.fadeIn;
			dispatchEvent(evt);
		}
		
		protected function handleLevelChange(ev:LevelEvent){
			trace("Room received CHANGE_LEVEL event from View");
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = ev.level;
			evt.room = ev.room;
			evt.direction = ev.direction;
			evt.fadeIn = ev.fadeIn;
			dispatchEvent(evt);
		}
		
		public function activate():void{
			_active = true;
			if(_currentView != null && !_currentView.active){
				_currentView.activate();
			}
		}
		
		public function deactivate():void{
			_active = false;
			if(_currentView != null && _currentView.active){
				_currentView.deactivate();
			}
		}
		
		public function get active():Boolean{
			return _active;
		}
	}
}