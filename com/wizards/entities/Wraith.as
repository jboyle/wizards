package com.wizards.entities
{
	import com.wizards.GameObject;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Wraith extends GameObject
	{
		var cp:Point;
		var ohp:Number;
		
		var floatAccel:Number;
		var floatVel:Number;
		
		var xRange:Point;
		var yRange:Point;
		
		public function Wraith()
		{
			super();
			cp = new Point();
			
			var hp:HitPoints = new HitPoints(4,Effect.DURATION_FOREVER, 0);
			hp.addTag("hp");
			ohp = hp.hitPoints;
			this.addEffect(hp);
			
			floatAccel = 0.2;
			floatVel = 0;
			
		}
		
		public function setPosition(nx:Number, ny:Number){
			cp.x = nx;
			cp.y = ny;
			x = nx;
			y = ny;
		}
		
		override public function update():void{
			
			super.update();
			floatVel += floatAccel;
			this.y += floatVel;
			
			if(this.y > cp.y){
				floatAccel = -.02;
			}
			if(this.y < cp.y){
				floatAccel = .02;
			}
			var hp:HitPoints = this.getFirstEffect(["hp"],Effect.MATCH_ALL) as HitPoints;
			if(hp != null){
				//trace("wraith hitpoints: "+hp.hitPoints);
				if(hp.hitPoints < ohp){
					ohp = hp.hitPoints;
					var xdiff = cp.x - this.x;
					if(xdiff >= 0){
						xdiff = 1;
					} else {
						xdiff = -1
					}
					var xvel = Math.random() * 5 * xdiff;
					this.x += xvel;
				}
			} else {
				die();
			}
		}
		
		public function die(){
			//trace("killMe");
			var ev:Event = new Event("ObjectDie");
			dispatchEvent(ev);
		}

	}
}