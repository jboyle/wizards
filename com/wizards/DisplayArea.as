package com.wizards
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class DisplayArea extends MovieClip
	{
		protected var _activeSymbols:Array;
		protected var _collisions:Array;
		public function DisplayArea()
		{
			_activeSymbols = new Array();
			_collisions = new Array();
		}
		
		public function update(){
			checkCollisions();
		}
		
		public function addSymbol(symbol:Symbol):DisplayObject{
			
			var ind = _activeSymbols.push(symbol);
			//trace(ind);
			_collisions[ind-1] = new Array();
			
			return super.addChild(symbol.clip);
		}
		
		public function removeSymbol(symbol:Symbol):DisplayObject{
			//trace("removing!");
			var ind = _activeSymbols.indexOf(symbol);
			if(ind != -1){
				_activeSymbols.splice(ind,1);
				_collisions.splice(ind,1);
				for(var i in _collisions){
					_collisions[i].splice(ind,1);
				}
			}
			return super.removeChild(symbol.clip);
		}
		
		protected function checkCollisions(){
			
			//collision events will happen when you add or move a symbol
			//uncollision events will ONLY happen when you move a symbol
			for(var i = 0; i < _activeSymbols.length; i++){
				for(var j = i+1; j< _activeSymbols.length; j++){
					if(_activeSymbols[i].clip.hitTestObject(_activeSymbols[j].clip)){
						//they colliding, make sure we don't already know that
						if(_collisions[i][j] == undefined || !_collisions[i][j]){
							_collisions[i][j] = true;
							var ev:CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION, _activeSymbols[i],_activeSymbols[j]);
							dispatchEvent(ev);
						}
					} else {
						if(_collisions[i][j]){
							_collisions[i][j] = false;
							ev = new CollisionEvent(CollisionEvent.UNCOLLISION, _activeSymbols[i], _activeSymbols[j]);
							dispatchEvent(ev);
						}
					}
				}
			}
		}
		
		public function get numSymbols():uint{
			return _activeSymbols.length
		}

	}
}