package com.wizards.levels
{
	import com.wizards.GameObject;
	import com.wizards.WizardsU;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class View extends MovieClip
	{
		
		protected var _spellTargets:Array;
		
		protected var _turnLeftArea:TurnArea;
		protected var _turnRightArea:TurnArea;
		
		protected var _fader:Fader;
		
		protected var _turnLeftActive:Boolean;
		protected var _turnRightActive:Boolean;
		
		protected var _hitArea:MovieClip;
		protected var _targetRoom:String;
		protected var _targetDirection:uint;
		
		protected var _leftCursor:MovieClip;
		protected var _rightCursor:MovieClip;
		
		public function View()
		{
			super();
			
			_turnLeftActive = true;
			_turnRightActive = true;
			_turnLeftArea = new TurnArea();
			_turnRightArea = new TurnArea();
			_fader = new Fader();
			
			WizardsU.drawRect(new Rectangle(0,0,150,600),0xffffff,_turnLeftArea);
			WizardsU.drawRect(new Rectangle(0,0,150,600),0xffffff,_turnRightArea);
			
			_turnRightArea.x = 650;
			
			_turnLeftArea.alpha = 0;
			_turnRightArea.alpha = 0;
			
			_turnLeftArea.addEventListener(MouseEvent.CLICK, handleLeftClick);
			_turnRightArea.addEventListener(MouseEvent.CLICK, handleRightClick);
			
			addChild(_turnLeftArea);
			addChild(_turnRightArea);
			addChild(_fader);
			
			_leftCursor = new LeftArrow();
			_rightCursor = new RightArrow();
			
			addChild(_leftCursor);
			addChild(_rightCursor);
			
			_leftCursor.visible = false;
			_rightCursor.visible = false;
			
			_turnLeftArea.cursor = _leftCursor;
			_turnRightArea.cursor = _rightCursor;
			
		}
		
		public function update():void{
			//update code
			_fader.update();
		}
		
		public function getSpellCollision(tx:Number, ty:Number):GameObject{
			var tRect:Rectangle = new Rectangle(tx-25,ty-25,50,50);
			var ret:GameObject = null;
			var s:GameObject;
			for(var i in  _spellTargets){
				s = _spellTargets[i] as GameObject;
				var nrect:Rectangle = new Rectangle(s.x, s.y, s.width, s.height);
				if(tRect.intersects(nrect)){
					ret = s;
					break;
				}
			}
			return ret;
		}
		
		public function addSpellTarget(obj:GameObject):void{
			_spellTargets.push(obj);
		}
		
		public function fadeIn(seconds:Number){
			_fader.alpha = 1;
			_fader.startFade(seconds,Fader.FADE_IN);
		}
		
		public function fadeOut(seconds:Number){
			_fader.alpha = 0;
			_fader.startFade(seconds,Fader.FADE_OUT);
		}
		
		protected function handleLeftClick(ev:MouseEvent){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_DIRECTION);
			evt.direction = Room.LEFT;
			dispatchEvent(evt);
		}
		
		protected function handleRightClick(ev:MouseEvent){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_DIRECTION);
			evt.direction = Room.RIGHT;
			dispatchEvent(evt);
		}
		
		protected function handleHitAreaClick(ev:MouseEvent){
			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_ROOM);
			evt.room = _targetRoom;
			evt.direction = _targetDirection;
			dispatchEvent(evt);
		}
		
		public function setHitArea(hitArea:MovieClip,room:String,direction:uint){
			_hitArea = hitArea;
			_targetRoom = room;
			_targetDirection = direction;
			
			_hitArea.addEventListener(MouseEvent.CLICK, handleHitAreaClick);
			
			_hitArea.buttonMode = true;
			addChild(_hitArea);
		}
		
		public function set leftCursor(nc:MovieClip):void{
			_turnLeftArea.cursor = nc;
		}
		
		public function set rightCursor(nc:MovieClip):void{
			_turnRightArea.cursor = nc;
		}
		
		public function get fader():Fader{
			return _fader;
		}
		
		
	}
}