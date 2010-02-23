package
{
	
	import com.wizards.GameController;
	import com.wizards.InputManager;
	import com.wizards.WizardsG;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	public class Main extends MovieClip
	{
		public static var TIME_DIFF:Number;
		public static var TIME:uint;
		
		private var _total:uint;
		private var _inputManager:InputManager;
		private var _loader:URLLoader;
		private var _data:XML;
		
		private var _gameController:GameController;
		
		public function Main()
		{
			_inputManager = new InputManager();
			_loader = new URLLoader();
			
			WizardsG.TIME = 0;
			WizardsG.TIME_DIFF = 0;
			
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			
			_loader.load(new URLRequest("data/spell_data.xml"));			
			
			
		}
		
		private function onLoadComplete(ev:Event){
			_data = new XML(_loader.data);
			setupKeys(_data.keyMapping);
			WizardsG.SPELLS = _data.spells;
			WizardsG.SYNTAX = _data.syntax;
			WizardsG.TIMING = _data.timing
			
			_gameController = new GameController(_inputManager);
			addChild(_gameController);
			
			_gameController.addEventListener("gameOver", handleGameOver);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _inputManager.handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, _inputManager.handleKeyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function setupKeys(keyData:XMLList){
			//trace(keyData.toXMLString());
			for each(var key:XML in keyData.children()){
				_inputManager.addWord(key.@code,key.word, InputManager.getSideVal(key.side));
			}
		}
		
		private function onEnterFrame(ev:Event){
			var t:uint = getTimer();
			WizardsG.TIME_DIFF = (t-WizardsG.TIME)/1000;
			WizardsG.TIME = t;
			
			_gameController.update();
			
			p1stats.hp.text = _gameController.leftPlayerHP;
			p2stats.hp.text = _gameController.rightPlayerHP;
		}
		
		private function handleGameOver(ev:Event){
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	}
}