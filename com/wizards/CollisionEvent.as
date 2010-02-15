package com.wizards
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class CollisionEvent extends Event
	{
		//collision events will happen when you add or move a symbol
		//uncollision events will ONLY happen when you move a symbol
		
		public static const COLLISION:String = "collision";
		public static const UNCOLLISION:String = "uncollision";
		
		public var object1:Symbol;
		public var object2:Symbol;
		
		public function CollisionEvent(type:String, obj1:Symbol, obj2:Symbol, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			object1 = obj1;
			object2 = obj2;
		}
		
	}
}