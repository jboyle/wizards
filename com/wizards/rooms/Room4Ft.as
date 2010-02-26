package com.wizards.rooms
{
	import com.wizards.GameObject;
	import com.wizards.effects.Effect;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Room4Ft extends Room
	{
		public var clickArea:MovieClip;
		public var fireWall:GameObject;
		public var iceWall:GameObject;
		public var iceBridge:GameObject;
		
		private var _frozenFlame:Boolean;
		private var _meltedIce:Boolean;
		public function Room4Ft()
		{
			super();
			
			_turnAroundArea.addEventListener(MouseEvent.CLICK, handleTurnAround);
			
			fireWall.addEventListener(MouseEvent.CLICK, stopFireWall);
			iceWall.addEventListener(MouseEvent.CLICK, stopIceWall);
			clickArea.addEventListener(MouseEvent.CLICK, handleClick);
			
			iceBridge.visible = false;
			_frozenFlame = false;
			_meltedIce = false;
		}
		
		private function handleTurnAround(ev:MouseEvent){
			var evt:RoomEvent = new RoomEvent("4_bk",RoomEvent.CHANGE_ROOM);
			dispatchEvent(evt);
		}
		
		private function stopFireWall(ev:MouseEvent){
			var effect:Effect = new Effect(Effect.DURATION_TIMED,0);
			effect.addTag("ice");
			effect.time = 1;
			
			fireWall.addEffect(effect);
		}
		
		private function stopIceWall(ev:MouseEvent){
			trace("badger");
			var effect:Effect = new Effect(Effect.DURATION_TIMED,0);
			effect.addTag("fire");
			effect.time = 1;
			
			iceWall.addEffect(effect);
		}
		
		
		override public function update():void{
			
			fireWall.update();
			iceBridge.update();
			iceWall.update();
			
			var e1:Effect = fireWall.getFirstEffect(["ice"],Effect.MATCH_ONE);
			if(e1 != null){
				fireWall.visible = false;
				iceBridge.visible = true;
				_frozenFlame = true;
			} else {
				_frozenFlame = false;
				fireWall.visible = true;
				iceBridge.visible = false;
			}
			
			var e2:Effect = iceWall.getFirstEffect(["fire"],Effect.MATCH_ONE);
			if(e2 != null){
				iceWall.visible = false;
				_meltedIce = true;
			} else {
				iceWall.visible = true;
				_meltedIce = false;
			}
			
			clickArea.buttonMode = (_meltedIce && _frozenFlame);
			
		}
		
		private function handleClick(ev:MouseEvent){
			if(_meltedIce && _frozenFlame){
				var evt:RoomEvent = new RoomEvent("5_ft",RoomEvent.CHANGE_ROOM);
				dispatchEvent(evt);
			}
		}
		
		
	}
}