package com.wizards.levels
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class TurnArea extends Sprite
	{
		public var cursor:MovieClip;
		public function TurnArea()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			
			//addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			//stage.addEventListener(Event.MOUSE_LEAVE, handleMouseLeave);
		}
		
		private function handleMouseOver(ev:MouseEvent){
			if(cursor != null){
				Mouse.hide();
				cursor.x = ev.stageX;
				cursor.y = ev.stageY;
				cursor.visible = true;
				addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			}
		}
		
		private function handleMouseOut(ev:MouseEvent){
			if(cursor != null){
				Mouse.show();
				cursor.x = ev.stageX;
				cursor.y = ev.stageY;
				cursor.visible = false;
				removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			}
		}
		
		private function handleMouseMove(ev:MouseEvent){
			cursor.x = ev.stageX;
			cursor.y = ev.stageY;
			ev.updateAfterEvent();
			
		}
		
		private function handleMouseLeave(ev:Event){
			handleMouseOut(new MouseEvent(MouseEvent.MOUSE_MOVE));
		}
		
	}
}