package com.wizards.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class TargetParticle extends MovieClip
	{
		private const DURATION:Number = .35;
		
		private var _origin:Point;
		//private var _destination:Point;
	
		private var _time:uint;
		
		private var _u:Number;
		private var _dist:Point;
		
		private var _rot:Number;
	
		public function TargetParticle()
		{
			super();
			
			var scale:Number = Math.random();
			scaleX = scale;
			scaleY = scale;
			
			_rot = Math.random() * 20;
			alpha = .7

		}
		
		public function run(origin:Point,destination:Point){
			_origin = origin;
			
			_dist = new Point(destination.x - _origin.x, destination.y - _origin.y);
			_u = 0;
			
			x = origin.x;
			y = origin.y;
			
			
			_time = getTimer();
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		public function handleEnterFrame(ev:Event){
			var t = getTimer();
			var diff = (t - _time)/1000;
			_time = t;
			
			_u += diff  / DURATION;
			x = _origin.x + _u*_dist.x;
			y = _origin.y + _u*_dist.y;
			
			rotation += _rot;
			
			if(_u >= 1){
				
				removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				this.parent.removeChild(this);
			}
		}
	}
}