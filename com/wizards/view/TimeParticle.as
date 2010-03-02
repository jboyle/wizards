package com.wizards.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class TimeParticle extends MovieClip
	{
		private const KILL_TIME:Number = 4;
		private var timer:Number;
		private var time:Number;
		public function TimeParticle()
		{
			super();
			time = getTimer();
			timer = 0;
			
			addEventListener(Event.ENTER_FRAME,handleEnterFrame);
		}
		
		function handleEnterFrame(ev:Event){
			var t:uint = getTimer();
			timer += (t - time) / 1000;
			time = t;
			
			if(timer > KILL_TIME){
				removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
				this.parent.removeChild(this);
			}
		}
		
	}
}