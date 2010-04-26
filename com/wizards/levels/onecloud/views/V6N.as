package com.wizards.levels.onecloud.views
{
	import com.wizards.WizardsG;
	import com.wizards.entities.Door1Symbol;
	import com.wizards.levels.LevelEvent;
	import com.wizards.levels.Room;
	import com.wizards.levels.TurnArea;
	import com.wizards.levels.View;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class V6N extends View
	{
		public var door:MovieClip;
		public var symbol:Door1Symbol;
		
		private var _symbolGone:Boolean;
		
		private var _animationTimer:Number;
		private var _shrinkTime:Number;
		private var _fadeTime:Number;
		
		private var _shrinking:Boolean;
		private var _fading:Boolean;
		
		private var _symbolDead:Boolean;
		
		private var forwardArea:TurnArea;
		public function V6N()
		{
			super();
			_symbolGone = false;
			addSpellTarget(symbol);
			_shrinking = false;
			_shrinkTime = 1;
			_fading = false;
			_fadeTime = .3;
			
			_animationTimer = 0;
			
			_symbolDead = false;
			
			//symbol.addEventListener(MouseEvent.CLICK, fadeInSymbol);
			symbol.addEventListener(Event.COMPLETE,handleSymbolFadeInComplete);
			symbol.tags = ["attackable"];
		}
		
		override public function update():void{
			trace("view update");
			super.update();
			
			if(_shrinking){
				_animationTimer += WizardsG.TIME_DIFF;
				if(_animationTimer < _shrinkTime){
					var u = _animationTimer / _shrinkTime;
					door.scaleX = door.scaleY = .7 + .3*(1-u);
					symbol.scaleX = symbol.scaleY = .7 + .3*(1-u);
				} else {
					_shrinking = false;
					_fading = true;
					_animationTimer = 0;
				}
			}
			
			if(_fading){
				_animationTimer += WizardsG.TIME_DIFF;
				if(_animationTimer < _fadeTime){
					var u = _animationTimer / _fadeTime;
					door.alpha = 1-u;
					symbol.alpha = 1-u;
				} else {
					door.visible = false;
					symbol.visible = false;
					_fading = false;
					openDoor();
				}
			}
			
		}
		
		private function fadeInSymbol(){
			symbol.addEventListener(Event.COMPLETE,handleSymbolFadeInComplete);
			symbol.fadeIn();
		}
		
		private function handleSymbolFadeInComplete(ev:Event){
			_shrinking = true;
		}
		
		private function openDoor(){
			trace("open door");
			this._fader.addEventListener(Event.COMPLETE, handleFadeComplete);
			this.fadeOut(0.5);
		}
		
		override protected function handleObjectDeath(ev:Event):void{
			if(ev.target != symbol){
				super.handleObjectDeath(ev);
			}
		}
		private function handleFadeComplete(ev:Event){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);
			evt.level = 2;
			evt.room = "intro";	
			evt.direction = Room.NORTH;
			evt.fadeIn = true;
			dispatchEvent(evt);	
			trace("V6N View sent CHANGE_LEVEL event");
		}
	}
}