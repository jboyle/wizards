package com.wizards
{
	import flash.display.MovieClip;
	
	public class PhraseTable
	{
		private var _phraseTable:Array;
		public function PhraseTable()
		{
			_phraseTable = new Array();
		}
		
		public function addPhrase(symbol:Symbol):Array{
			var newPhrase:Array = [symbol];
			_phraseTable.push(newPhrase);
			return newPhrase;
		}
		
		public function get table():Array{
			return _phraseTable;
		}
		
		public function removePhrase(phrase:Array):void{
			var ind = _phraseTable.indexOf(phrase);
			if(ind != -1){
				_phraseTable.splice(ind,1);
			}
		}
		
		public function combinePhrases(symbol1:Symbol, symbol2:Symbol):Array{
			//find phrases
			var phrase1:Array;
			var phrase2:Array;
			var phrase1Ind:int;
			var phrase2Ind:int;
			var f1:Boolean = false;
			var f2:Boolean = false;
			for(var i = 0; i < _phraseTable.length; i++){
				for(var j = 0; j < _phraseTable[i].length; j++){
					if(_phraseTable[i][j] == symbol1){
						phrase1 = _phraseTable[i];
						phrase1Ind = i;
						f1 = true;
						break;
					} else if(_phraseTable[i][j] === symbol2){
						phrase2 = _phraseTable[i];
						phrase2Ind = i;
						f2 = true;
						break;
					}				
				}
				if(f1 && f2){
					break;
				}
			}
			
			//combine arrays
			var combinedPhrase:Array = phrase1.concat(phrase2);
			//add combined to location of phrase 1
			_phraseTable[phrase1Ind] = combinedPhrase;
			//remove phrase 2
			_phraseTable.splice(phrase2Ind,1);
			
			return _phraseTable[phrase1Ind];
		}
		
		public function get numPhrases():int{
			return _phraseTable.length;
		}
		
		public function getPhraseAt(index:uint):Array{
			return _phraseTable[index] as Array;
		}

	}
}