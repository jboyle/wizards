package com.wizards.levels.onecloud.views
{
	import com.wizards.GameObject;
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
			floatingSymbol.tags = ["attackable"]
			floatingSymbol.addEventListener("killed", killSymbol);
			addSpellTarget(floatingSymbol);
			
			
		}
		
		override public function update():void{
			super.update();
			
			trace(floatingSymbol.hp);
		}
		private function killSymbol(ev:Event){
			floatingSymbol.visible = false;
			removeSpellTarget(floatingSymbol);
			//createWraith();
			_fader.addEventListener(Event.COMPLETE, handleFadeComplete);
			fadeOut(1);
		}
		
		private function handleFadeComplete(ev:Event){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = 2;
			evt.room = "intro";
			evt.direction = Room.NORTH;
			evt.fadeIn = true;
			dispatchEvent(evt);
		}
	}
}