package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.effects.Effect;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Room2Ft extends Room
	{
		public var scrap:MovieClip;
		public var scrap_c:MovieClip;
		public var clickArea:MovieClip;
		
		public var iceWall:GameObject;
		public function Room2Ft()
		{
			super();
			
			scrap_c.visible = false;
			iceWall.alpha = .97;
			
			scrap.buttonMode = true;
			scrap_c.buttonMode = true;
			
			scrap.addEventListener(MouseEvent.CLICK, handleScrapClick);
			scrap_c.addEventListener(MouseEvent.CLICK, handleScrapCClick);
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
			
			//iceWall.addEventListener(MouseEvent.CLICK, burnWall);
			_spellTargets.push(iceWall);
			setForwardArea(clickArea);
		}
		
		private function handleTurnAround(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("2_bk",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
		private function handleScrapClick(ev:MouseEvent){
			scrap.visible = false;
			scrap_c.visible = true;
		}
		
		private function handleScrapCClick(ev:MouseEvent){
			scrap.visible = true;
			scrap_c.visible = false;
		}
		
		private function burnWall(ev:MouseEvent){
			var effect:Effect = new Effect(Effect.DURATION_FOREVER,0);
			effect.addTag("fire");
			iceWall.addEffect(effect);
		}
		
		override public function update():void{
			var effect:Effect = iceWall.getFirstEffect(["fire"],Effect.MATCH_ONE);
			if(effect != null){
				meltWall();
			}
		}
		
		public function meltWall(){
			iceWall.visible = false;
			clickArea.buttonMode = true;
			clickArea.addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function handleClick(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("3_ft", RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
	}
}