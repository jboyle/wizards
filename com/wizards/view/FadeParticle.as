package com.wizards.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class FadeParticle extends MovieClip
	{
		
		
		private const FADE_TIME:Number = .75;
		private var _u:Number;
		private var _adiff:Number;
		private var time:uint;
		
		public function FadeParticle()
		{
			super();
			
			_u = 0;
			_adiff = .7;
			time = getTimer();
			
			addEventListener(Event.ENTER_FRAME,handleEnterFrame);
		}
		
		public function handleEnterFrame(ev:Event){
			var t:uint = getTimer();
			var diff:Number = (t - time) / 1000;
			time = t;
			
			_u += diff;
			alpha = _adiff - (_u * _adiff);
			if(_u >= 1){
				removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
				this.parent.removeChild(this);
			}
		}
		
	}
}