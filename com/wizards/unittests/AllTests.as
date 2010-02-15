package com.wizards.unittests
{
	import asunit.framework.TestSuite;

	public class AllTests extends TestSuite
	{
		public function AllTests()
		{
			super();
			addTest(new DisplayAreaTest("testInstantiation"));
			addTest(new DisplayAreaTest("testAddRemoveSymbol"));
			addTest(new DisplayAreaTest("testSymbolCollisions"));
			addTest(new DisplayAreaTest("testNoSymbolMovieClipCollide"));
			addTest(new DisplayAreaTest("testNoCollisionRepeat"));
			
			addTest(new PhraseTableTest("testInstantiated"));
			addTest(new PhraseTableTest("testAddPhrase"));
			addTest(new PhraseTableTest("testRemovePhrase"));
			addTest(new PhraseTableTest("testPhraseCombination"));
		}
		
	}
}