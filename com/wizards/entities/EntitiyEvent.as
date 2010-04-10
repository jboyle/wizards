package com.wizards.entities
{
	import flash.events.Event;

	public class EntitiyEvent extends Event
	{
		public function EntitiyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}