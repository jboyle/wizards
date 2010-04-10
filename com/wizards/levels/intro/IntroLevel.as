package com.wizards.levels.intro
{
	import com.wizards.levels.Level;
	import com.wizards.levels.SceneRoom;

	public class IntroLevel extends Level
	{
		public function IntroLevel()
		{
			super();
			
			var introRoom:SceneRoom = new SceneRoom();
			var introView:IntroView = new IntroView();
			
			introRoom.addView(introView);
			
			addRoom("intro",introRoom);
			
			setRoom("intro");
		}
		
	}
}