package com.wizards
{
	import com.wizards.effects.Effect;
	import com.wizards.effects.EffectEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	public class GameObject extends MovieClip
	{

		
		protected var _pos:Point;
		protected var _vel:Point;
		protected var _offensive:Boolean;
		protected var _hitPoints:Number;
		
		protected var _tags:Array;
		protected var _effects:Array;
		public function GameObject()
		{
			super();
			_tags = new Array()
			_effects = new Array();
			
			_pos = new Point();
			_vel = new Point();
			_offensive = false;
			_hitPoints = 20;
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function handleAddedToStage(ev:Event){
			_pos.x = x;
			_pos.y = y;
		}
		
		public function update():void{
			var e:Effect;
			//trace("effects: "+_effects);
			for(var i in _effects){
				e = _effects[i];
				e.update();
			}
			
			_pos.add(_vel);
			_pos.x += _vel.x * WizardsG.TIME_DIFF;
			_pos.y += _vel.y * WizardsG.TIME_DIFF;
			x = _pos.x;
			y = _pos.y;
			
			if(_hitPoints <= 0){
				kill();
			}
		}
		
		public function hurt(amount:Number):void{
			_hitPoints -= amount;
		}
		
		public function kill():void{
			var ev:Event = new Event("killed");
			dispatchEvent(ev);
		}
		
		public function addEffect(effect:Effect):void{
			if(_effects.indexOf(effect) == -1){
				effect.target = this;
				effect.addEventListener(EffectEvent.EFFECT_COMPLETE, handleEffectComplete);
				_effects.push(effect);
			}
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
		
		public function matchTags(matchTags:Array):Boolean{
			var ret:Boolean = true;
			for(var i in matchTags){
				if(_tags.indexOf(matchTags[i]) == -1){
					ret = false;
				}
			}
			return ret;
		}
		
		protected function handleEffectComplete(ev:EffectEvent){
			trace("handling EffectComplete");
			var effect:Effect = ev.target as Effect;
			removeEffect(effect);
		}
		
		public function get pos():Point{
			return _pos;
		}
		
		public function set pos(np:Point):void{
			_pos = np;
		}
		
		public function get vel():Point{
			return _vel;
		}
		
		public function set vel(np:Point):void{
			_vel = np;
		}
		
		public function get hp():Number{
			return _hitPoints;
		}
		
		public function set hp(nhp:Number):void{
			_hitPoints = nhp;
		}
		
		public function get offensive():Boolean{
			return _offensive;
		}
		
		public function set offensive(offen:Boolean){
			_offensive = offen;
		}
		
		public function get effects():Array{
			return _effects;
		}
		
		public function get tags():Array{
			return _tags;
		}
		
		public function set tags(newTags:Array):void{
			_tags = newTags;
		}
	}
}