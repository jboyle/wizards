package com.wizards.entities
{
	import com.wizards.GameObject;
	import com.wizards.WizardsG;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Wraith extends GameObject
	{
		private var cp:Point;
		private var ohp:Number;
		
		private var floatAccel:Number;
		private var floatVel:Number;
		
		private var xRange:Point;
		private var yRange:Point;
		private var direction:Point;
		
		private var vel:Number;
		
		public var alive:Boolean;
		public function Wraith()
		{
			super();
			alive = true;
			cp = new Point();
			
			var hp:HitPoints = new HitPoints(6,Effect.DURATION_FOREVER, 0);
			hp.addTag("hp");
			ohp = hp.hitPoints;
			this.addEffect(hp);
			
			floatAccel = 0.2;
			floatVel = 0;
			
			xRange = new Point(100,700);
			yRange = new Point(100,500);
			direction = new Point(1,1);
			
			vel = 70;
			
		}
		
		public function setPosition(nx:Number, ny:Number){
			cp.x = nx;
			cp.y = ny;
			x = nx;
			y = ny;
		}
		
		override public function update():void{
			
			super.update();
			
			this.x += (vel + Math.random()*vel/2) * direction.x * WizardsG.TIME_DIFF;
			this.y += (vel + Math.random()*vel/2) * direction.y * WizardsG.TIME_DIFF;
			
			if(this.x > xRange.y){
				direction.x = -1;
			} else if(this.x < xRange.x){
				direction.x = 1;
			}
			
			if(this.y > yRange.y){
				direction.y = -1;
			} else if(this.y < yRange.x){
				direction.y = 1;
			}
			
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
					var xvel = Math.random() * 15 * xdiff;
					this.x += xvel;
				}
			} else {
				die();
			}
		}
		
		public function die(){
			alive = false;
			//trace("killMe");
			var ev:Event = new Event("ObjectDie");
			dispatchEvent(ev);
		}

	}
}