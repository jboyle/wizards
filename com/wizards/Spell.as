package com.wizards
{
	import com.wizards.effects.Effect;
	import com.wizards.effects.EffectEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class Spell extends EventDispatcher
	{
		
		protected var _effects:Array;
		
		public var name:String;
		public var active:Boolean;
		
		private var _target:GameObject;
		
		public function Spell(name:String, target:IEventDispatcher=null)
		{
			super(target);
			this.name = name;
			active = false;
			target = null;
			
			_effects = new Array();
		}
	
		public function addEffect(effect:Effect):void{
			if(effect.duration != Effect.DURATION_FOREVER){
				effect.addEventListener(EffectEvent.EFFECT_COMPLETE, effectComplete);
				_effects.push(effect);
			}
		}
		
		public function cast(target:GameObject):void{
			active = true;
			trace("casting: "+name);
			/*for(var i in _effects){
				target.addEffect(_effects[i]);
			}*/
		}
		
		public function nullify():void{
			if(active){
				trace("nullifying "+name+" spell");
				var e:Effect;
				for(var i in _effects){
					e = _effects[i];
					if(!e.complete){
						e.removeSelf();
					}
				}
				var ev:Event = new Event("spellNullified");
				dispatchEvent(ev);
			}
		}
		
		private function effectComplete(ev:EffectEvent){
			var allComplete:Boolean = true;
			var e:Effect = ev.target as Effect;
			//e.removeSelf();
			
			//now check to see if all effects are complete
			for(var i in _effects){
				e = _effects[i];
				if(!e.complete){
					allComplete = false;
				}
			}
			if(allComplete){
				//then spell is broken
				trace("spell complete!");
				var evt:Event = new Event("spellComplete");
				dispatchEvent(evt);
			}
		}
		
		public function update(){
			
			if(active && _target != null){
				//ie. we're hitting them!
				var toRemove:Array = new Array();
				var e:Effect;
				for(var i in _effects){
					e = _effects[i] as Effect;
					if(e.attach == Effect.ATTACH_ONCE){
						//trace("updating hit");
						toRemove.push(i);
						_target.addEffect(e);
					} else {
						//trace("updating targeting");
						e.target = _target;
					}
				}
				for(i in toRemove){
					_effects.splice(toRemove[i],1);
				}
				
			}
			for(i in _effects){
				e = _effects[i] as Effect;
				e.update();
			}
		}
		
		public function get target():GameObject{
			return _target;
		}
		
		public function set target(newTarget:GameObject):void{
			if(newTarget != null){
				//trace("hitting target!");
			}
			_target = newTarget;
		}
		
	}
}