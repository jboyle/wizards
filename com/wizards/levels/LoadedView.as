package com.wizards.levels
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LoadedView extends View
	{
		protected var _loader:URLLoader;
		public function LoadedView(url:String)
		{
			super();
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleLoaderComplete);
			_loader.load(new URLRequest(url));
		}
		
		protected function handleLoaderComplete(ev:Event){
			this.addChildAt(_loader,0);
		}
		
	}
}