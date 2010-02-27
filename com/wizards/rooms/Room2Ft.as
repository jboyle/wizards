package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Room2Ft extends Room
	{
		public var scrap:MovieClip;
		public var scrap_c:GameObject;
		public var clickArea:MovieClip;
		
		public var iceWall:GameObject;
		
		private var _oy:Number;
		public function Room2Ft()
		{
			super();
			
			_oy = scrap_c.y;
			
			scrap_c.visible = false;
			scrap_c.y = 1200;
			var hp:HitPoints = new HitPoints(1,Effect.DURATION_FOREVER,0);
			hp.addTag("hp");
			scrap_c.addEffect(hp);
			
			iceWall.alpha = .97;
			
			scrap.buttonMode = true;
			scrap_c.buttonMode = true;
			
			scrap.addEventListener(MouseEvent.CLICK, handleScrapClick);
			scrap_c.addEventListener(MouseEvent.CLICK, handleScrapCClick);
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
			
			//iceWall.addEventListener(MouseEvent.CLICK, burnWall);
			_spellTargets.push(scrap_c);
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
			scrap_c.y = _oy;
			
		}
		
		private function handleScrapCClick(ev:MouseEvent){
			scrap.visible = true;
			scrap_c.visible = false;
			scrap_c.y = 1200;
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
			
			var hp:HitPoints = scrap_c.getFirstEffect(["hp"],Effect.MATCH_ALL) as HitPoints;
			if(hp != null){
				if(hp.hitPoints <= 0){
					scrap_c.visible = false;
					scrap_c.y = 1200;
					scrap.visible = true;
				}
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