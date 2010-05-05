package com.wizards.levels.intro
{
	import com.wizards.SoundManager;
	import com.wizards.WSound;
	import com.wizards.WizardsG;
	import com.wizards.levels.LevelEvent;
	import com.wizards.levels.Room;
	import com.wizards.levels.View;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	public class IntroView2 extends View
	{
		private var isComplete:Boolean = false;
		public var getTheBook:MovieClip;
		
		public function IntroView2()
		{
			super();
			SoundManager.MANAGER.loadSound("introTheme","data/sounds/wizards_theme.mp3");
			
			getTheBook.gotoAndStop(1);
			getTheBook.buttonMode = true;
			getTheBook.addEventListener(MouseEvent.CLICK, handleGetBook);
			getTheBook.addEventListener(MouseEvent.MOUSE_OVER, handleBookMouseOver);
			getTheBook.addEventListener(MouseEvent.MOUSE_OUT, handleBookMouseOut);
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
			if(fader.alpha == 1){
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
		
		override public function activate():void{
			var s:WSound = SoundManager.MANAGER.fadeInSound("introTheme",5);
			s.looped = true;
			if(fader.alpha == 1){
				fadeIn(1);
			}
			super.activate();
		}
		
		override public function deactivate():void{
			SoundManager.MANAGER.fadeOutSound("introTheme",5);
			super.deactivate();
		}
		
		private function handleBookMouseOver(ev:MouseEvent):void{
			getTheBook.gotoAndStop(2);
		}
		
		private function handleBookMouseOut(ev:MouseEvent):void{
			getTheBook.gotoAndStop(1);
		}
		
		private function handleGetBook(ev:MouseEvent):void{
			navigateToURL(new URLRequest("data/SymbolBook.pdf"));
		}
	}
}
