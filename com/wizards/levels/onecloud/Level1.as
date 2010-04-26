package com.wizards.levels.onecloud
{
	import com.wizards.levels.Level;
	import com.wizards.levels.Room;
	import com.wizards.levels.SceneRoom;
	import com.wizards.levels.TextSequence;
	import com.wizards.levels.onecloud.views.V6N;
	
	import flash.geom.Rectangle;
	
	public class Level1 extends Level
	{
		public function Level1()
		{
			super();
			
			var or:SceneRoom = new SceneRoom();
			or.addView(new TextSequence("" + 
					"I know who you are\n" + 
					"You are the chosen one\n" + 
					"The one who will understand the book\n" + 
					"And change the world","1",Room.NORTH),Room.NORTH);
			
			addRoom("opening", or);
			//room1
			var r1:Room = new Room();
			r1.addView(new V1N(),Room.NORTH);
			r1.addView(new V1E(),Room.EAST);
			r1.addView(new V1S(),Room.SOUTH);
			r1.addView(new V1W(),Room.WEST);
			addRoom("1",r1);
			
			var r2:Room = new Room();
			r2.addView(new V2N(), Room.NORTH);
			r2.addView(new V2E(), Room.EAST);
			r2.addView(new V2S(),Room.SOUTH);
			r2.addView(new V2W(), Room.WEST);
			addRoom("2",r2);
			
			var r3:Room = new Room();
			r3.addView(new V3N(), Room.NORTH);
			r3.addView(new V3E(), Room.EAST);
			r3.addView(new V3S(),Room.SOUTH);
			r3.addView(new V3W(), Room.WEST);
			addRoom("3",r3);
			
			var r4:Room = new Room();
			r4.addView(new V4N(), Room.NORTH);
			r4.addView(new V4E(), Room.EAST);
			r4.addView(new V4S(),Room.SOUTH);
			r4.addView(new V4W(), Room.WEST);
			addRoom("4",r4);
			
			var r5:Room = new Room();
			r5.addView(new V5N(), Room.NORTH);
			r5.addView(new V5E(), Room.EAST);
			r5.addView(new V5S(),Room.SOUTH);
			r5.addView(new V5W(), Room.WEST);
			addRoom("5",r5);
			
			var r6:Room = new Room();
			r6.addView(new V6N(), Room.NORTH);
			r6.addView(new V6E(), Room.EAST);
			r6.addView(new V6S(),Room.SOUTH);
			r6.addView(new V6W(), Room.WEST);
			addRoom("6",r6);
			
			linkRooms("1","2",Room.NORTH,Room.SOUTH,new Rectangle(300,200,200,200), new Rectangle(300,200,200,200));
			linkRooms("2","3",Room.EAST,Room.WEST,new Rectangle(300,200,200,200), new Rectangle(300,200,200,200));
			linkRooms("3","4",Room.EAST,Room.WEST,new Rectangle(300,200,200,200), new Rectangle(300,200,200,200));
			linkRooms("4","5",Room.NORTH,Room.SOUTH,new Rectangle(300,200,200,200), new Rectangle(300,200,200,200));
			linkRooms("5","6",Room.NORTH,Room.SOUTH,new Rectangle(300,200,200,200), new Rectangle(300,200,200,200));
			
			setRoom("opening",Room.NORTH);
		}

	}
}