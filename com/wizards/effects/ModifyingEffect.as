package com.wizards.effects
{
	import com.wizards.GameObject;
	
	import flash.events.IEventDispatcher;

	public class ModifyingEffect extends Effect
	{
		
		public static const AFFECT_FIRST:uint = 0;
		public static const AFFECT_ALL:uint = 1;
		
		protected var _searchTags:Array;
		protected var _matchType:uint;
		protected var _affect:uint;
	
		
		public function ModifyingEffect(matchType:uint, affect:uint, duration:uint, priority:uint, target:IEventDispatcher=null)
		{
			super(duration, priority, target);
			
			_matchType = matchType;
			_affect = affect;
			
			_searchTags = new Array();
		}
		
		public function addSearchTag(tag:String):void{
			_searchTags.push(tag);
		}
		
		public function addSearchTags(tags:Array):void{
			_searchTags = _searchTags.concat(tags);
		}
		
	}
}