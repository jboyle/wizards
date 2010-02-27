package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.WizardsG;
	import com.wizards.effects.Damage;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	import com.wizards.effects.ModifyingEffect;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Room5Ft extends Room
	{
		public var clickArea:MovieClip;
		public var fader:MovieClip;
		public var healthBar:MovieClip;
		
		public var healthAmount:Number;
		public var healthWidth:Number;
		
		public var spirit:GameObject;
		
		private var fadeU:Number;
		private var fading:Boolean;
		private const FADE_TIME:Number = 2;
		
		
		private var xRange:Point;
		private var yRange:Point;
		private var direction:Point;
		
		private var vel:Number;
		
		public function Room5Ft()
		{
			super();
			
			fader.mouseEnabled = false;
			fader.alpha = 0;
			spirit.alpha = .96;
			
			_turnAroundArea.buttonMode = false;
			
			healthBar.mouseEnabled = false;
			healthWidth = healthBar.bar.width;
			healthAmount = 12;
			
			
			var hp:HitPoints = new HitPoints(healthAmount,Effect.DURATION_FOREVER,0);
			hp.addTag("hp");
			spirit.addEffect(hp);
			
			//spirit.addEventListener(MouseEvent.CLICK,hurtSpirit);
			_spellTargets.push(spirit);
			clickArea.addEventListener(MouseEvent.CLICK,handleClick);
			
			fadeU = 0;
			
			xRange = new Point(100,700);
			yRange = new Point(100,500);
			
			vel = 8;
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
				var healthV:Number = (healthAmount - hp.hitPoints) / healthAmount;
				healthBar.bar.scaleX = 1 - healthV;
				
				if(hp.hitPoints <= 0){
					healthBar.visible = false;
					spirit.visible = false;
					clickArea.buttonMode = true;
				}
			}
			
			if(fading){
				//trace("badger")
				fadeU += WizardsG.TIME_DIFF / FADE_TIME;
				trace(fadeU);
				fader.alpha = fadeU * fadeU;
				//trace(fader.alpha);
				if(fadeU >= 1){
					fader.alpha = 1;
					fading = false;
				}
			}
		}
		
		private function handleClick(ev:Event){
			if(!spirit.visible){
				//var evt:RoomEvent = new RoomEvent("1_bk",RoomEvent.CHANGE_ROOM);
				//dispatchEvent(evt);
				fading = true;
			}
		}
		
	}
}