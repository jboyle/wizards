package com.wizards.unittests
{
	import asunit.framework.TestCase;
	
	import com.wizards.PhraseTable;
	import com.wizards.Symbol;

	public class PhraseTableTest extends TestCase
	{
		private var instance:PhraseTable;
		public function PhraseTableTest(testMethod:String=null)
		{
			super(testMethod);
		}
		
		protected override function setUp():void{
			instance = new PhraseTable;
		}
		
		protected override function cleanUp():void{
			instance = null;
		}
		
		public function testInstantiated():void{
			assertTrue(instance is PhraseTable);
		}
		
		public function testAddPhrase():void{
			var symbol:Symbol = new Symbol("test");
			var ret = instance.addPhrase(symbol);
			
			assertTrue(ret is Array);
			
			var phraseTable:Array = instance.table;
			assertEquals(phraseTable[0][0],symbol);
		}
		
		public function testRemovePhrase():void{
			var symbol:Symbol = new Symbol("test");
			var phrase:Array = instance.addPhrase(symbol);
			
			assertEquals(instance.table.length, 1);
			
			instance.removePhrase(phrase);
			
			assertEquals(instance.table.length, 0);
		}
		
		public function testPhraseCombination():void{
			var s1:Symbol = new Symbol("test");
			var s2:Symbol = new Symbol("test");
			
			instance.addPhrase(s1);
			instance.addPhrase(s2);
			
			assertEquals(instance.table.length, 2);
			
			instance.combinePhrases(s1,s2);
			
			assertEquals(instance.table.length,1);
			assertEquals(instance.table[0][0], s1);
			assertEquals(instance.table[0][1], s2);
			
			var s3:Symbol = new Symbol("test");
			var s4:Symbol = new Symbol("test");
			var s5:Symbol = new Symbol("test");
			
			instance.addPhrase(s3);
			instance.addPhrase(s4);
			instance.addPhrase(s5);
			
			assertEquals(instance.table.length,4);
			assertEquals(instance.table[1][0],s3);
			assertEquals(instance.table[2][0],s4);
			assertEquals(instance.table[3][0],s5);
			
			instance.combinePhrases(s1,s3);
			instance.combinePhrases(s5,s4);
			
			assertEquals(instance.table.length,2);
			assertEquals(instance.table[0][2],s3);
			assertEquals(instance.table[1][0],s5);
			assertEquals(instance.table[1][1],s4);
			
		}
		
	}
}