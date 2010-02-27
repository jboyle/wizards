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
	import flash.filters.GlowFilter;
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
		private var ohp:Number;
		
		private var freezeFilter:GlowFilter;
		private var normalFilter:GlowFilter;
		
		private var attackTimer:Number;
		private const ATTACK_TIME:Number = 20;
		
		public function Room5Ft()
		{
			super();
			
			fader.mouseEnabled = false;
			fader.alpha = 0;
			spirit.alpha = .96;
			
			_turnAroundArea.buttonMode = false;
			
			healthBar.mouseEnabled = false;
			healthWidth = healthBar.bar.width;
			healthAmount = 24;
			ohp = healthAmount;
			
			
			var hp:HitPoints = new HitPoints(healthAmount,Effect.DURATION_FOREVER,0);
			hp.addTag("hp");
			spirit.addEffect(hp);
			
			//spirit.addEventListener(MouseEvent.CLICK,hurtSpirit);
			_spellTargets.push(spirit);
			clickArea.addEventListener(MouseEvent.CLICK,handleClick);
			
			fadeU = 0;
			
			xRange = new Point(100,700);
			yRange = new Point(100,500);
			direction = new Point(1,1);
			vel = 220;
			
			freezeFilter = new GlowFilter(0x1182CC,.8,74,74,3);
			normalFilter = new GlowFilter(0x61B9F3,.8,64,64,2);
			
			attackTimer = 0;
			
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
			
			spirit.x += (vel + Math.random()*vel/2) * direction.x * WizardsG.TIME_DIFF;
			spirit.y += (vel + Math.random()*vel/2) * direction.y * WizardsG.TIME_DIFF;
			
			if(spirit.x > xRange.y){
				direction.x = -1;
			} else if(spirit.x < xRange.x){
				direction.x = 1;
			}
			
			if(spirit.y > yRange.y){
				direction.y = -1;
			} else if(spirit.y < yRange.x){
				direction.y = 1;
			}
			
			var hp:HitPoints = spirit.getFirstEffect(["hp"],Effect.MATCH_ONE) as HitPoints;
			if(hp != null){
				if(hp.hitPoints < ohp){
					ohp = hp.hitPoints;
					//var xdiff = op.x - spirit.x;
					var xvel = (Math.random() * 30)-15
					spirit.x += xvel;
				}
				//trace(hp.hitPoints);
				var healthV:Number = (healthAmount - hp.hitPoints) / healthAmount;
				healthBar.bar.scaleX = 1 - healthV;
				
				if(hp.hitPoints <= 0){
					healthBar.visible = false;
					spirit.visible = false;
					clickArea.buttonMode = true;
				}
			}
			
			var iceEffect:Effect = spirit.getFirstEffect(["ice"],Effect.MATCH_ONE);
			if(iceEffect != null){
				vel = 40;
				spirit.filters = [normalFilter, freezeFilter];
			} else {
				vel = 220;
				spirit.filters = [normalFilter];
			}
			
			attackTimer += WizardsG.TIME_DIFF;
			if(attackTimer > ATTACK_TIME){
				//fire attack!
				//trace("attacking!");
				attackTimer = 0;
				var evt:Event = new Event("attackPlayer");
				dispatchEvent(evt);
				
				var anim = new AttackAnimation();
				anim.x = spirit.x;
				anim.y = spirit.y
				addChild(anim);
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