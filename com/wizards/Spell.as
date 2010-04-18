package com.wizards
{
	import com.wizards.effects.Effect;
	
	import flash.display.MovieClip;
	
	import org.libspark.flartoolkit.core.types.FLARDoublePoint2d;
	public class Spell extends MovieClip
	{
		
		public static const ATTACH_INSTANT:uint = 0;
		public static const ATTACH_DURATION:uint = 1;
		
		public var symbolPoint:MovieClip;
		
		protected var _effect:Effect;
		
		protected var _attach:uint;
		protected var _attachTime:Number;
		protected var _attachTimer:Number;
		
		protected var _tags:Array;
		
		protected var _target:GameObject;
		
		//protected var _markerClip:MovieClip;
		public function Spell(effect:Effect,markerClip:MovieClip, attach:uint = ATTACH_INSTANT, tags:Array = null)
		{
			super();
			
			_effect = effect;
			//_markerClip = markerClip;
			_attach = attach;
			_tags = tags;
			
			markerClip.width = 35;
			markerClip.height = 35;
			symbolPoint.addChild(markerClip);
		}
		
		public function update(){
			
			this.x = WizardsG.MARKER_POSITION.x
			this.y = WizardsG.MARKER_POSITION.y;
			this.rotation = WizardsG.MARKER_ROTATION;
			if(_target == null || !_target.matchTags(_tags)){
				if(_attach == ATTACH_DURATION){
					_attachTimer = 0;
				}
			} else {
				if(_attach == ATTACH_INSTANT){
					_target.addEffect(_effect);
				} else if (_attach == ATTACH_DURATION){
					_attachTimer += WizardsG.TIME_DIFF;
					//update indicator on symbol
					if(_attachTimer > _attachTime){
						target.addEffect(_effect);
					}
				}
			}
			
			
			/*
			//trace("updating "+name+" spell");
			//trace(_target);
			if(active){
				//ie. we're hitting them!
				var toRemove:Array = new Array();
				var e:Effect;
				for(var i in _effects){
					e = _effects[i] as Effect;
					if(e.attach == Effect.ATTACH_ONCE && _target != null){
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
			*/
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