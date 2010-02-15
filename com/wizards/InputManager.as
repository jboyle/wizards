package com.wizards
{
	/* This will eventually be entirely replaced by the AR Interface...*/
	import flash.events.KeyboardEvent;
	
	public class InputManager
	{
		public static const LEFT:uint = 0;
		public static const RIGHT:uint = 1;
		
		private var _words:Array;
		private var _activeKeys:Array;
		private var _oldActiveKey:Array;
		
		public function InputManager()
		{
			
			_words = new Array();
			_activeKeys = new Array();	
		}
		
		public function addWord(key:uint, word:String, side:uint){
			var obj:Object = new Object();
			obj["word"] = word;
			obj["side"] = side;
			_words[key] = obj;
			
		}
		
		public function get activeWords():Array{
			return _activeKeys;
		}
		
		public function handleKeyDown(ev:KeyboardEvent){
			//trace(ev.keyCode);
			var obj = _words[ev.keyCode];
			if(obj != null && _activeKeys.indexOf(obj) == -1){
				_activeKeys.push(obj);
			}
		}
		
		public function handleKeyUp(ev:KeyboardEvent){
			var ind = _activeKeys.indexOf(_words[ev.keyCode]);
			if(ind != -1){
				_activeKeys.splice(ind,1);
			}
		}
		
		
		public static function getSideVal(side:String):uint{
			if(side.toLowerCase() == "left"){
				return LEFT;
			} else if(side.toLowerCase() == "right"){
				return RIGHT;
			} else {
				return null;
			}
		}
		
		public static function getSideString(side:uint):String{
			if(side == LEFT){
				return "left";
			} else if(side == RIGHT){
				return "right";
			} else {
				return null
			}
		}
	}
}