package com.wizards
{
	import flash.display.MovieClip;

	public class MagicSymbol extends MovieClip
	{
		public static const ATTACK_TYPE:String = "attack";
		public static const OPEN_TYPE:String = "open";
		public var symbolPoint:MovieClip;
		
		public function MagicSymbol(type:String)
		{
			super();
			
			var typeClip:MovieClip;
			if(type == "attack"){
				typeClip = new AttackSymbol();
			} else if(type == "open"){
				typeClip = new CoverSymbol();
			} else {
				typeClip = null;
			}
			
			if(typeClip != null){
				typeClip.width = typeClip.height = 25;
			
				symbolPoint.addChild(typeClip);
			}
		}
		
	}
}