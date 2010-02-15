package com.wizards
{
	import flash.display.MovieClip;
	
	public class SpellController
	{
		private var _displayArea:DisplayArea;
		private var _castingSymbol:Symbol;
		private var _castingTimer:Number;
		private var _castingTime:Number;
		private var _casting:Boolean;
		
		private var _phraseTable:PhraseTable;
		private var _dirtyTable:Boolean;
		
		private var _syntax:XMLList; // this is the data for the grammar
		private var _spells:XMLList; // this is the data for the spells
		private var _timing:XMLList; // this tells you how long you need to hold the words.
		
		public function SpellController(displayArea:DisplayArea, syntax:XMLList, timing:XMLList)
		{
			_displayArea = displayArea;
			_syntax = syntax;
			_timing = timing;
			
			_casting = false;
			_dirtyTable = false;
			
			_phraseTable = new PhraseTable();
			
			_displayArea.addEventListener(CollisionEvent.COLLISION, handleSymbolCollision);
			_displayArea.addEventListener(CollisionEvent.UNCOLLISION, handleSymbolUncollision);
		}
		
		public function startCast(symbol:Symbol){
			_castingSymbol = symbol;
			_castingTimer = 0;
			_casting = true;
			//trace("timing: "+_timing[symbol].toString());
			if(_timing[symbol.word].toString() != ""){
				_castingTime = Number(_timing[symbol.word].toString());
			} else {
				_castingTime = Number(_timing.default.toString());
			}
			
			_castingSymbol.clip.alpha = .5;
			_displayArea.addChild(_castingSymbol.clip);
		}
		
		public function stopCast(){
			if(_casting){
				_displayArea.removeChild(_castingSymbol.clip);
				_casting = false;
			}
		}
		
		public function update(){
			if(_dirtyTable){
				parsePhrases();
				_dirtyTable = false;
			}
			if(_casting){
				_castingTimer += WizardsG.TIME_DIFF;
				//trace(_castingTimer + " " + _castingTime);
				if(_castingTimer > _castingTime){
					cast(new Symbol(_castingSymbol.word));
					_casting = false;
					_displayArea.removeChild(_castingSymbol.clip);
				}
			}
			
		}
		
		public function cast(symbol:Symbol){
			_displayArea.addSymbol(symbol);
			_phraseTable.addPhrase(symbol);
			//trace("added: "+_displayArea.numChildren);
			_dirtyTable = true;
		}
		
		public function parsePhrases(){
			var toRemove:Array = new Array();
			for(var i = 0; i < _phraseTable.numPhrases; i++){
				var spell:XMLList = _syntax;
				var phrase:Array = _phraseTable.getPhraseAt(i);
				for(var j = 0; j < phrase.length; j++){
					var symbol:Symbol = phrase[j];
					spell = spell[symbol.word];
				}
				//trace(spell.toString());
				if(spell.toString() == null || spell.toString() == ""){
					trace("bad spell!");
					toRemove.push(phrase);
				} else if(!spell.hasComplexContent()){
					trace("casting: "+spell.toString());
					toRemove.push(phrase);
				} //if it has complex content we ignore, because we can add more words later
			}
			for(i = 0; i < toRemove.length; i++){
				_phraseTable.removePhrase(toRemove[i]);
				for(j = 0; j < toRemove[i].length; j++){
					_displayArea.removeSymbol(toRemove[i][j]);
				}
			}
		}
		
		private function handleSymbolCollision(ev:CollisionEvent){
			_phraseTable.combinePhrases(ev.object1,ev.object2);
			_dirtyTable = true;
		}
		
		private function handleSymbolUncollision(ev:CollisionEvent){
			//do nothing for now
		}
		
		
	}
}