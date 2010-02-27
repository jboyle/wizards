package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.effects.Damage;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	import com.wizards.effects.ModifyingEffect;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
		
	public class Room1Ft extends Room
	{
		public var spirit:GameObject;
		public var door:MovieClip;
		
		private var op:Point;
		private var accel:Number;
		private var vel:Number;
		
		private var ohp:Number;
		
		public function Room1Ft()
		{
			super();
			
			spirit.alpha = .96;
			op = new Point(spirit.x, spirit.y);
			
			var hp:HitPoints = new HitPoints(4,Effect.DURATION_FOREVER, 0);
			hp.addTag("hp");
			ohp = hp.hitPoints;
			spirit.addEffect(hp);
			
			_spellTargets.push(spirit);
			
			spirit.addEventListener(MouseEvent.CLICK, handleSpiritClick);
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
			
			setForwardArea(door);
			
			vel = 1;
			accel = .02;
		}
		
		private function handleTurnAround(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("1_bk",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		private function handleSpiritClick(ev:MouseEvent){
			
			var damage:Damage = new Damage(.02,Effect.MATCH_ONE,ModifyingEffect.AFFECT_ALL,Effect.DURATION_TIMED,5);
			damage.addSearchTag("hp");
			damage.time = 5;
			
			spirit.addEffect(damage);
		}
		
		override public function update():void{
			vel += accel;
			spirit.y += vel;
			
			if(spirit.y > op.y){
				accel = -.02;
			}
			if(spirit.y < op.y){
				accel = .02;
			}
			
			spirit.update();
			
			var hp:HitPoints = spirit.getFirstEffect(["hp"],Effect.MATCH_ALL) as HitPoints;
			if(hp != null){
				//trace(hp.hitPoints);
				if(hp.hitPoints < ohp){
					ohp = hp.hitPoints;
					var xdiff = op.x - spirit.x;
					if(xdiff >= 0){
						xdiff = 1;
					} else {
						xdiff = -1
					}
					var xvel = Math.random() * 5 * xdiff;
					spirit.x += xvel;
				}
				if(hp.hitPoints <= 0){
					killSpirit();
				}
			}
			
			super.update();
		}
		
		public function killSpirit(){
			spirit.visible = false;
			door.buttonMode = true;
			door.addEventListener(MouseEvent.CLICK, handleDoorClick);
		}
		
		private function handleDoorClick(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("2_ft",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
	}
}