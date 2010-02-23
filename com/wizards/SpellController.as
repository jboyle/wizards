package com.wizards
{
	import com.wizards.spells.*;
	
	import flash.events.Event;
	
	public class SpellController
	{
		private var _displayArea:DisplayArea;
		//private var _castingSymbol:Symbol;
		private var _castingPhrase:Phrase;
		private var _castingTimer:Number;
		private var _castingTime:Number;
		private var _casting:Boolean;
		
		//private var _phraseTable:PhraseTable;
		//private var _dirtyTable:Boolean;
		
	/*	private var _syntax:XMLList; // this is the data for the grammar
		private var _spells:XMLList; // this is the data for the spells
		private var _timing:XMLList; // this tells you how long you need to hold the words.*/
		
		//private var _spellFactory:SpellFactory;
		
		private var _phrases:Array;
		
		public var target:GameObject;
		public var selfTarget:GameObject;
		private var _currentTarget:GameObject;
		
		
		public function SpellController(displayArea:DisplayArea)
		{
			_displayArea = displayArea;
			
			_casting = false;
			
			_phrases = new Array();
			//_phraseTable = new PhraseTable();
			//_activeSpells = new Array();
			//_spellFactory = new SpellFactory(spells);
			
			_displayArea.addEventListener(CollisionEvent.COLLISION, handleSymbolCollision);
			_displayArea.addEventListener(CollisionEvent.UNCOLLISION, handleSymbolUncollision);
		}
		
		public function startCast(phrase:Phrase){
			stopCast();
			_castingPhrase = phrase;
			_castingTimer = 0;
			_casting = true;
			//trace("timing: "+_timing[symbol].toString());
			if(WizardsG.TIMING[phrase.lastWord].toString() != ""){
				_castingTime = Number(WizardsG.TIMING[phrase.lastWord].toString());
			} else {
				_castingTime = Number(WizardsG.TIMING.default.toString());
			}
			
			_castingPhrase.clip.alpha = .5;
			_displayArea.addChild(_castingPhrase.clip);
		}
		
		public function stopCast(){
			if(_casting){
				_displayArea.removeChild(_castingPhrase.clip);
				_casting = false;
			}
		}
		
		public function update(){
			//trace("SpellController: start update");
			if(_casting){
				_castingTimer += WizardsG.TIME_DIFF;
				//trace(_castingTimer + " " + _castingTime);
				if(_castingTimer > _castingTime){
					//cast(new Symbol(_castingSymbol.word));
					_casting = false;
					//_displayArea.removeChild(_castingSymbol.clip);
					_castingPhrase.clip.alpha = 1;
					displayPhrase(_castingPhrase);
				}
			}
			
			/*var p:Phrase;
			for(var i in _phrases){
				p = _phrases[i] as Phrase;
				if(p.spell != null && !p.spell.active){
					//p.spell.cast(getTarget(p));
				}
			}*/
			
			//trace("SpellController: finish update");
			/*for(var i in _activeSpells){
				var s:Spell = _activeSpells[i];
				s.update();
			}*/
			
		}
		/*
		public function cast(symbol:Symbol){
			_displayArea.addSymbol(symbol);
			_phraseTable.addPhrase(symbol);
			//trace("added: "+_displayArea.numChildren);
			_dirtyTable = true;
		}*/
		
		/*public function parsePhrases(){
			var toRemove:Array = new Array();
			for(var i = 0; i < _phraseTable.numPhrases; i++){
				var spell:XMLList = WizardsG.SYNTAX;
				var phrase:Array = _phraseTable.getPhraseAt(i);
				for(var j = 0; j < phrase.length; j++){
					var symbol:Symbol = phrase[j];
					spell = spell[symbol.word];
					
					var tar:uint = symbol.target;
					if(tar == Symbol.TARGET_INWARD){
						_currentTarget = selfTarget;
					} else if(tar == Symbol.TARGET_OUTWARD){
						_currentTarget = target;
					}
					
				}
				trace(spell.toString());
				if(spell.toString() == null || spell.toString() == ""){
					trace("bad spell!");
					toRemove.push(phrase);
				} else if(!spell.hasComplexContent()){
					//trace("casting: "+spell.toString());
					castEffect(spell.toString(), phrase);
					//toRemove.push(phrase);
				} //if it has complex content we ignore, because we can add more words later
			}
			for(i = 0; i < toRemove.length; i++){
				_phraseTable.removePhrase(toRemove[i]);
				for(j = 0; j < toRemove[i].length; j++){
					_displayArea.removeSymbol(toRemove[i][j]);
				}
			}
		}*/
		
		public function displayPhrase(phrase:Phrase){
			//trace("displaying phrase, length: "+phrase.words.length);
			//phrase.addEventListener("badSpell",handleBadSpell);
			phrase.addEventListener("spellComplete",handleSpellComplete);
			_displayArea.addPhrase(phrase);
			_phrases.push(phrase);
			castPhrase(phrase);
		}
		
		public function castPhrase(phrase:Phrase){
			//trace("SpellController: casting spell: "+phrase.spellName);
			if(phrase.spellName == "badSpell"){
				clearPhrase(phrase);
			} else if(phrase.spell != null && !phrase.spell.active){
				phrase.spell.cast(getTarget(phrase));
			}
		}
		
		public function clearPhrase(phrase:Phrase){
			//trace("removing phrase");
			var ind:int = _phrases.indexOf(phrase);
			if(ind != -1){
				phrase.nullify();
				_displayArea.removePhrase(phrase);
				//phrase.removeEventListener("badSpell",handleBadSpell);
				phrase.removeEventListener("spellComplete",handleSpellComplete);
				_phrases.splice(ind,1);
			}
		}
		
		private function getTarget(phrase:Phrase):GameObject{
			var ptarget:uint = phrase.target;
			if(ptarget == Phrase.TARGET_INWARD){
				return selfTarget;
			} else if(ptarget == Phrase.TARGET_OUTWARD){
				return target;
			} else {
				return null;
			}
		}
		private function handleSymbolCollision(ev:CollisionEvent){
			//trace("SpellController: handleSymbolCollision");
			clearPhrase(ev.phrase1);
			clearPhrase(ev.phrase2);
			ev.phrase1.concat(ev.phrase2);
			//trace("SpellController: adding new spell");
			//_displayArea.outputPhrase(ev.phrase1);
			displayPhrase(ev.phrase1);
			castPhrase(ev.phrase1);
		}
		
		private function handleSymbolUncollision(ev:CollisionEvent){
			//do nothing for now
		}
		
		private function handleBadSpell(ev:Event){
			trace("handling bad spell");
			var phrase:Phrase = ev.target as Phrase;
			clearPhrase(phrase);
		}
		/*
		private function castEffect(word:String, phrase:Array){
			trace(_spells[word].type);
			var spell:Spell;
			switch(_spells[word].type.toString()){
				case "instantAttack":
					spell = new InstantAttack(phrase,target,_spells[word].dmg);
					break;
				case "instantShield":
					spell = new InstantShield(_spells[word].hp,phrase,target);
					break;
				default:
					trace("could not cast - not implemented yet!");
					break;
			}
			
			var spell:Spell = _spellFactory.createSpell(word,phrase,_currentTarget);
			spell.addEventListener("spellComplete",handleSpellComplete);
			_activeSpells.push(spell);
			spell.cast();
		}*/
		
		private function handleSpellComplete(ev:Event){
			/*trace("badger");
			var spell:Spell = ev.target as Spell;
			var ind = _activeSpells.indexOf(spell);
			trace(ind);
			if(ind != -1){
				_activeSpells.splice(ind, 1);
				_phraseTable.removePhrase(spell.phrase);
				for(var i in spell.phrase){
					var s:Symbol = spell.phrase[i];
					_displayArea.removeSymbol(s);
				}
			}*/
			trace("spell complete");
			var phrase:Phrase = ev.target as Phrase;
			clearPhrase(phrase);
		}
		/*
		private function getSpellByPhrase(phrase:Array):Spell{
			var ret:Spell = null;
			for(var i in _activeSpells){
				var s:Spell = _activeSpells[i] as Spell;
				if(s.phrase === phrase){
					ret = s;
					break;
				}
			}
			return ret;
		}
		*/
		
		/*
		Okay - here's how I need to change this. Phrases should be associated with symbols on the stage. So are spells. that's the link.
		*/
	}
}