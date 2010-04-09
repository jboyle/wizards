package com.wizards.levels
{
	import flash.events.Event;

	public class LevelEvent extends Event
	{
		
		public static const CHANGE_LEVEL:String = "changeLevel";
		public static const CHANGE_ROOM:String = "changeRoom";
		public static const CHANGE_DIRECTION:String = "changeDirection";
		
		public var level:uint;
		public var room:String;
		public var direction:uint;
		public function LevelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			level = 0;
			room = "default";
			direction = Room.NORTH;
		}
		
	}
}