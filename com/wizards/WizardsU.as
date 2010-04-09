package com.wizards
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	//random collection of gobal utility functions
	public class WizardsU
	{
		public static function drawRect(rect:Rectangle, color:uint, obj:Sprite){
			obj.graphics.moveTo(rect.x,rect.y);
			obj.graphics.lineStyle(0,0,0);
			obj.graphics.beginFill(color,1);
			obj.graphics.lineTo(rect.x + rect.width, rect.y);
			obj.graphics.lineTo(rect.x + rect.width, rect.y + rect.height);
			obj.graphics.lineTo(rect.x, rect.y + rect.height);
			obj.graphics.lineTo(rect.x, rect.y);
			obj.graphics.endFill();
		}
	}
}