package com.wizards
{
	import com.wizards.effects.DamageEffect;
	import com.wizards.effects.SelectEffect;
	
	public class SpellCreatorDelegate
	{
		static public const SELECT:uint = 0;
		static public const ATTACK:uint = 1;
		static public const MOVE:uint = 2;
		
		public function SpellCreatorDelegate()
		{
		}
		
		public function createSpell(id:int):Spell{
			var ret:Spell;
			if(id == SELECT){
				ret = new Spell(new SelectEffect(), new CoverSymbol(), Spell.ATTACH_INSTANT,["selectable"]);
			} else {
				ret = new Spell(new DamageEffect(5), new AttackSymbol(), Spell.ATTACH_INSTANT,["attackable"]);
			}
			return ret;
		}

	}
}