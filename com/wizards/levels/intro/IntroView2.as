package com.wizards.levels.intro
{
	import com.wizards.WizardsG;
	import com.wizards.levels.LevelEvent;
	import com.wizards.levels.Room;
	import com.wizards.levels.View;
	
	import flash.events.Event;
	
	
	public class IntroView2 extends View
	{
		var isComplete:Boolean = false;
		
		public function IntroView2()
		{
			super();
		}
		
		override public function update():void
		{
			super.update();
			// check AR marker
			if(WizardsG.ACTIVE_MARKER!=null && !isComplete)
			{
				trace(WizardsG.ACTIVE_MARKER.codeId);
				if(WizardsG.ACTIVE_MARKER.codeId == 0)
				{
					isComplete = true;
					this._fader.addEventListener(Event.COMPLETE, handleFadeComplete);
					this.fadeOut(1);
				}
			}
		}
		
		private function handleFadeComplete(ev:Event):void
		{
			// move to next level!!
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = 1;	
			evt.room = "opening";	
			evt.direction = Room.NORTH;
			evt.fadeIn = true;
			dispatchEvent(evt);	
			trace("IntroView2 sent CHANGE_LEVEL event");
		}
	}
}
