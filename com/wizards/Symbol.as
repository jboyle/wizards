package com.wizards
{
	import flash.display.MovieClip;
	
	public class Symbol
	{
		public static const TARGET_NULL:uint = 0;
		public static const TARGET_INWARD:uint = 1;
		public static const TARGET_OUTWARD:uint = 2;
		public static const TARGET_GLOBAL:uint = 3;
		public static const TARGET_WAIT:uint = 4;
		
		private var _word:String;
		private var _clip:MovieClip
		
		public function Symbol(word:String)
		{
			_word = word;
			_clip = createClip();
		}
		
		private function createClip():MovieClip{
			var ret = new SymbolClip();
			ret.type.text = _word;
			
			/*
			* code for getting the movieclips for the different types of symbols here
			*/
			
			return ret;
		}
		
		public function get word():String{
			return _word;
		}
		
		public function set word(newWord:String):void{
			_word = newWord;
			_clip = createClip();
		}
		public function get clip():MovieClip{
			return _clip;
		}
		
		public function get target():uint{
			//actual code will look at orientation of _clip
			if(_word == "defend"){
				return TARGET_INWARD;
			} else if(_word == "attack"){
				return TARGET_OUTWARD;
			} else {
				return TARGET_NULL;
			}
		}
	}
}