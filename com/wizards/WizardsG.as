package com.wizards
{
	import flash.geom.Point;
	
	public class WizardsG
	{
		
		public static const MARKER_OPEN:uint = 0;
		public static const MARKER_ATTACK:uint = 1;
		public static const MARKER_ICE:uint = 2;
		public static const MARKER_FIRE:uint = 3;
		
		
		public static var CROSSHAIR_POINT:Point;
		public static var MARKER_POSITION:Point;
		public static var MARKER_ROTATION:Number;
		public static var ACTIVE_MARKER:FLARDetectedMarkerInfo;
		public static var MARKER_TABLE:Array;
		
		
		public static var PLAYER_OBJECT:GameObject;
		public static var ACTIVE_OBJECTS:Array;
		
		public static var TIME:uint;
		public static var TIME_DIFF:Number;
		
		public static var SYNTAX:XMLList;
		public static var TIMING:XMLList;
		public static var SPELLS:XMLList;
		
		
		public function WizardsG()
		{
		}

	}
}