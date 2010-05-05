package com.wizards.levels.intro
{
	import com.wizards.SoundManager;
	import com.wizards.WSound;
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
			SoundManager.MANAGER.loadSound("introTheme","data/sounds/wizards_theme.mp3");
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
		
		override public function activate():void{
			var s:WSound = SoundManager.MANAGER.fadeInSound("introTheme",5);
			s.looped = true;
			super.activate();
		}
		
		override public function deactivate():void{
			SoundManager.MANAGER.fadeOutSound("introTheme",5);
			super.deactivate();
		}
	}
}
