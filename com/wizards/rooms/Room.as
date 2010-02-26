package com.wizards.rooms
{
	import com.wizards.GameObject;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class Room extends MovieClip
	{

		protected var _spellTargets:Array;
		
		protected var _turnAroundArea:MovieClip;
		
		public function Room()
		{
			super();
			drawSideClickAreas();
			_turnAroundArea.buttonMode = true;
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
			_turnAroundArea.graphics.lineTo(50,0);
			_turnAroundArea.graphics.lineTo(50,600);
			_turnAroundArea.graphics.lineTo(0,600);
			_turnAroundArea.graphics.lineTo(0,0);
			_turnAroundArea.graphics.endFill();
			_turnAroundArea.graphics.moveTo(750,0);
			_turnAroundArea.graphics.beginFill(0xffffff,0);
			_turnAroundArea.graphics.lineTo(800,0);
			_turnAroundArea.graphics.lineTo(800,600);
			_turnAroundArea.graphics.lineTo(750,600);
			_turnAroundArea.graphics.lineTo(750,0);
			_turnAroundArea.graphics.endFill();
			
			addChild(_turnAroundArea);
		}
		
		public function update():void{
			
		}
	}
}