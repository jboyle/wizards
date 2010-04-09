package com.wizards.levels
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import com.wizards.WizardsU;

	public class View extends MovieClip
	{
		
		protected var _spellTargets:Array;
		
		protected var _turnLeftArea:TurnArea;
		protected var _turnRightArea:TurnArea;
		
		protected var _fader:Sprite;
		
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
			_fader = new Sprite();
			
			WizardsU.drawRect(new Rectangle(0,0,150,600),0xffffff,_turnLeftArea);
			WizardsU.drawRect(new Rectangle(0,0,150,600),0xffffff,_turnRightArea);
			WizardsU.drawRect(new Rectangle(0,0,800,600),0x000000,_fader);
			
			_turnRightArea.x = 650;
			
			_turnLeftArea.alpha = 0;
			_turnRightArea.alpha = 0;
			_fader.alpha = 0;
			
			_fader.mouseEnabled = false;
			
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
	}
}