package com.wizards
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class DisplayArea extends MovieClip
	{
		protected var _phrases:Array;
		protected var _collisions:Array;
		public function DisplayArea()
		{
			_phrases = new Array();
			_collisions = new Array();
		}
		
		public function update(){
			//trace("DisplayArea: start update");
			checkCollisions();
			//trace("DisplayArea: finish update");
		}
		
		public function addPhrase(phrase:Phrase){
			//trace("Adding phrase to DisplayArea");
			//outputPhrase(phrase);
			var ind = _phrases.push(phrase);
			//trace(ind);
			_collisions[ind-1] = new Array();
			
			if(phrase.clip.parent == null || phrase.clip.parent != this){
				super.addChild(phrase.clip);
			}
			
		}
		
		public function removePhrase(phrase:Phrase):DisplayObject{
			//trace("removing!");
			var ind = _phrases.indexOf(phrase);
			if(ind != -1){
				_phrases.splice(ind,1);
				_collisions.splice(ind,1);
				for(var i in _collisions){
					_collisions[i].splice(ind,1);
				}
			}
			return super.removeChild(phrase.clip);
		}
		
		protected function checkCollisions(){
			//collision events will happen when you add or move a symbol
			//uncollision events will ONLY happen when you move a symbol
			for(var i = 0; i < _phrases.length; i++){
				for(var j = i+1; j< _phrases.length; j++){
					if(_phrases[i].clip.hitTestObject(_phrases[j].clip)){
						//they colliding, make sure we don't already know that
						if(_collisions[i][j] == undefined || !_collisions[i][j]){
							_collisions[i][j] = true;
							trace("found new collision");
							var ev:CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION, _phrases[i],_phrases[j]);
							dispatchEvent(ev);
						}
					} else {
						if(_collisions[i][j]){
							_collisions[i][j] = false;
							ev = new CollisionEvent(CollisionEvent.UNCOLLISION, _phrases[i], _phrases[j]);
							dispatchEvent(ev);
						}
					}
				}
			}
		}
		
		public function get numPhrases():uint{
			return _phrases.length
		}
		
		/*public function outputPhrases(){
			trace("DisplayArea: active phrases");
			for(var i in _phrases){
				var p:Phrase = _phrases[i];
				trace("\tphrase:");
				outputPhrase(p);
			}
		}
		
		public function outputPhrase(phrase:Phrase){
			for(var i in phrase.words){
				trace("\t\tword: "+phrase.words[i]);
			}
		}*/

	}
}