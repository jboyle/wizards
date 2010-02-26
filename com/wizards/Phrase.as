package com.wizards
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Phrase extends EventDispatcher
	{
		public static const TARGET_NULL:uint = 0;
		public static const TARGET_INWARD:uint = 1;
		public static const TARGET_OUTWARD:uint = 2;
		public static const TARGET_GLOBAL:uint = 3;
		public static const TARGET_WAIT:uint = 4;
		
		private var _words:Array;
		private var _clip:MovieClip;
		private var _spellName:String;
		private var _spell:Spell;
		
		public var crossHairsClip:MovieClip;
		public var fixed:Boolean;
		
		public function Phrase(word:String, target:IEventDispatcher=null)
		{
			super(target);
			words = [word];
			crossHairsClip = null;
			fixed = false;
			//getSpellName();
			//createClip();
		}
		
		private function createClip():MovieClip{
			//trace("creating clip for "+_spellName);
			if(_spellName == ""){
				_clip = new MovieClip();
				var u:Number = 1 / _words.length;
				for(var i in _words){
					var word:MovieClip = new SymbolClip();
					word.type.text = _words[i];
					word.alpha = 1 - u*i;
					_clip.addChild(word);
				}
			} else {
				//trace("setting clip text to: "+_spellName);
				_clip = new SymbolClip();
				_clip.type.text = _spellName;
			}
			/*
			* code for getting the movieclips for the different types of symbols here
			* --But not really! It will be in the symbolclip class.
			*/
			return _clip;

		}
		
		private function setSpellName():String{
			trace(_words);
			var spellement:XMLList = WizardsG.SYNTAX;
			for(var i in _words){
				spellement = spellement[_words[i]];
			}
			trace("looking for a spell named: "+spellement.toString());
			if(spellement.toString() == null || spellement.toString() == ""){
				trace("bad spell!");
				_spellName = "badSpell";
			} else if(!spellement.hasComplexContent()){
				_spellName = spellement.toString();
				createSpell();
			} else {
				//if it has complex content we ignore, because we can add more words later
				_spellName = "";
			}
			return _spellName;
		}
		
		private function createSpell():Spell{
			_spell = SpellFactory.createSpell(_spellName);
			_spell.addEventListener("spellComplete",spellComplete);
			
			return _spell;
		}

		public function nullify():void{
			if(_spell != null){
				_spell.nullify();
				_spell = null;
			}
		}

		public function concat(phrase:Phrase){
			var nx:Number = clip.x;
			var ny:Number = clip.y;
			words = phrase.words.concat(_words);
			clip.x = nx;
			clip.y = ny;
			
		}
		
		public function get words():Array{
			return _words;
		}
		
		public function set words(newArray:Array):void{
			_words = newArray;
			trace("setting words to: "+_words);
			setSpellName();
			createClip();
		}
		
		public function get lastWord():String{
			return _words[_words.length-1];
		}
		
		public function get target():uint{
			//actual code will look at orientation of _clip
			var word:String = lastWord;
			if(word == "defend"){
				return TARGET_INWARD;
			} else if(word == "attack"){
				return TARGET_OUTWARD;
			} else {
				return TARGET_NULL;
			}
		}
		
		public function get clip():MovieClip{
			return _clip;
		}
		
		public function get spell():Spell{
			return _spell;
		}
		
		public function get spellName():String{
			return _spellName
		}
		
		private function spellComplete(ev:Event){
			//trace("phrase: spellComplete received");
			var evt:Event = new Event("spellComplete");
			dispatchEvent(evt);
		}
	}
}