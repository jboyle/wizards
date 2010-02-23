package com.wizards
{
	import flash.events.Event;

	public class CollisionEvent extends Event
	{
		//collision events will happen when you add or move a symbol
		//uncollision events will ONLY happen when you move a symbol
		
		public static const COLLISION:String = "collision";
		public static const UNCOLLISION:String = "uncollision";
		
		public var phrase1:Phrase;
		public var phrase2:Phrase;
		
		public function CollisionEvent(type:String, phrase1:Phrase, phrase2:Phrase, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.phrase1 = phrase1;
			this.phrase2 = phrase2;
		}
		
	}
}