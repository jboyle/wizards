package com.wizards.entities
{
	import com.wizards.GameObject;
	import com.wizards.SoundManager;
	import com.wizards.WSound;
	import com.wizards.WizardsG;
	
	import flash.geom.Point;
	
	public class Wraith extends GameObject
	{
		private var cp:Point;
		private var ohp:Number;
		
		private var floatAccel:Number;
		private var floatVel:Number;
		
		private var velMag:Number;
		
		private var xRange:Point;
		private var yRange:Point;
		private var direction:Point;
		
		public var alive:Boolean;
		
		private var gettingHit:Boolean;
		
		private var timer:Number;
		private var time:Number;
		
		public function Wraith()
		{
			super();
			alive = true;
			cp = new Point();
			ohp = hp;
			
			floatAccel = 0.2;
			floatVel = 0;
			
			xRange = new Point(100,700);
			yRange = new Point(100,500);
			direction = new Point(1,1);
			
			velMag = 1000;
			
			this.tags = ["attackable"];
			this.scaleX = 2;
			this.scaleY = 2;
			
			gettingHit = false;
			var s:WSound = SoundManager.MANAGER.loadSound("attack","data/sounds/attackSpell.mp3");
			s.looped = true;
			
			time = .1;
		}
		
		public function setPosition(nx:Number, ny:Number){
			cp.x = nx;
			cp.y = ny;
			x = nx;
			y = ny;
		}
		
		override public function update():void{
			
			_vel.x = (velMag + Math.random()*velMag/2) * direction.x * WizardsG.TIME_DIFF;
			_vel.y = (velMag + Math.random()*velMag/2) * direction.y * WizardsG.TIME_DIFF;
			
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
			
			if(hp < ohp){
				/*if(!gettingHit){
					gettingHit = true;
					timer == 0;
					SoundManager.MANAGER.playSound("attack");
				}*/
				ohp = hp;
				_vel.x += (Math.random() * 16)-8;
				
			} else {
				/*timer += WizardsG.TIME_DIFF;
				if(timer > time){
					SoundManager.MANAGER.stopSound("attack");
					gettingHit = false;
				}*/
				
			}
			
			super.update();
			
		}
		
		override public function kill():void{
			SoundManager.MANAGER.stopSound("attack");
			alive = false;
			super.kill();
		}

	}
}