package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.effects.Damage;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	import com.wizards.effects.ModifyingEffect;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
		
	public class Room1Ft extends Room
	{
		public var spirit:GameObject;
		public var door:MovieClip;
		public function Room1Ft()
		{
			super();
			
			spirit.alpha = .96;
			
			var hp:HitPoints = new HitPoints(4,Effect.DURATION_FOREVER, 0);
			hp.addTag("hp");
			spirit.addEffect(hp);
			
			_spellTargets.push(spirit);
			
			//spirit.addEventListener(MouseEvent.CLICK, handleSpiritClick);
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
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
			spirit.update();
			var hp:HitPoints = spirit.getFirstEffect(["hp"],Effect.MATCH_ALL) as HitPoints;
			if(hp != null){
				trace(hp.hitPoints);
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