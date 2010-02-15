package com.wizards
{
	import flash.display.MovieClip;

	public class PlayArea extends MovieClip
	{
		private var _slot1Area:MovieClip;
		private var _slot2Area:MovieClip;
		private var _slot3Area:MovieClip;
		
		private var _slots:Array;
		private var _slotClips:Array;
		
		private var _ghost:MovieClip;
		
		public function PlayArea()
		{
			_slots = new Array();
			_slotClips = new Array();
			
			_slot1Area = new MovieClip();
			_slot2Area = new MovieClip();
			_slot3Area = new MovieClip();
			
			_slot2Area.x = 200;
			_slot3Area.x = 110;
			_slot3Area.y = 200;
			
			addChild(_slot1Area);
			addChild(_slot2Area);
			addChild(_slot3Area);
			
			_slotClips.push(_slot1Area);
			_slotClips.push(_slot2Area);
			_slotClips.push(_slot3Area);
			
			_slots[0] = new Array();
			_slots[1] = new Array();
			_slots[2] = new Array();
			
		}
		
		public function lockWord(word:String, slot:uint){
			var clip:MovieClip = new Symbol();
			clip.type.text = word;
			clip.x = clip.y = (_slotClips[slot].numChildren-1) * 10;
			_slotClips[slot].addChildAt(clip, _slotClips[slot].numChildren-1);
			if(_ghost.parent === _slotClips[slot]){
				_ghost.x = _ghost.y = _slotClips[slot].numChildren * 10;
			}
			
			_slots[slot].push(word);
		}
		
		public function clearSlot(slot:uint){
			_slots[slot] = new Array();
			removeChild(_slotClips[slot]);
			_slotClips[slot] = new MovieClip();
			addChild(_slotClips[slot]);
		}
		
		public function showGhostWord(word:String, slot:uint){
			if(_ghost == null){
				_ghost = new Symbol();
				_ghost.alpha = .7;
			}
			if(_ghost.type.text != word){
				_ghost.type.text = word;
			}
			_ghost.x = _ghost.y = _slotClips[slot].numChildren * 10;
			_slotClips[slot].addChild(_ghost);
		}
		
		public function hideGhostWord(){
			if(_ghost != null && _ghost.parent != null){
				_ghost.parent.removeChild(_ghost);
			}
		}
		
		public function getPhrase(slot:uint):Array{
			return _slots[slot];
		}
		
	}
}