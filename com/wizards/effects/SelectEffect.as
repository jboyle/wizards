package com.wizards.effects
{
	import com.wizards.GameObject;
	
	import flash.events.Event;

	public class SelectEffect extends Effect
	{
		private var _selected:Boolean;
		public function SelectEffect()
		{
			super(Effect.DURATION_DEPLETED, 0);
			_selected = false;
		}
		
		override public function set target(newTarget:GameObject):void{
			if(!_selected){
				_target = newTarget;
				_selected = true;
				var ev:Event = new Event("selected");
				_target.dispatchEvent(ev);
			}
		}
		
		override public function update():void{
			if(_selected){
				completeEffect();
			}
		}
	}
}