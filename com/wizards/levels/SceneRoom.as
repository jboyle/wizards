package com.wizards.levels
{
	public class SceneRoom extends Room
	{
		public function SceneRoom()
		{
			super();
		}
		
		override public function addView(view:View, direction:uint = 0):void{
			
			_currentView = view;
			_direction = direction;
			_currentView.addEventListener(LevelEvent.CHANGE_DIRECTION, handleDirectionChange);
			_currentView.addEventListener(LevelEvent.CHANGE_ROOM, handleRoomChange);
			_currentView.addEventListener(LevelEvent.CHANGE_LEVEL, handleLevelChange);
			addChild(_currentView);
		}
		
		override public function set direction(nd:uint):void{
			_direction = nd;
		}
		
		override public function getView(direction:uint):View{
			return _currentView;
		}
		
	}
}