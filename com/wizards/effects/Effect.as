package com.wizards.effects
{
	import com.wizards.GameObject;
	import com.wizards.WizardsG;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class Effect extends EventDispatcher
	{
		public static const DURATION_SINGLE:uint = 0;
		public static const DURATION_TIMED:uint = 1;
		public static const DURATION_DEPLETED:uint = 2;
		public static const DURATION_FOREVER:uint = 3;
		
		public static const MATCH_ONE:uint = 0;
		public static const MATCH_ALL:uint = 1;
		public static const MATCH_PERFECT:uint = 2;
		
		public static const ATTACH_ONCE:uint = 0;
		public static const ATTACH_HOLD:uint = 1;
		
		protected var _target:GameObject;
		protected var _priority:uint; //9999 is higher priority than 0;
		protected var _duration:uint;
		protected var _attach:uint;
		protected var _tags:Array;
		
		//for single effects
		protected var _complete:Boolean;
		
		//for timed effects
		protected var _timer:Number;
		protected var _time:Number;
		
		//depletion must be handled by children
		
		public function Effect(duration:uint, priority:uint, target:IEventDispatcher=null)
		{
			super(target);
			
			//_target = gameTarget;
			_target = null;
			_duration = duration;
			_priority = priority;
			
			_attach = ATTACH_ONCE;
			_tags = new Array();
			
			_complete = false;
		}
		
		public function update():void{
			switch(_duration){
				case DURATION_SINGLE:
					if(!_complete){
						completeEffect();
					}
					break;
				case DURATION_TIMED:
					
					_timer += WizardsG.TIME_DIFF;
					//trace(WizardsG.TIME_DIFF);
					//trace("checking time "+_timer+" vs "+_time);
					if(_timer >= _time){
						completeEffect();
						removeSelf();
					}
					break;
			}
			
		}
		
		public function addTag(tag:String):void{
			_tags.push(tag);
		}
		
		public function addTags(tags:Array):void{
			_tags = _tags.concat(tags);
		}
		
		public function set time(time:Number):void{
			_timer = 0;
			_time = time;
		}
		
		public function match(tags:Array,type:uint):Boolean{
			if(type == MATCH_ONE){
				return matchOne(tags);
			} else if(type == MATCH_ALL){
				return matchAll(tags);
			} else if(type == MATCH_PERFECT){
				return matchPerfect(tags);
			} else {
				return false;
			}
			
		}
		
		protected function matchOne(tags:Array){
			var ret:Boolean = false;
			for(var i in tags){
				for(var j in _tags){
					if(tags[i] == _tags[j]){
						trace("found match!: "+tags[i]+"-"+_tags[j]);
						ret = true;
						break;
					}
				}
				if(ret){
					break;
				}
			}
			trace("matching: "+tags +" with: "+_tags + " - "+ret);
			return ret;
		}
		
		protected function matchAll(tags:Array){
			var ret:Boolean = true;
			for(var i in tags){
				var tagMatch = false;
				for(var j in _tags){
					if(tags[i] == _tags[j]){
						tagMatch = true;
						break;
					}
				}
				ret = tagMatch;
				if(!ret){
					break;
				}
			}
			return ret;
		}
		
		protected function matchPerfect(tags:Array){
			if(tags.length == _tags.length){
				return matchAll(tags);
			} else {
				return false;
			}
		}
		
		protected function completeEffect(){
			_complete = true;
			var ev:EffectEvent = new EffectEvent(EffectEvent.EFFECT_COMPLETE);
			dispatchEvent(ev);
		}
		
		public function get duration():uint{
			return _duration;
		}
		
		public function get complete():Boolean{
			return _complete;
		}
		
		public function get priority():uint{
			return _priority;
		}
		
		public function set target(newTarget:GameObject):void{
			_target = newTarget;
		}
		
		public function get target():GameObject{
			return _target;
		}
		
		public function removeSelf(){
			if(_target != null){
				_target.removeEffect(this);
			}
		}
		
		public function set attach(newAttach):void{
			_attach = newAttach;
		}
		
		public function get attach():uint{
			return _attach;
		}
	}
}