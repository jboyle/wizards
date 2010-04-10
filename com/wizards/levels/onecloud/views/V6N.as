package com.wizards.levels.onecloud.views
{
	import com.wizards.GameObject;
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	import com.wizards.entities.Wraith;
	import com.wizards.levels.LevelEvent;
	import com.wizards.levels.Room;
	import com.wizards.levels.View;
	
	import flash.events.Event;

	public class V6N extends View
	{
		public var floatingSymbol:GameObject;
		
		private var _symbolGone:Boolean;
		public function V6N()
		{
			super();
			//trace(floatingSymbol);
			_symbolGone = false;
			addSpellTarget(floatingSymbol);
			
			var hp:HitPoints = new HitPoints(1, Effect.DURATION_FOREVER, 0);
			hp.addTag("hp");
			floatingSymbol.addEffect(hp);
		}
		
		override public function update():void{
			super.update();
			var hp:HitPoints = floatingSymbol.getFirstEffect(["hp"],Effect.MATCH_ALL) as HitPoints;
			if(hp == null && !_symbolGone){
				
				//trace(hp);
			
				killSymbol();
				_symbolGone = true;
				
			}
			
		}
		
		private function killSymbol(){
			floatingSymbol.visible = false;
			removeSpellTarget(floatingSymbol);
			createWraith();
			//_fader.addEventListener(Event.COMPLETE, handleFadeComplete);
			//fadeOut(1);
		}
		
		private function handleFadeComplete(ev:Event){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = 2;
			evt.room = "intro";
			evt.direction = Room.NORTH;
			evt.fadeIn = true;
			dispatchEvent(evt);
		}
		
		private function createWraith(){
			trace("creating wraith");
			var wraith:Wraith = new Wraith();
			wraith.setPosition(400,300);
			addChild(wraith);
			addSpellTarget(wraith);
		}
	}
}