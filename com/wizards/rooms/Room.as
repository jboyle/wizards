package com.wizards.rooms
{
	import com.wizards.GameObject;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;

	public class Room extends MovieClip
	{

		protected var _spellTargets:Array;
		
		protected var _turnAroundArea:MovieClip;
		
		protected var _forwardArrow:MovieClip;
		protected var _turnAroundArrow:MovieClip;
		protected var _forwardArea:MovieClip;
		
		protected var _showForward:Boolean;
		protected var _showTurnAround:Boolean;
		
		public function Room()
		{
			super();
			drawSideClickAreas();
			_turnAroundArea.buttonMode = true;
			_spellTargets = new Array();
			
			_forwardArrow = new ForwardArrow();
			_turnAroundArrow = new TurnAroundArrow();
			
			_forwardArrow.visible = false;
			addChild(_forwardArrow);
			
			_turnAroundArrow.visible = false;
			addChild(_turnAroundArrow);
			
			_showForward = false;
			_showTurnAround = false;
			
			
			_turnAroundArea.addEventListener(MouseEvent.MOUSE_OVER, showTurnAroundArrow);
			_turnAroundArea.addEventListener(MouseEvent.MOUSE_OUT, hideTurnAroundArrow);
		}
		
		public function setForwardArea(fa:MovieClip){
			/*_forwardArea = fa;
			_forwardArea.addEventListener(MouseEvent.MOUSE_OVER, showForwardArrow);
			_forwardArea.addEventListener(MouseEvent.MOUSE_OUT, hideForwardArrow);*/
		}
		
		public function addSpellTarget(gObj:GameObject){
			_spellTargets.push(gObj);
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
		
		protected function drawSideClickAreas(){
			_turnAroundArea = new MovieClip();
			_turnAroundArea.graphics.lineStyle(0,0xffffff,0);
			_turnAroundArea.graphics.moveTo(0,0);
			_turnAroundArea.graphics.beginFill(0xffffff,0);
			_turnAroundArea.graphics.lineTo(150,0);
			_turnAroundArea.graphics.lineTo(150,600);
			_turnAroundArea.graphics.lineTo(0,600);
			_turnAroundArea.graphics.lineTo(0,0);
			_turnAroundArea.graphics.endFill();
			_turnAroundArea.graphics.moveTo(650,0);
			_turnAroundArea.graphics.beginFill(0xffffff,0);
			_turnAroundArea.graphics.lineTo(800,0);
			_turnAroundArea.graphics.lineTo(800,600);
			_turnAroundArea.graphics.lineTo(650,600);
			_turnAroundArea.graphics.lineTo(650,0);
			_turnAroundArea.graphics.endFill();
			
			addChild(_turnAroundArea);
		}
		
		protected function showTurnAroundArrow(ev:MouseEvent){
			Mouse.hide();
			_turnAroundArrow.visible = true;
			_turnAroundArea.addEventListener(MouseEvent.MOUSE_MOVE, moveTurnAroundCursor);
		}
		
		protected function hideTurnAroundArrow(ev:MouseEvent){
			Mouse.show();
			_turnAroundArrow.visible = false;
			_turnAroundArea.removeEventListener(MouseEvent.MOUSE_MOVE, moveTurnAroundCursor);
		}
		
		protected function moveTurnAroundCursor(ev:MouseEvent){
			_turnAroundArrow.x = ev.stageX;
			_turnAroundArrow.y = ev.stageY;
		}
		
		protected function showForwardArrow(ev:MouseEvent){
			Mouse.hide();
			_forwardArrow.visible = true;
			_forwardArea.addEventListener(MouseEvent.MOUSE_MOVE, moveForwardArrow);
		}
		
		protected function hideForwardArrow(ev:MouseEvent){
			Mouse.show();
			_forwardArrow.visible = false;
			_forwardArea.removeEventListener(MouseEvent.MOUSE_MOVE, moveForwardArrow);
		}
		
		protected function moveForwardArrow(ev:MouseEvent){
			_forwardArrow.x = ev.stageX;
			_forwardArrow.y = ev.stageY;
		}
		
		public function update():void{
			
		}
		
		
	}
}