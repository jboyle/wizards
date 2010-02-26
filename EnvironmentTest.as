package
{
	import com.wizards.RoomController;
	import com.wizards.WizardsG;
	import com.wizards.rooms.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class EnvironmentTest extends MovieClip
	{
		private var _roomController:RoomController;
		public function EnvironmentTest()
		{
			super();
			
			_roomController = new RoomController();
			addChild(_roomController);
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			WizardsG.TIME = getTimer();
		}
		
		public function handleEnterFrame(ev:Event){
			var t:int = getTimer();
			WizardsG.TIME_DIFF = (t - WizardsG.TIME) / 1000;
			WizardsG.TIME = t;
			
			_roomController.update();
			
		}
		
	}
}