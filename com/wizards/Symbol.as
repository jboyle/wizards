package com.wizards
{
	import flash.display.MovieClip;
	
	public class Symbol
	{
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
	}
}