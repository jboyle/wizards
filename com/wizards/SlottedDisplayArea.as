package com.wizards
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class SlottedDisplayArea extends DisplayArea
	{
		protected var _currentSlot:uint;
		public function SlottedDisplayArea()
		{
			super();
		}
		
		public function get slot():uint{
			return _currentSlot;
		}
		
		public function set slot(newSlot:uint):void{
			_currentSlot = newSlot;
		}
		
		protected function getSlotPosition():Point{
			return new Point((_currentSlot % 2) * 150, int(_currentSlot/2) * 150);
		}
		
		public override function addChild(child:DisplayObject):DisplayObject{
			var pos:Point = getSlotPosition();
			child.x = pos.x;
			child.y = pos.y;
			return super.addChild(child);
		}
		
	}
}