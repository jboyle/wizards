package com.wizards
{
	import com.wizards.effects.Effect;
	
	import flash.display.MovieClip;

	public class GameObject extends MovieClip
	{

		
		protected var _tags:Array;
		protected var _effects:Array;
		public function GameObject()
		{
			super();
			_tags = new Array()
			_effects = new Array();
		}
		
		public function update():void{
			var e:Effect;
			for(var i in _effects){
				e = _effects[i];
				e.update();
			}
		}
		
		public function addEffect(effect:Effect):void{
			effect.target = this;
			var e:Effect;
			for(var i = 0; i < _effects.length; i++){
				e = _effects[i];
				if(effect.priority >= e.priority){
					break;
				}
			}
			_effects.splice(i,0,effect);
		}
		
		public function removeEffect(effect:Effect):void{
			effect.target = null;
			var ind = _effects.indexOf(effect);
			if(ind != -1){
				_effects.splice(ind,1);
			}
		}
		
		public function getFirstEffect(tags:Array,matchType:uint):Effect{
			var found:Boolean = false;
			var e:Effect;
			for(var i in _effects){
				e = _effects[i];
				if(e.match(tags,matchType)){
					found = true;
					break;
				}
			}
			if(found){
				return e;
			} else {
				return null;
			}
		}
		
		public function getAllEffects(tags:Array, matchType:uint):Array{
			var ret:Array = new Array();
			for(var i in _effects){
				var e:Effect = _effects[i];
				if(e.match(tags,matchType)){
					ret.push(e);
				}
			}
			return ret;
		}
	}
}