package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.WizardsG;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	import com.wizards.view.TargetParticle;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Room1Bk extends Room
	{
		
		private const FADE_TIME:Number = 1.3;
		
		public var scrap1:MovieClip;
		public var scrap1_c:GameObject;
		
		public var fader:MovieClip;
		public var fading:Boolean;
		public var fadeU:Number;
		public function Room1Bk()
		{
			super();
			scrap1_c.visible =false;
			
			var hp:HitPoints = new HitPoints(1,Effect.DURATION_FOREVER,0);
			hp.addTag("hp");
			scrap1_c.addEffect(hp);
			
			_spellTargets.push(scrap1_c);
			
			scrap1.buttonMode = true;
			scrap1_c.buttonMode = true;
			
			scrap1.addEventListener(MouseEvent.CLICK,handleScrap1Click);
			scrap1_c.addEventListener(MouseEvent.CLICK,handleScrap1CClick);
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
			
			fading = true;
			fadeU = 0;
			fader.mouseEnabled = false;
		}
		
		private function handleScrap1Click(ev:Event){
			scrap1.visible = false;
			scrap1_c.visible = true;
		}
		
		private function handleScrap1CClick(ev:Event){
			scrap1.visible = true;
			scrap1_c.visible = false;
		}
		
		private function handleTurnAround(ev:Event){
			var evt:RoomEvent = new RoomEvent("1_ft",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
		override public function update():void{
			var hp:HitPoints = scrap1_c.getFirstEffect(["hp"],Effect.MATCH_ALL) as HitPoints;
			if(hp != null){
				if(hp.hitPoints <= 0){
					scrap1_c.visible = false;
					scrap1.visible = true;
				}
			}
			
			if(fading){
				fadeU += WizardsG.TIME_DIFF / FADE_TIME;
				fader.alpha = 1 - (fadeU * fadeU);
				if(fadeU >= 1){
					fading = false;
					fader.alpha = 0;
				}
			}
		}
		
	}
}