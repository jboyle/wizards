package com.wizards.util
{
	import flash.events.KeyboardEvent;
	
	public class KeyboardManager
	{
		private var _keysDown:Array;
		public function KeyboardManager()
		{
			_keysDown = new Array();
		}
		
		public function handleKeyDown(ev:KeyboardEvent){
			trace("down");
			if(_keysDown.indexOf(ev.keyCode) != -1){
				_keysDown.push(ev.keyCode);
			}
		}
		
		public function handleKeyUp(ev:KeyboardEvent){
			trace("up");
			var ind = _keysDown.indexOf(ev.keyCode);
			if(ind != -1){
				_keysDown.splice(ind,1);
			}
		}
		
		public function isDown(keyCode:int):Boolean{
			return (_keysDown.indexOf(keyCode) != -1);
		}
		
		
	}
}