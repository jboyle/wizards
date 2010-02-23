package com.wizards.effects
{
	import flash.events.Event;

	public class EffectEvent extends Event
	{
		public static const EFFECT_COMPLETE:String = "complete";
		
		public function EffectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}