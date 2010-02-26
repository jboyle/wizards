package com.wizards.effects
{
	import com.wizards.WizardsG;
	
	import flash.events.IEventDispatcher;

	public class Damage extends ModifyingEffect
	{
		private var _amount:Number;

		public function Damage(amount:Number, matchType:uint, affect:uint, duration:uint, priority:uint, target:IEventDispatcher=null)
		{
			super(matchType, affect, duration, priority, target);
			_amount = amount;
		}
		
		override public function set time(newTime:Number):void{
			super.time = newTime;
			if(_duration == Effect.DURATION_TIMED){
				_amount = _amount/_time;
			}
		}
		
		override public function update():void{
			//trace("badger");
			if(_target != null){
				var hpEffect:HitPoints
				if(_affect == AFFECT_FIRST){
					hpEffect = _target.getFirstEffect(_searchTags,_matchType) as HitPoints;
					if(hpEffect != null){
						doDamage(hpEffect);
					}
				} else if(_affect == AFFECT_ALL){
					var effects = _target.getAllEffects(_searchTags,_matchType);
					for(var i in effects){
						hpEffect = effects[i] as HitPoints;
						if(hpEffect != null){
							doDamage(hpEffect);
						}
					}
				}
			}
			super.update();
		}
		
		private function doDamage(hp:HitPoints){
			if(_duration == Effect.DURATION_TIMED){
				
				if(_timer + WizardsG.TIME_DIFF > _time){
					hp.hitPoints -= _amount * (_time - _timer);
				} else {
					hp.hitPoints -= _amount * WizardsG.TIME_DIFF;
				}
			} else {
				hp.hitPoints -= _amount;
			}
		}
	}
}