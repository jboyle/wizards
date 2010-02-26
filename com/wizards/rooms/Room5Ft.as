package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.effects.Damage;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	import com.wizards.effects.ModifyingEffect;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Room5Ft extends Room
	{
		public var clickArea:MovieClip;
		
		public var spirit:GameObject;
		public function Room5Ft()
		{
			super();
			
			spirit.alpha = .96;
			
			_turnAroundArea.buttonMode = false;
			
			var hp:HitPoints = new HitPoints(10,Effect.DURATION_FOREVER,0);
			hp.addTag("hp");
			spirit.addEffect(hp);
			
			//spirit.addEventListener(MouseEvent.CLICK,hurtSpirit);
			_spellTargets.push(spirit);
			clickArea.addEventListener(MouseEvent.CLICK,handleClick);
		}
		
		private function hurtSpirit(ev:MouseEvent){
			//trace("badger");
			var damage:Damage = new Damage(.02,Effect.MATCH_ONE,ModifyingEffect.AFFECT_ALL, Effect.DURATION_TIMED,2);
			damage.addSearchTag("hp");
			damage.time = 1;
			
			spirit.addEffect(damage);
		}
		
		override public function update():void{
			
			spirit.update();
			
			var hp:HitPoints = spirit.getFirstEffect(["hp"],Effect.MATCH_ONE) as HitPoints;
			if(hp != null){
				trace(hp.hitPoints);
				if(hp.hitPoints <= 0){
					spirit.visible = false;
					clickArea.buttonMode = true;
				}
			}
		}
		
		private function handleClick(ev:Event){
			if(!spirit.visible){
				var evt:RoomEvent = new RoomEvent("1_bk",RoomEvent.CHANGE_ROOM);
				dispatchEvent(evt);
			}
		}
		
	}
}