package com.wizards.effects
{
	import com.wizards.GameObject;
	
	import flash.events.IEventDispatcher;

	public class Damage extends ModifyingEffect
	{
		private var _amount:Number;

		public function Damage(amount:Number, matchType:uint, affect:uint, duration:uint, priority:uint, target:IEventDispatcher=null)
		{
			super(matchType, affect, duration, priority, target);
			_amount = amount;
		}
		
		override public function update():void{
			var hpEffect:HitPoints
			if(_affect == AFFECT_FIRST){
				hpEffect = _target.getFirstEffect(_searchTags,_matchType) as HitPoints;
				if(hpEffect != null){
					hpEffect.hitPoints -= _amount;
				}
			} else if(_affect == AFFECT_ALL){
				var effects = _target.getAllEffects(_searchTags,_matchType);
				for(var i in effects){
					hpEffect = effects[i] as HitPoints;
					if(hpEffect != null){
						hpEffect.hitPoints -= _amount;
					}
				}
			}
			super.update();
		}
	}
}