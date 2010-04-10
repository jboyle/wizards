﻿package com.wizards{		import com.wizards.view.Crosshair;
	
	import flash.display.MovieClip;
	import flash.events.Event;		public class SpellController	{		private var _displayArea:DisplayArea;		//private var _castingSymbol:Symbol;		private var _castingPhrase:Phrase;		private var _castingTimer:Number;		private var _castingTime:Number;		private var _casting:Boolean;				private var _castingPhrases:Array;		private var _castingTimers:Array;		private var _castingTimes:Array;						//private var _phraseTable:PhraseTable;		//private var _dirtyTable:Boolean;			/*	private var _syntax:XMLList; // this is the data for the grammar		private var _spells:XMLList; // this is the data for the spells		private var _timing:XMLList; // this tells you how long you need to hold the words.*/				//private var _spellFactory:SpellFactory;				private var _phrases:Array;				public var target:GameObject;		public var selfTarget:GameObject;		private var _currentTarget:GameObject;				public function SpellController(displayArea:DisplayArea)		{			_displayArea = displayArea;						_casting = false;						_phrases = new Array();			_castingPhrases = new Array();			_castingTimers = new Array();			_castingTimes = new Array();						//_phraseTable = new PhraseTable();			//_activeSpells = new Array();			//_spellFactory = new SpellFactory(spells);						_displayArea.addEventListener(CollisionEvent.COLLISION, handleSymbolCollision);			_displayArea.addEventListener(CollisionEvent.UNCOLLISION, handleSymbolUncollision);		}				public function startCast(phrase:Phrase){			/*stopCast();			_castingPhrase = phrase;			_castingTimer = 0;			_casting = true;			//trace("timing: "+_timing[symbol].toString());			if(WizardsG.TIMING[phrase.lastWord].toString() != ""){				_castingTime = Number(WizardsG.TIMING[phrase.lastWord].toString());			} else {				_castingTime = Number(WizardsG.TIMING.default.toString());			}			*/			_castingPhrases.push(phrase);			_castingTimers.push(0);			if(WizardsG.TIMING[phrase.lastWord].toString() != ""){				_castingTimes.push(Number(WizardsG.TIMING[phrase.lastWord].toString()));			} else {				_castingTimes.push(Number(WizardsG.TIMING.default.toString()));			}			phrase.clip.alpha = .5;			_displayArea.addChild(phrase.clip);		}				public function stopCast(phrase:Phrase){			/*if(_casting){				_displayArea.removeChild(_castingPhrase.clip);				_casting = false;			}*/			//trace("stopping cast");			var ind:int = _castingPhrases.indexOf(phrase);			if(ind != -1){				_displayArea.removeChild(phrase.clip);				_castingPhrases.splice(ind,1);				_castingTimers.splice(ind,1);				_castingTimes.splice(ind,1);			}		}				public function update(){			//trace("SpellController: start update");			/*if(_casting){				_castingTimer += WizardsG.TIME_DIFF;				//trace(_castingTimer + " " + _castingTime);				if(_castingTimer > _castingTime){					//cast(new Symbol(_castingSymbol.word));					_casting = false;					//_displayArea.removeChild(_castingSymbol.clip);					_castingPhrase.clip.alpha = 1;					displayPhrase(_castingPhrase);				}			}*/			var toRemove:Array = new Array();			for(var i = 0; i < _castingPhrases.length; i++){				_castingTimers[i] += WizardsG.TIME_DIFF;				if(_castingTimers[i] >= _castingTimes[i]){					toRemove.push(i);					_castingPhrases[i].clip.alpha = 1;					displayPhrase(_castingPhrases[i]);				}			}			for(i = 0; i < toRemove.length; i++){				var ind:int = toRemove[i];				_castingPhrases.splice(ind,1);				_castingTimers.splice(ind,1);				_castingTimes.splice(ind,1);			}						var p:Phrase;			for(i = 0; i < _phrases.length; i++){				p = _phrases[i] as Phrase;				//trace(p);				if(p.spell != null){					p.spell.update();				}			}						//trace("SpellController: finish update");			/*for(var i in _activeSpells){				var s:Spell = _activeSpells[i];				s.update();			}*/					}		/*		public function cast(symbol:Symbol){			_displayArea.addSymbol(symbol);			_phraseTable.addPhrase(symbol);			//trace("added: "+_displayArea.numChildren);			_dirtyTable = true;		}*/				/*public function parsePhrases(){			var toRemove:Array = new Array();			for(var i = 0; i < _phraseTable.numPhrases; i++){				var spell:XMLList = WizardsG.SYNTAX;				var phrase:Array = _phraseTable.getPhraseAt(i);				for(var j = 0; j < phrase.length; j++){					var symbol:Symbol = phrase[j];					spell = spell[symbol.word];										var tar:uint = symbol.target;					if(tar == Symbol.TARGET_INWARD){						_currentTarget = selfTarget;					} else if(tar == Symbol.TARGET_OUTWARD){						_currentTarget = target;					}									}				trace(spell.toString());				if(spell.toString() == null || spell.toString() == ""){					trace("bad spell!");					toRemove.push(phrase);				} else if(!spell.hasComplexContent()){					//trace("casting: "+spell.toString());					castEffect(spell.toString(), phrase);					//toRemove.push(phrase);				} //if it has complex content we ignore, because we can add more words later			}			for(i = 0; i < toRemove.length; i++){				_phraseTable.removePhrase(toRemove[i]);				for(j = 0; j < toRemove[i].length; j++){					_displayArea.removeSymbol(toRemove[i][j]);				}			}		}*/				public function displayPhrase(phrase:Phrase){			//trace("displaying phrase, length: "+phrase.words.length);			//phrase.addEventListener("badSpell",handleBadSpell);			phrase.addEventListener("spellComplete",handleSpellComplete);			//phrase.fixed = true;			_displayArea.addPhrase(phrase);			_phrases.push(phrase);			castPhrase(phrase);		}				public function castPhrase(phrase:Phrase){			//trace("SpellController: casting spell: "+phrase.spellName);			if(phrase.spellName == "badSpell"){				var bs:MovieClip = new BrokenSymbol();				bs.x = phrase.clip.x;				bs.y = phrase.clip.y;				_displayArea.addChild(bs);				clearPhrase(phrase);							} else if(phrase.spell != null && !phrase.spell.active){				phrase.spell.cast(null);				phrase.crossHairsClip = new Crosshair();				_displayArea.addChildAt(phrase.crossHairsClip, 0);			}		}				public function clearPhrase(phrase:Phrase){						var ind:int = _phrases.indexOf(phrase);			//trace(ind);			if(ind != -1){				phrase.nullify();				//trace(phrase.clip.parent);				if(phrase.clip.parent == _displayArea){					trace("removing phrase");					_displayArea.removePhrase(phrase);				}				//_displayArea.removePhrase(phrase);				if(phrase.crossHairsClip != null && phrase.crossHairsClip.parent == _displayArea){					_displayArea.removeChild(phrase.crossHairsClip);				}				//phrase.removeEventListener("badSpell",handleBadSpell);				phrase.removeEventListener("spellComplete",handleSpellComplete);				_phrases.splice(ind,1);			}		}				private function getTarget(phrase:Phrase):GameObject{			var ptarget:uint = phrase.target;			if(ptarget == Phrase.TARGET_INWARD){				return selfTarget;			} else if(ptarget == Phrase.TARGET_OUTWARD){				return target;			} else {				return null;			}		}		private function handleSymbolCollision(ev:CollisionEvent){			//trace("SpellController: handleSymbolCollision");			clearPhrase(ev.phrase1);			clearPhrase(ev.phrase2);			ev.phrase2.concat(ev.phrase1);			//trace("SpellController: adding new spell");			//_displayArea.outputPhrase(ev.phrase1);			displayPhrase(ev.phrase2);			castPhrase(ev.phrase2);		}				private function handleSymbolUncollision(ev:CollisionEvent){			//do nothing for now		}				private function handleBadSpell(ev:Event){			//trace("handling bad spell");			var phrase:Phrase = ev.target as Phrase;			clearPhrase(phrase);		}		/*		private function castEffect(word:String, phrase:Array){			trace(_spells[word].type);			var spell:Spell;			switch(_spells[word].type.toString()){				case "instantAttack":					spell = new InstantAttack(phrase,target,_spells[word].dmg);					break;				case "instantShield":					spell = new InstantShield(_spells[word].hp,phrase,target);					break;				default:					trace("could not cast - not implemented yet!");					break;			}						var spell:Spell = _spellFactory.createSpell(word,phrase,_currentTarget);			spell.addEventListener("spellComplete",handleSpellComplete);			_activeSpells.push(spell);			spell.cast();		}*/				private function handleSpellComplete(ev:Event){			/*trace("badger");			var spell:Spell = ev.target as Spell;			var ind = _activeSpells.indexOf(spell);			trace(ind);			if(ind != -1){				_activeSpells.splice(ind, 1);				_phraseTable.removePhrase(spell.phrase);				for(var i in spell.phrase){					var s:Symbol = spell.phrase[i];					_displayArea.removeSymbol(s);				}			}*/			//trace("spell complete");			var phrase:Phrase = ev.target as Phrase;			clearPhrase(phrase);		}		/*		private function getSpellByPhrase(phrase:Array):Spell{			var ret:Spell = null;			for(var i in _activeSpells){				var s:Spell = _activeSpells[i] as Spell;				if(s.phrase === phrase){					ret = s;					break;				}			}			return ret;		}		*/				/*		Okay - here's how I need to change this. Phrases should be associated with symbols on the stage. So are spells. that's the link.		Done!		*/				public function clearAllPhrases(){			var toClear:Array = _phrases.slice();						var p:Phrase;			for(var i = 0; i < toClear.length; i++){				p = toClear[i] as Phrase;				clearPhrase(p);			}						toClear = _castingPhrases.slice();			var ind:Number;			for(i=0; i < toClear.length; i++){				p = _castingPhrases[i] as Phrase;				_displayArea.removeChild(p.clip);				ind = _castingPhrases.indexOf(p);				_castingPhrases.splice(ind,1);				_castingTimers.splice(ind,1);				_castingTimes.splice(ind,1);			}					}	}}