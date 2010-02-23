package com.wizards.effects
{
	import com.wizards.GameObject;
	
	import flash.events.IEventDispatcher;

	public class HitPoints extends Effect
	{
		protected var _hitPoints:Number;
		private var _dispatched:Boolean
		public function HitPoints(hitPoints:Number, duration:uint, priority:uint, target:IEventDispatcher=null)
		{
			super(duration, priority, target);
			_hitPoints = hitPoints;
			_dispatched = false;
		}
		
		override public function update():void{
			if(!_dispatched && _hitPoints <= 0){
				completeEffect();
			}
			super.update();
		}
		
		public function get hitPoints():Number{
			return _hitPoints;
		}
		
		public function set hitPoints(nhp:Number):void{
			_hitPoints = nhp;
		}
		
		
		
	}
}