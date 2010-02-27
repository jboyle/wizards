package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.effects.Effect;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Room3Ft extends Room
	{
		
		public var clickArea:MovieClip;
		public var river:MovieClip;
		
		public var iceBridge:GameObject;
		public function Room3Ft()
		{
			super();
			
			iceBridge.visible = false;
			
			_turnAroundArea.addEventListener(MouseEvent.CLICK,handleTurnAround);
			//river.addEventListener(MouseEvent.CLICK,handleRiverFreeze);
			_spellTargets.push(iceBridge);
			
			setForwardArea(clickArea);
		}
		
		private function handleTurnAround(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("3_bk",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
		private function handleRiverFreeze(ev:MouseEvent){
			trace("freeze river!");
			var effect:Effect = new Effect(Effect.DURATION_FOREVER,0);
			effect.addTag("ice");
			
			iceBridge.addEffect(effect);
		}
		
		override public function update():void{
			var e:Effect = iceBridge.getFirstEffect(["ice"],Effect.MATCH_ONE);
			if(e != null){
				freezeRiver();
			}
		}
		
		public function freezeRiver(){
			iceBridge.visible = true;
			clickArea.buttonMode = true;
			clickArea.addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function handleClick(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("4_ft",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
	}
}