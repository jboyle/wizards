package com.wizards.levels.scenarios
{
	import com.wizards.entities.Wraith;
	import com.wizards.levels.Level;
	import com.wizards.levels.Room;
	import com.wizards.levels.SceneRoom;
	import com.wizards.levels.TextSequence;
	import com.wizards.levels.View;

	public class FightScenario extends Level
	{
		public function FightScenario()
		{
			super();
			
			var or:SceneRoom = new SceneRoom();
			or.addView(new TextSequence("" + 
					"You must use this magic\n" + 
					"To defeat your foes\n" + 
					"Tilt the book towards them\n" + 
					"And they will not excape your grasp", "1", Room.NORTH),Room.NORTH);
			
			var r1:Room = new Room();
			var view:View = new V2S();
			view.disableMovement();
			var wraith:Wraith = new Wraith();
			wraith.setPosition(400,300);
			view.addChild(wraith);
			view.addSpellTarget(wraith);
			
			r1.addView(view,Room.NORTH);
			
			addRoom("intro", or);
			addRoom("1",r1);
			
			setRoom("intro", Room.NORTH);
			
					
				
		}
		
	}
}