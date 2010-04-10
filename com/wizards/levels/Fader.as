package com.wizards.levels
{
	import com.wizards.WizardsG;
	import com.wizards.WizardsU;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class Fader extends MovieClip
	{
		public static const FADE_IN:uint = 0;
		public static const FADE_OUT:uint = 1;
		public static const FADE_STOP:uint = 2;
		
		private var fadeTimer:Number;
		private var fadeTime:Number;
		private var currentFade:uint
		public function Fader()
		{
			super();
			
			WizardsU.drawRect(new Rectangle(0,0,800,600),0x000000,this);
			this.alpha = 0;
			this.mouseEnabled = false;
			currentFade = FADE_STOP;
		}
		
		public function update(){
			if(currentFade != FADE_STOP){
				fadeTimer += WizardsG.TIME_DIFF;
				var u = fadeTimer / fadeTime;
				if(u > 1){
					if(currentFade == FADE_OUT){
						this.alpha = 1;
					} else if(currentFade == FADE_IN){
						this.alpha = 0;
					}
					currentFade = FADE_STOP;
					dispatchCompleteEvent();
				} else {
					if(currentFade == FADE_OUT){
						this.alpha = u*u;
					} else if(currentFade == FADE_IN){
						this.alpha = 1 - (u*u);
					}
				}
			}
		}
		
		private function dispatchCompleteEvent(){
			var ev:Event = new Event(Event.COMPLETE);
			trace("sending comleteEvent");
			dispatchEvent(ev);
		}
		
		public function startFade(seconds:Number, type:uint){
			fadeTimer = 0;
			fadeTime = seconds;
			currentFade = type;
		}
		
		
	}
}