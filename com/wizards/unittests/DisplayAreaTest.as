package com.wizards.unittests
{
	import asunit.framework.TestCase;
	
	import com.wizards.CollisionEvent;
	import com.wizards.DisplayArea;
	import com.wizards.Symbol;
	
	import flash.events.Event;

	public class DisplayAreaTest extends TestCase
	{
		private var instance:DisplayArea;
		
		private var c1:Symbol;
		private var c2:Symbol;
		private var c3:Symbol;
		public function DisplayAreaTest(testMethod:String=null)
		{
			super(testMethod);
		}
		
		protected override function setUp():void{
			instance = new DisplayArea();
		}
		
		protected override function tearDown():void{
			instance = null;
			c1 = null;
			c2 = null;
			c3 = null;
		}
		
		public function testInstantiation():void{
			assertTrue("Instantiated",instance is DisplayArea);
		}
		
		public function testAddRemoveSymbol():void{
			c1 = new Symbol("test");
			
			instance.addSymbol(c1);
			assertEquals(instance.numSymbols, 1);

			instance.removeSymbol(c1);
			assertEquals(instance.numSymbols, 0);
		}
		
		public function testSymbolCollisions():void{
			c1 = new Symbol("test");
			c2 = new Symbol("test");
			c3 = new Symbol("test");
			
			//this one should collide
			c2.clip.x = 10;
			c2.clip.y = 10;
			
			//this one shouldn't
			c3.clip.x = 300;
			c3.clip.y = 300;
			
			instance.addSymbol(c1);
			instance.addSymbol(c2);
			instance.addSymbol(c3);
			
			instance.addEventListener(CollisionEvent.COLLISION, function(ev:CollisionEvent):void {
				assertEquals(ev.object1,c1);
				assertEquals(ev.object2,c2);
			});
			
			instance.update();
			
			c2.clip.x = -1000;
			c2.clip.y = -1000;
			
			instance.addEventListener(CollisionEvent.UNCOLLISION, addAsync(function(ev:CollisionEvent):void {
				assertEquals(ev.object1,c1);
				assertEquals(ev.object2,c2);
			}));
			
			instance.update();
		}
		
		public function testNoSymbolMovieClipCollide():void{
			c1 = new Symbol("test");
			c2 = new Symbol("test");
			
			c2.clip.x = 10;
			c2.clip.y = 10;
			
			instance.addSymbol(c1);
			instance.addChild(c2.clip);
			
			instance.addEventListener(CollisionEvent.COLLISION, addAsync(null,DEFAULT_TIMEOUT,function(ev:Event):void{
				//do nothing
			}));
			
			instance.update();
		}
		
		public function testNoCollisionRepeat():void{
			c1 = new Symbol("test");
			c2 = new Symbol("test");
			
			c2.clip.x = 10;
			c2.clip.y = 10;
			
			instance.addSymbol(c1);
			instance.addChild(c2.clip);
			
			instance.update();
			
			instance.addEventListener(CollisionEvent.COLLISION, addAsync(function(ev:CollisionEvent):void{
				fail("Should not have been called!");
			},DEFAULT_TIMEOUT,function(ev:Event):void{
				//do nothing
			}));
			
			instance.update();
		}
		
	}
}